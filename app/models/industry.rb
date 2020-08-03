# frozen_string_literal: true

# Description/Explanation of Person class
class Industry < ApplicationRecord
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs
  scope :top_industries, ->(number) do joins(:jobs)
    .group(:industry_id)
    .order(Arel.sql('count(jobs.id) DESC'))
    .take(number)
  end
end
