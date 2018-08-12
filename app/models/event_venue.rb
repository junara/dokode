# frozen_string_literal: true

class EventVenue < ApplicationRecord
  belongs_to :event, optional: true, inverse_of: :event_venues
  belongs_to :venue, foreign_key: :place_id, primary_key: :place_id, optional: true, inverse_of: :event_venues
end
