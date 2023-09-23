# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Blogger@test.com'
  layout 'mailer'
end
