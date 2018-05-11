# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'nova.info@mf2018.youki.io'
  layout 'mailer'
end
