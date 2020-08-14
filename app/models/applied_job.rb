# frozen_string_literal: true

# Description/Explanation of Person class
class AppliedJob < ApplicationRecord
  mount_uploader :cv, CvUploader
  validates_integrity_of :cv
  belongs_to :user
  belongs_to :job
end
