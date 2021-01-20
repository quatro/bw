ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers # Rails >= 5

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  sign_in @user

  def sign_in_user
    sign_in users(:chris)
  end

  def sign_in_super_user
    sign_in users(:super_chris)
    ]
  end

  # Add more helper methods to be used by all tests here...
end