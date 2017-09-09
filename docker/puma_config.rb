# frozen_string_literal: true

directory '/app'

threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count

stdout_redirect '/app/log/puma.out.log', '/app/log/puma.err.log', true

quiet
