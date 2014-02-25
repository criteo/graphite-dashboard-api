require 'uri'
require 'rest_client'
require 'json'

module GraphiteDashboardApi
  module Api
    #this mixin requires a from_hash! and to_hash methods + @name
    def save!(uri)
      response = rest_request(uri, "save/#{@name}", :put)
      response
    end

    def load(uri, name=nil)
      response = rest_request(uri, "load/#{name || @name}", :get)
      self.from_hash!(response)
    end

    def rest_request(uri, endpoint, method)
      uri = "#{uri}/dashboard/#{endpoint}"
      begin
        r = RestClient::Request.new(
          :url          => uri,
          :method       => :get,
          :timeout      => 2,
          :open_timeout => 2,
          :headers      => {
            :accept => :json,
          }
        )
        response = r.execute
      rescue => e
        fail "Rest client error: #{e}"
      end
      if response.code != 200 || JSON.parse(response.body)['error']
        fail "Error calling dashboard API: #{response.code} #{response.body}"
      end
      JSON.parse(response.body)
    end
  end
end
