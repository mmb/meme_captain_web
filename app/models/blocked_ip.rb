# frozen_string_literal: true
# IP addresses that are blocked from accessing the site.
class BlockedIp < ActiveRecord::Base
  def self.blocked?(ip)
    ips = Rails.cache.fetch('blocked ips'.freeze, expires_in: 5.minutes) do
      pluck(:ip).to_set
    end

    ips.include?(ip)
  end
end
