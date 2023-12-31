module Fog
  module Brightbox
    class Compute
      # The Shared module consists of code that was duplicated between the Real
      # and Mock implementations.
      #
      module Shared
        include Fog::Brightbox::OAuth2

        attr_writer :scoped_account

        API_URL = "https://api.gb1.brightbox.com/".freeze

        # Creates a new instance of the Brightbox Compute service
        #
        # @note If you create service using just a refresh token when it
        #   expires the service will no longer be able to authenticate.
        #
        # @see Fog::Brightbox::Config#initialize Config object for possible configuration options
        #
        # @param [Brightbox::Config, Hash] config
        #   Any configuration to be used for this service. This ideally should be in the newer form
        #   of a {Brightbox::Config} object but may be a Hash.
        #
        def initialize(config)
          @config = if config.respond_to?(:config_service?) && config.config_service?
                      config
                    else
                      Fog::Brightbox::Config.new(config)
                    end
          @config = Fog::Brightbox::Compute::Config.new(@config)

          # Currently authentication and api endpoints are the same but may change
          @auth_url            = @config.auth_url.to_s
          @auth_connection     = Fog::Core::Connection.new(@auth_url)

          @api_url             = @config.compute_url.to_s
          @connection_options  = @config.connection_options
          @persistent          = @config.connection_persistent?
          @connection          = Fog::Core::Connection.new(@api_url, @persistent, @connection_options)

          @configured_account  = @config.account
          # Request account can be changed at anytime and changes behaviour of future requests
          @scoped_account      = @configured_account

          @two_factor          = @config.two_factor?
          @one_time_password   = @config.one_time_password

          # If existing tokens have been cached, allow continued use of them in the service
          credentials.update_tokens(@config.cached_access_token, @config.cached_refresh_token)

          @token_management = @config.managed_tokens?
        end

        # This returns the account identifier that the request should be scoped by
        # based on the options passed to the request and current configuration
        #
        # @param [String] options_account Any identifier passed into the request
        #
        # @return [String, nil] The account identifier to scope the request to or nil
        def scoped_account(options_account = nil)
          [options_account, @scoped_account].compact.first
        end

        # Resets the scoped account back to intially configured one
        def scoped_account_reset
          @scoped_account = @configured_account
        end

        def credentials
          client_id = @config.client_id
          client_secret = @config.client_secret
          @credentials ||= CredentialSet.new(client_id, client_secret, credential_options)
        end

        # Returns the scoped account being used for requests
        #
        # * For API clients this is the owning account
        # * For User applications this is the account specified by either +account_id+
        #   option on the service or the +brightbox_account+ setting in your configuration
        #
        # @return [Fog::Brightbox::Compute::Account]
        #
        def account
          account_data = get_scoped_account.merge(service: self)
          Fog::Brightbox::Compute::Account.new(account_data)
        end

        # Returns true if authentication is being performed as a user
        # @return [Boolean]
        def authenticating_as_user?
          @credentials.user_details?
        end

        # Returns true if an access token is set
        # @return [Boolean]
        def access_token_available?
          !!@credentials.access_token
        end

        # Returns the current access token or nil
        # @return [String,nil]
        def access_token
          @credentials.access_token
        end

        # Returns the current refresh token or nil
        # @return [String,nil]
        def refresh_token
          @credentials.refresh_token
        end

        # Returns the current token expiry time in seconds or nil
        # @return [Number,nil]
        def expires_in
          @credentials.expires_in
        end

        # Requests a new access token
        #
        # @return [String] New access token
        def get_access_token
          begin
            get_access_token!
          rescue Fog::Brightbox::OAuth2::TwoFactorMissingError, Excon::Errors::Unauthorized, Excon::Errors::BadRequest
            @credentials.update_tokens(nil, nil)
          end
          @credentials.access_token
        end

        # Requests a new access token and raises if there is a problem
        #
        # @return [String] New access token
        # @raise [Excon::Errors::BadRequest] The credentials are expired or incorrect
        #
        def get_access_token!
          response = request_access_token(@auth_connection, @credentials)
          update_credentials_from_response(@credentials, response)
          @credentials.access_token
        end

        # Returns an identifier for the default image for use
        #
        # Currently tries to find the latest version of Ubuntu (i686) from
        # Brightbox.
        #
        # Highly recommended that you actually select the image you want to run
        # on your servers yourself!
        #
        # @return [String] if image is found, returns the identifier
        # @return [NilClass] if no image is found or an error occurs
        #
        def default_image
          @default_image_id ||= (@config.default_image_id || select_default_image)
        end

        def two_factor?
          @two_factor || false
        end

        private

        # This returns a formatted set of options for the credentials for this service
        #
        # @return [Hash]
        def credential_options
          {
            username: @config.username,
            password: @config.password
          }.tap do |opts|
            opts[:one_time_password] = @one_time_password if two_factor?
          end
        end

        # This makes a request of the API based on the configured setting for
        # token management.
        #
        # @param [Hash] options Excon compatible options
        # @see https://github.com/geemus/excon/blob/master/lib/excon/connection.rb
        #
        # @return [Hash] Data of response body
        #
        def make_request(options)
          if @token_management
            managed_token_request(options)
          else
            authenticated_request(options)
          end
        end

        # This request checks for access tokens and will ask for a new one if
        # it receives Unauthorized from the API before repeating the request
        #
        # @param [Hash] options Excon compatible options
        #
        # @return [Excon::Response]
        def managed_token_request(options)
          get_access_token unless access_token_available?
          authenticated_request(options)
        rescue Excon::Errors::Unauthorized
          get_access_token
          authenticated_request(options)
        end

        # This request makes an authenticated request of the API using currently
        # setup credentials.
        #
        # @param [Hash] options Excon compatible options
        #
        # @see https://github.com/geemus/excon/blob/master/lib/excon/connection.rb
        #
        # @return [Excon::Response]
        def authenticated_request(options)
          headers = options[:headers] || {}
          headers["Authorization"] = "Bearer #{@credentials.access_token}"
          headers["Content-Type"] = "application/json"
          options[:headers] = headers
          # TODO: This is just a wrapper around a call to Excon::Connection#request
          #   so can be extracted from Compute by passing in the connection,
          #   credentials and options
          @connection.request(options)
        end
      end
    end
  end
end
