# encoding: UTF-8

require 'digest/md5'

module MemeCaptainWeb
  # Asset host setup.
  class AssetHostConfig
    def configure(config, env)
      return if env['ASSET_DOMAIN'].blank?
      config.action_controller.asset_host = proc { |asset|
        "http://a#{Digest::MD5.hexdigest(asset).to_i(16) % 3}.\
#{env['ASSET_DOMAIN']}"
      }
    end
  end
end
