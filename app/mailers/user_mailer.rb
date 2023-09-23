# frozen_string_literal: true

class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.user_created.subject
  #
  def user_created
    @greeting = 'Hi New User , enjoy your blogging Journey'

    attachments['default_image.jpeg'] = File.read('app/assets/images/default_image.jpeg')
    mail(
      # from: 'jay.prakash@ksolves.com',
      to: User.first.email,
      # cc: User.all.pluck(:email),
      bcc: 'secret@jay.prakash@ksolves.com',
      subject: 'User created successfully'
    )
  end
end
