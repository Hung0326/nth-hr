# frozen_string_literal: true

# Description/Explanation of Person class
class History < ApplicationRecord
  NUMBER_JOB_LIMIT = 20
  belongs_to :user
  belongs_to :job
end
