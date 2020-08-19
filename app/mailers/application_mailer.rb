# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['SENDMAIL_USERNAME']
  layout 'mailer'
end
