# frozen_string_literal: true

# Description/Explanation of Person class
class User < ApplicationRecord
  has_many :applied_jobs
  has_many :jobs, through: :applied_jobs

  has_many :histories
  has_many :favorites
end
