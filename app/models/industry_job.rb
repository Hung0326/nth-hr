# frozen_string_literal: true

# Description/Explanation of Person class
class IndustryJob < ApplicationRecord
  belongs_to :industry
  belongs_to :job
end
