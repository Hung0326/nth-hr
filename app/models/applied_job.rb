# frozen_string_literal: true

# Description/Explanation of Person class
class AppliedJob < ApplicationRecord
  mount_uploader :cv, CvUploader
  belongs_to :user
  belongs_to :job
  validates :name, :email, :cv, presence: true
  validates :name, :email, length: { in: 4..200 }
  validates :email, format: Devise.email_regexp
end
