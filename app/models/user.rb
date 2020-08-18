# frozen_string_literal: true

# Description/Explanation of Person class
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VALID_LANG_CODES = %w[vi en].freeze
  mount_uploader :cv, CvUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :applied_jobs
  has_many :jobs, through: :applied_jobs

  has_many :histories
  has_many :favorites
  validates_length_of :name, within: 4..200
  validates_length_of :email, within: 8..200

  def update_current_language(new_lang)
    return if new_lang == language || VALID_LANG_CODES.exclude?(new_lang)

    self.language = new_lang
    save
  end
end
