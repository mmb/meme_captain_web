# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new('spec:postgres'.freeze) do |t|
    t.rspec_opts = '--tag postgres'.freeze
  end
# rubocop:disable Lint/HandleExceptions
rescue LoadError
  # rubocop:enable Lint/HandleExceptions
end
