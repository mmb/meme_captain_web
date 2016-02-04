Rack::Attack.blacklist('the black list') do |req|
  BlockedIp.blocked?(req.ip)
end
