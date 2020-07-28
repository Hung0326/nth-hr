# frozen_string_literal: true

# Description/Explanation of Person class
class AppliedJob < ApplicationRecord
  belongs_to :user
  belongs_to :job
end
