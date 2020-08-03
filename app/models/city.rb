# frozen_string_literal: true

# Description/Explanation of Person class
class City < ApplicationRecord
  has_many :city_jobs
  has_many :jobs, through: :city_jobs
  scope :domestic, ->{ where(area: 1)}
  scope :international, ->{ where(area: 0)}
  scope :top_cities, ->(number) do joins(:jobs)
    .group(:city_id)
    .order(Arel.sql('count(jobs.id) DESC'))
    .take(number)
  end

end
