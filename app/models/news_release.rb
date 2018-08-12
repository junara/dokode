# frozen_string_literal: true

class NewsRelease < ApplicationRecord
  validates :body, presence: true, length: { maximum: 1000 }
end
