require 'net/http'
require 'uri'
require 'json'
require 'logger'

class WebhookPinger
  WEBHOOK_URL = 'https://webhook.site/33545b79-115c-46e2-ae5a-11fcdc108a10'
  
  def initialize
    @logger = Logger.new($stdout)
    @logger.level = Logger::INFO
  end

  def ping
    uri = URI(WEBHOOK_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = {
      timestamp: Time.now.to_i,
      message: 'Ping from Ruby app'
    }.to_json

    response = http.request(request)
    @logger.info("Ping sent - Response: #{response.code}")
  rescue StandardError => e
    @logger.error("Failed to send ping: #{e.message}")
  end

  def start
    @logger.info("Starting webhook pinger...")
    loop do
      ping
      sleep 5
    end
  end
end

pinger = WebhookPinger.new
pinger.start 