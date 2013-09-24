module Tiptaplab
  class User
    attr_accessor :ttl_id, :traits

    def initialize *params
      ttl_id_param = params.shift
      if ttl_id_param
        # Find an existing user
        response = Tiptaplab.api.make_call("users/#{ttl_id_param}")
        if response.is_a? Hash
          @ttl_id = ttl_id_param
        else
          raise "Unable to access user, status #{response}"
        end
      else
        # Create a new user
        response = Tiptaplab.api.make_call('users', {}, 'POST')
        if response.is_a? Fixnum
          raise "Unable to create user, status #{response}"
        else
          @ttl_id = response['id']
        end
      end
    end

    # Display the user's traits, fetching them if they aren't currently set
    def traits
      @traits || refresh_traits
    end

    # Fetch the user's traits via the API.
    def refresh_traits
      response = Tiptaplab.api.make_call("users/#{@ttl_id}/traits")
      if response.is_a? Fixnum
        raise "Unable to fetch user traits, status #{response}"
      else
        @traits = response
      end
      @traits
    end

    def personality
      @personality
    end

    def method_name

    end


    class << self
      def find(ttl_id)
        u = self.new(ttl_id)
      end

      def create(params = {})
        u = self.new
      end
    end

  end
end