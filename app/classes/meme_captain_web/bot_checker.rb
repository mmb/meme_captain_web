# frozen_string_literal: true

module MemeCaptainWeb
  # Check params for params that only bots would use.
  #
  # Increment a statsd counter if a bot is detected.
  class BotChecker
    def check(params)
      return if params[:gend_image][:email].blank?
      StatsD.increment('bot.attempt')
    end
  end
end
