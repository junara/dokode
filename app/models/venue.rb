# frozen_string_literal: true

class Venue < ApplicationRecord
  has_many :event_venues, foreign_key: :place_id, primary_key: :place_id, inverse_of: :venue, dependent: :nullify
  has_many :events, through: :event_venues, inverse_of: :venues
end
