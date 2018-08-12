# frozen_string_literal: true

class Communication < ApplicationRecord
  belongs_to :event, optional: true
  validates :body, presence: true, length: { maximum: 1000 }
end
