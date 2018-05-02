# frozen_string_literal: true

Rails.application.config.tap do |config|
  config.i18n.available_locales = %i[ja]
  config.i18n.fallbacks = %i[ja en]
  config.i18n.default_locale = :ja
end
