# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.configure do |capybara_config|
  capybara_config.default_driver = :chrome
  capybara_config.default_max_wait_time = 10
end

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('--disable-gpu')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :chrome
