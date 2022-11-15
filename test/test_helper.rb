ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  DatabaseCleaner.strategy = :transaction

  # Add more helper methods to be used by all tests here...
  setup do
    # to reset ID autoincrement counter
    DatabaseCleaner.clean_with(:truncation)

    DatabaseCleaner.start

    Rails.application.load_seed
    FetchCarRecommendationsJob.perform_now
  end

  teardown do
    DatabaseCleaner.clean
  end
end
