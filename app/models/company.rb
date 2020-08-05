# frozen_string_literal: true

# Description/Explanation of Person class
class Company < ApplicationRecord
  COMPANY_SECURITY = 1
  before_save :convert_to_slug
  has_many :jobs

  def convert_to_slug
    self.slug = Slug.to_slug(self.name)
  end
end
