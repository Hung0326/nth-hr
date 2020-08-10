# frozen_string_literal: true

# Decorator
class JobDecorator < Draper::Decorator
  delegate_all
  def posted_at
    created_at.strftime('%d - %m - %Y')
  end

  def expired_at
    expiration_date.strftime('%d - %m - %Y')
  end
end
