class AppliedMailer < ApplicationMailer

  def applied_job_mail_to(obj)
    @applied_job = obj
    emails = [@applied_job.email, ENV['SENDMAIL_USERNAME']]
    mail(to: emails, subject: t('apply_job.subject'))
  end
end
