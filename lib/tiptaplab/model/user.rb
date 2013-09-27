module Tiptaplab
  module Model
    class User < Tiptaplab::Record
      attr_accessor :ttl_id, :traits, :username, :name, :website, :created_at, :bio

      # Display the user's traits, fetching them if they aren't currently set
      def traits
        @traits || refresh_traits
      end

      # Fetch the user's traits via the API.
      def refresh_traits
        response = Tiptaplab.api.make_call("users/#{@ttl_id}/traits")
        @traits = response
      end

      # Display the user's personality data, fetching if not set
      def personality
        @personality || refresh_personality
      end

      # Fetch user's personality via API.
      def refresh_personality
        response = Tiptaplab.api.make_call("users/#{@ttl_id}/personality", {}, 'GET', :allow_status => 404)
        if response 404
          puts "Insufficient data to calculate personality."
        else
          @personality = response
        end
      end


      class << self

        # Fetch basic information about the user with the specified TipTapLab ID.
        def find(ttl_id)
          response = Tiptaplab.api.make_call("users/#{ttl_id}")
          dup_resp = response.dup
          dup_resp[:ttl_id] = ttl_id
          u = self.new(dup_resp)
        end

        # Create a new user through the API and return a Tiptaplab::User that can be used to interact with it.
        def create(params = {})
          response = Tiptaplab.api.make_call('users', {:user => params}, 'POST')
          dup_params = params.dup
          dup_params[:ttl_id] = response['id']
          u = self.new(dup_params)
        end

        # List the IDs of users to which the app has access
        def list
          response = Tiptaplab.api.make_call("users/authorizations")
          response.keys
        end

      end
    end
  end
end