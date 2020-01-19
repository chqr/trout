# frozen_string_literal: true

# Constructs Faraday HTTP client object (Faraday Connection object)
# for MBTA's API
module Trout
  class Resource
    module Connection
      BASE_URL = 'https://api-v3.mbta.com'

      # Build a Faraday connection object with given options
      def self.build(api_key: nil, logger: nil)
        headers = {}
        headers['Content-Type'] = 'application/vnd.api+json'
        headers['X-API-Key']    = api_key if api_key

        Faraday.new(url: BASE_URL, headers: headers) do |conn|
          #
          # Order matters!
          # See https://lostisland.github.io/faraday/middleware/
          #

          # Automatically parse json response bodies
          conn.response :json,
                        content_type: /\bjson$/

          # Raise error on 4xx / 5xx responses
          conn.response :raise_error

          # Optionally log request/responses
          conn.response :logger, logger, bodies: true if logger

          # Use Ruby's default Net::HTTP adapter.
          # This MUST be last!
          conn.adapter :net_http
        end
      end
    end
  end
end
