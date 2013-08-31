require 'net/http'
require 'uri'

class UrlGetter

  def get(url)
    Net::HTTP.get(URI(url))
  end

end
