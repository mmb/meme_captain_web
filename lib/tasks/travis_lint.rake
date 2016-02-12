# frozen_string_literal: true
desc 'Lint .travis.yml'.freeze
task 'travis:lint'.freeze do
  # add --exit-code when travis gem can handle apt addon
  sh('travis lint'.freeze) do |ok, res|
    fail res.exitstatus.to_s unless ok
  end
end
