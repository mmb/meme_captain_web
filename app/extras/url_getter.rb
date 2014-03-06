# encoding: UTF-8

class UrlGetter
  def get(url)
    conn.get(url).body
  end

  private

  def conn
    Faraday.new do |c|
      c.use FaradayMiddleware::FollowRedirects
      c.use Faraday::Response::RaiseError

      c.adapter Faraday.default_adapter
    end
  end
end
