require 'uri'
require 'rest_client'
require 'json'

module GraphiteDashboardApi
  module Api
    # this mixin requires a from_hash! and to_hash methods + @name
    def save!(uri)
      data = encode
      response = rest_request(uri, "save/#{@name}", :post, data)
      response
    end

    def load!(uri, name = nil)
      response = rest_request(uri, "load/#{name || @name}", :get)
      self.from_hash!(response)
    end

    def search(uri, pattern)
      response = rest_request(uri, "find/?query=#{pattern}", :get)
      response['dashboards']
    end

    def exists?(uri, name = nil)
      pattern = name || @name
      search(uri, pattern).map { |el| el['name'] }.include? (pattern)
    end

    private
    def rest_request(uri, endpoint, method, payload = nil)
      uri = "#{uri}/dashboard/#{endpoint}"
      begin
        r = RestClient::Request.new(
          url: uri,
          payload: payload,
          method: method,
          timeout: 2,
          open_timeout: 2,
          headers: {
            accept: :json,
            content_type: :json,
          }
        )
        response = r.execute
      rescue => e
        raise "Rest client error: #{e}"
      end
      if response.code != 200 || JSON.parse(response.body)['error']
        fail "Error calling dashboard API: #{response.code} #{response.body}"
      end
      JSON.parse(response.body)
    end
  end
end
