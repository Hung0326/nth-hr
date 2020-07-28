# frozen_string_literal: true

# Description/Explanation of Person class
class Job < ApplicationRecord
  belongs_to :company

  has_many :industry_jobs
  has_many :industries, through: :industry_jobs

  has_many :city_jobs
  has_many :cities, through: :city_jobs

  has_many :applied_jobs
  has_many :users, through: :applied_jobs

  has_many :histories
  has_many :favorites
end
