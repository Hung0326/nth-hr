# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def full_title(page_title)
    base_title = 'VenJob'
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end
end
