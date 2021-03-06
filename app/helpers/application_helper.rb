# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def full_title(page_title)
    base_title = 'VenJob'
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?
      message.delete!("'") if message.include?("'")
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def render_errors(obj)
    errors = []
    obj.errors.full_messages.each { |mess| errors << "#{mess}<br>" }
    flash[:error] = errors.join('<br>').html_safe
  end
end
