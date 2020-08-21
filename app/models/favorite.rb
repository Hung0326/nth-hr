# frozen_string_literal: true

# Description/Explanation of Person class
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :job
  validates_uniqueness_of :user_id, scope: :job_id, message: I18n.t('favorite.liked')
end
