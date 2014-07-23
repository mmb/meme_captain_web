require 'rubocop/rake_task'

desc 'Run rubocop style checker'
Rubocop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = false
end

task spec: :rubocop
