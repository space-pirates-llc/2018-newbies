# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # TODO: 送信元の mail address を適切な値にする
  default from: 'from@example.com'
  layout 'mailer'
end
