# frozen_string_literal: true

# Description/Explanation of Person class
class City < ApplicationRecord
  has_many :city_jobs
  has_many :jobs, through: :city_jobs

  def self.top_hot
    hash = {}
    data_cities = City.all
    data_cities.each do |val|
      hash[val.name] = val.jobs.count
    end
    hash.sort_by { |k, v| v }.reverse
  end
end
