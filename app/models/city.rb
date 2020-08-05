# frozen_string_literal: true

# Description/Explanation of Person class
class City < ApplicationRecord
  RANGE = 69
  has_many :city_jobs
  has_many :jobs, through: :city_jobs  
  enum area: { international: 0, domestic:1}
  has_many :jobs, through: :city_jobs
  scope :domestic, -> { where(area: 1) }
  scope :international, -> { where(area: 0) }
  scope :all_cities, -> { select :id, :name }
  scope :top_cities, ->(number) do joins(:jobs)
    .group(:city_id)
    .order(Arel.sql('count(jobs.id) DESC'))
    .take(number)
  end
end
