# frozen_string_literal: true

# Description/Explanation of Person class
class City < ApplicationRecord
  has_many :city_jobs
  has_many :jobs, through: :city_jobs
end
