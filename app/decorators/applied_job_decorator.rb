class AppliedJobDecorator < Draper::Decorator
  delegate_all
  def applied_at
    object.created_at.localtime.strftime('%H:%M %d - %m - %Y')
  end
end
