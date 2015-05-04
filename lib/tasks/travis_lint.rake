desc 'Validate .travis.yml'
namespace :travis do
  task :lint do
    sh %(travis lint --exit-code) do |ok, res|
      fail("travis lint failed with exit status #{res.exitstatus}") unless ok
    end
  end
end

task spec: 'travis:lint'
