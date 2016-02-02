# encoding: UTF-8
# frozen_string_literal: true

require 'digest/md5'

module MemeCaptainWeb
  # Asset host setup.
  class AssetHostConfig
    def configure(config, env)
      return if env['ASSET_DOMAIN'.freeze].blank?
      config.action_controller.asset_host = proc { |asset, request|
        "#{request.protocol}a#{Digest::MD5.hexdigest(asset).to_i(16) % 3}.\
#{env['ASSET_DOMAIN'.freeze]}"
      }
    end
  end
end
