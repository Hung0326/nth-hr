# frozen_string_literal: true

# Description/Explanation of Person class
class Industry < ApplicationRecord
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs

  def self.top_hot
    hash = {}
    data_industries = Industry.all
    data_industries.each do |val|
      hash[val.name] = val.jobs.count
    end
    hash = hash.select { |k, v| v.positive? }
    hash.sort_by { |k, v| v }.reverse
  end
end
