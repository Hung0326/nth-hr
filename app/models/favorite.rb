# frozen_string_literal: true

# Description/Explanation of Person class
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :job
end
