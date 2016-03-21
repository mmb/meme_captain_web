desc 'Generate a build metadata file'
task :build_metadata, :output_path do |_, args|
  command = "git log -1 --pretty=format:'%ct %H' 2>&1"
  command_output = `#{command}`
  raise("'#{command}' failed: #{command_output}") unless $CHILD_STATUS.success?
  timestamp, commit = command_output.split(' ')

  data = {
    commit: {
      timestamp: timestamp.to_i,
      sha: commit
    }
  }

  File.open(args.output_path, 'w') do |f|
    f.write(JSON.pretty_generate(data))
  end
end
