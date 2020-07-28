# frozen_string_literal: true

# Description/Explanation of Person class
class CityJob < ApplicationRecord
  belongs_to :city
  belongs_to :job
end
