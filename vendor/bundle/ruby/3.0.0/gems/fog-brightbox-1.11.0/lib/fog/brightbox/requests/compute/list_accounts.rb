module Fog
  module Brightbox
    class Compute
      class Real
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_list_accounts
        #
        def list_accounts(options = {})
          options[:nested] = "false" unless options.key?(:nested)
          wrapped_request("get", "/1.0/accounts", [200], options)
        end
      end
    end
  end
end
