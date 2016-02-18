module TokenAuth
  module Concerns
    # Behavior related to authentication and CORS.
    module ApiResources
      module Api
        class Unauthorized < StandardError
        end
      end

      extend ActiveSupport::Concern

      include ::TokenAuth::Concerns::CorsSettings

      included do
        before_action :authenticate_token!

        rescue_from Api::Unauthorized, with: :unauthorized
      end

      AUTH_HEADER = "X-AUTH-TOKEN".freeze

      def options
        render nothing: true
      end

      private

      def authenticate_token!
        @authentication_token = client_uuid && auth_header &&
                                ::TokenAuth::AuthenticationToken
                                .find_enabled(client_uuid: client_uuid,
                                              value: auth_header)

        raise Api::Unauthorized unless @authentication_token
      end

      def client_uuid
        params[:clientUuid]
      end

      def auth_header
        request.headers[AUTH_HEADER]
      end

      def unauthorized
        render json: {}, status: 401
      end
    end
  end
end
