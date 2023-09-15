module Fog
  module Brightbox
    class Compute
      class Real
        # Release the cloud IP address from the account's ownership.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_delete_cloud_ip
        #
        def delete_cloud_ip(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/cloud_ips/#{identifier}", [200], options)
        end
      end
    end
  end
end
