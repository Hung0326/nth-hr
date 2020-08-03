# frozen_string_literal: true

# Description/Explanation of Person class
class City < ApplicationRecord
  RANGE = 69
  has_many :city_jobs
  has_many :jobs, through: :city_jobs
  enum area: { international: 0, domestic: 1 }
end
