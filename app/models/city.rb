# frozen_string_literal: true

# Description/Explanation of Person class
class City < ApplicationRecord
  before_save :convert_to_slug
  RANGE = 69
  has_many :city_jobs
  has_many :jobs, through: :city_jobs
  enum area: { international: 0, domestic: 1 }
  scope :domestic, -> { where(area: 1) }
  scope :international, -> { where(area: 0) }
  scope :all_cities, -> { select :id, :name }
  scope :top_cities, ->(number) do joins(:jobs)
    .group(:city_id)
    .order(Arel.sql('count(jobs.id) DESC'))
    .take(number)
  end

  def convert_to_slug
    self.slug = Slug.to_slug(self.name + ' ' + rand(10000).to_s)
  end
end
