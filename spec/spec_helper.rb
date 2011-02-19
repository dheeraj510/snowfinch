require "spork"

Spork.prefork do
  Spork.trap_method(Rails::Application, :reload_routes!)

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true

    config.before(:each) do
      Capybara.reset_sessions!
    end
  end
end

Spork.each_run do
  FactoryGirl.registry = FactoryGirl::Registry.new
  load "factories.rb"

  I18n.reload!
end

