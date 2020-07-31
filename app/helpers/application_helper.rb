# frozen_string_literal

module ApplicationHelper
  def full_title(page_title)
    base_title = 'VenJob'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
