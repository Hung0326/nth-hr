# frozen_string_literal: true

# Description/Explanation of Person class
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :cv, CvUploader  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :applied_jobs
  has_many :jobs, through: :applied_jobs

  has_many :histories
  has_many :favorites
  validates_length_of :name, within: 8..200
  validates_length_of :email, within: 8..200
end
