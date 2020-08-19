# frozen_string_literal: true

module ApplyJobHelper
  def render_errors(obj)
    errors = []
    obj.errors.full_messages.each { |mess| errors << "#{mess}<br>" }
    flash[:error] = errors.join('<br>').html_safe
  end
end
