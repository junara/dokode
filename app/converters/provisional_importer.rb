# frozen_string_literal: true

require 'geocoder'
require 'httpclient'
require 'json'

module ProvisionalImporter
  module_function

  def delete_and_import_csv(input)
    ProvisionalEvent.delete_all
    import_csv(input)
  end

  def import_csv(input)
    CSV.foreach(input, headers: true) do |row|
      ProvisionalEvent.create(provisional_event_params(row))
    end
  end

  def check_place
    ProvisionalEvent.all.each do |provisional_event|
      next if provisional_event.place.blank?
      venues = provisional_event.place['venue'] || []
      prefecture = provisional_event.place['prefecture']
      array = venues.map do |venue|
        query = [prefecture, venue].join(' ')
        text_search_results = CustomGoogleMap::TextSearch.get_results(query)
        name = CustomGoogleMap::TextSearch.extract(text_search_results, 'name')
        place_id = CustomGoogleMap::TextSearch.extract(text_search_results, 'place_id')
        place_id_result = CustomGoogleMap::PlaceIdSearch.get_result(place_id)
        {
          original_name: venue,
          prefecture: prefecture,
          google_name: name,
          place_id: place_id,
          place_id_result: place_id_result
        }
      end
      provisional_event.update(normalized_place: { venue: array })
    end
  end

  def create_event(provisional_event)
    Event.create(
      name: provisional_event.name,
      url: provisional_event.url,
      start_at: provisional_event.start_at,
      end_at: provisional_event.end_at,
      content: provisional_event.content,
      sponsor: provisional_event.sponsor,
      sponsor_url: provisional_event.sponsor_url,
      organizer: provisional_event.organizer,
      organizer_affiliation: provisional_event.organizer_affiliation,
      source: provisional_event.source,
      category: provisional_event.category,
      country: provisional_event.country,
      num_event: provisional_event.num_event
    )
  end

  def create_event_venues(event, provisional_event)
    return if provisional_event&.normalized_place.blank?
    venues = provisional_event&.normalized_place['venue'] # rubocop:disable Lint/SafeNavigationChain
    venues&.each do |venue|
      place_id = venue['place_id']
      EventVenue.create(
        event_id: event.id,
        place_id: place_id,
        name: venue['original_name'],
        prefecture: venue['prefecture']
      )
      create_venue(place_id, venue['place_id_result'], venue['google_name'])
    end
  end

  def create_venue(place_id, place_id_result = nil, _name = nil)
    place_id_result ||= CustomGoogleMap::PlaceIdSearch.get_result(place_id)
    Venue.create(venue_params(place_id, place_id_result)) if Venue.where(place_id: place_id).blank?
  end

  def sync_to_event
    Event.delete_all
    EventVenue.delete_all
    Venue.delete_all
    ProvisionalEvent.all.each do |provisional_event|
      event = create_event(provisional_event)
      create_event_venues(event, provisional_event) if event.present?
    end
  end

  private

  def provisional_event_params(row)
    params = {}
    %w[name url sponsor sponsor_url organizer organizer_affiliation source category num_event content].each do |attr|
      params[attr.to_sym] = row[attr]
    end
    params[:country] = row['country'] || '日本'
    params[:start_at] = Time.zone.parse(row['start_at']).beginning_of_day
    params[:end_at] = row['end_at'] ? Time.zone.parse(row['end_at']).end_of_day : Time.zone.parse(row['start_at']).end_of_day
    params[:place] = row['place'].present? && JSON.parse(row['place'])
    params
  end

  def venue_params(place_id, place_id_result)
    params = {}
    %w[postal_code country prefecture city ward website formatted_address formatted_phone_number].each do |attr|
      params[attr.to_sym] = CustomGoogleMap::PlaceIdSearch.extract(place_id_result, attr)
    end
    params[:latitude] = CustomGoogleMap::PlaceIdSearch.extract(place_id_result, 'lat')
    params[:longitude] = CustomGoogleMap::PlaceIdSearch.extract(place_id_result, 'lng')
    params[:place_id] = place_id
    params[:result_cache] = place_id_result
    params[:name] = name || CustomGoogleMap::PlaceIdSearch.extract(place_id_result, 'name')
    params
  end
end
