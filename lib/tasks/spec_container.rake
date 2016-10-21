namespace :spec do
  desc 'build Docker container and run feature specs against it'
  task :container do
    sh('docker build -t meme_captain_test .')

    sh('docker run ' \
      '--detach ' \
      '--env RAILS_ENV=production ' \
      '--env SECRET_KEY_BASE=secret ' \
      '--name meme_captain_test ' \
      '--privileged=true ' \
      '--publish 127.0.0.1:6081:6081 ' \
      'meme_captain_test')

    sh('docker exec meme_captain_test rake db:migrate')

    ENV['FEATURE_SPEC_HOST'] = 'http://127.0.0.1:6081'
    Rake::Task['spec:features'].execute

    sh('docker stop meme_captain_test')
    sh('docker rm meme_captain_test')
  end
end
