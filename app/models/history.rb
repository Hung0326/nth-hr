# frozen_string_literal: true

# Description/Explanation of Person class
class History < ApplicationRecord
  belongs_to :user
  belongs_to :job
end
