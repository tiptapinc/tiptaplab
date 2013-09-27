require 'active_support/core_ext/numeric'
require 'faraday'
require 'json'

module Tiptaplab
  class Api
    DEFAULT_OPTIONS = {
      :api_version => 3,
      :api_environment => 'production'
    }

    def initialize *params
      if params.first.is_a?(Hash)
        hash_options = params.first
        @api_version = hash_options[:api_version] || DEFAULT_OPTIONS[:api_version]
        @api_environment = hash_options[:api_environment] || DEFAULT_OPTIONS[:api_environment]
        @app_id = hash_options[:app_id]
        unless @app_id
          raise "No app_id specified. Please pass a Hash containing your application credentials to Tiptaplab::Api.new"
        end
        @app_secret = hash_options[:app_secret]
        unless @app_secret
          raise "No app_secret specified. Please pass a Hash containing your application credentials to Tiptaplab::Api.new"
        end
      else
        raise "Pass init parameters as a Hash"
      end
      @version_str = "v#{@api_version}"
      api_url = case @api_environment
      when 'staging'
        'http://api.staging.tiptap.com'
      else
        'https://api.tiptap.com'
      end
      @conn = Faraday.new(:url => api_url) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
      Tiptaplab.api = self
    end

    def fetch_auth_token(opts = {})
      if opts[:force] || @auth_at.nil? || (@auth_at < (opts[:cache_for]|| 60.minutes).ago)
        @auth_at = Time.now
        token_response = @conn.post('/oauth/token',
          {
            :client_id => @app_id,
            :client_secret => @app_secret,
            :grant_type => 'client_credentials'
          }
        )
        if token_response.status == 200
          @auth_token = JSON.parse(token_response.body)['access_token']
        else
          raise "Error fetching auth token. Check the log for details."
        end
      end
      @auth_token
    end

    def make_call(call, data = {}, method = 'GET', opts = {})
      fetch_auth_token
      case method
      when 'GET'
        response = @conn.get("/#{@version_str}/#{call}", data, {'Authorization' => "Bearer #{@auth_token}"})
        if response.status == '401'
          puts "Response returned unauthorized, attempting to refresh auth token"
          fetch_auth_token(:force => true)
          response = @conn.get("/#{@version_str}/#{call}", data, {'Authorization' => "Bearer #{@auth_token}"})
        end
      when 'POST'
        response = @conn.post("/#{@version_str}/#{call}", data, {'Authorization' => "Bearer #{@auth_token}"})
        if response.status == '401'
          puts "Response returned unauthorized, attempting to refresh auth token"
          fetch_auth_token(:force => true)
          response = @conn.get("/#{@version_str}/#{call}", data, {'Authorization' => "Bearer #{@auth_token}"})
        end
      end
      if (response.status/100 == 2)
        JSON.parse(response.body)
      else
        unless opts[:allow_status].includes(response.status)
          raise "Unable to process API call '#{call}' - Returned status #{response.status}. Check the log for more information."
        end
        response.status
      end
    end

  end
end