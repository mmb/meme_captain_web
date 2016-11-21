#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

def slack_message(request)
  return if ENV['SLACK_WEBHOOK'].to_s.empty?

  Net::HTTP.post_form(
    URI(ENV['SLACK_WEBHOOK']),
    payload: request.to_json
  )
end

$stdout.sync = true

print <<-EOS
220 127.0.0.1\r
250 127.0.0.1\r
250 Ok\r
250 Ok\r
EOS

headers_started = false
body_started = false
done = false
body = ''
subject = ''

ARGF.each do |line|
  line.chomp!

  if headers_started
    subject = line[8..-1] if line.start_with?('Subject: ')
  else
    if line == 'DATA'
      puts "354 Ok\r"
      headers_started = true
    end
    next
  end

  unless body_started
    body_started = true if line == ''
    next
  end

  if !done
    if line == '.'
      puts "250 Ok\r"
      done = true
      next
    end
    body << line.chomp << "\n"
  elsif line == 'QUIT'
    puts "221\r"
    break
  end
end

slack_message(
  channel: '#war-room',
  icon_emoji: ':dog:',
  username: 'monit',
  text: subject
)
