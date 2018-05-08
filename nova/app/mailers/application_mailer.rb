# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@mf2018.youki.io'
  layout 'mailer'
end
