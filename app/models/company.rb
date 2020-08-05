# frozen_string_literal: true

# Description/Explanation of Person class
class Company < ApplicationRecord
  COMPANY_SECURITY = 1
  has_many :jobs
end
