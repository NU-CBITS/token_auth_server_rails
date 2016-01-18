module TokenAuth
  module Api
    # API to manage Authentication Tokens.
    class AuthenticationTokensController < ::TokenAuth::Api::BaseController
      RESOURCE_TYPE = "authenticationTokens"

      include Concerns::CorsSettings

      after_action do |controller|
        controller.cors_set_access_control_headers(
          allow_methods: "POST, OPTIONS"
        )
      end

      def options
        render json: {}, status: 200
      end

      def create
        if configuration_token && authentication_token
          render(json: {
                   data: {
                     type: RESOURCE_TYPE,
                     id: authentication_token.uuid,
                     value: authentication_token.value
                   }
                 },
                 status: 201)
        else
          render json: {}, status: 400
        end
      end

      private

      def authentication_token
        @authentication_token ||=
          configuration_token.make_authentication_token(token_params)
      end

      def token_params
        { client_uuid: (params[:data] || {})[:clientUuid] }
      end

      def configuration_token
        @configuration_token ||=
          ConfigurationToken.find_match(params[:configurationToken])
      end
    end
  end
end
