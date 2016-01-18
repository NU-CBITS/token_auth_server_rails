require "openssl"

module TokenAuth
  module Api
    # Processes inbound and outbound resources.
    class PayloadsController < ActionController::Base
      include TokenAuth::Concerns::CorsSettings

      rescue_from TokenAuth::Concerns::ApiResources::Api::Unauthorized,
                  with: :unauthorized

      after_action do |controller|
        controller.cors_set_access_control_headers(
          allow_methods: "GET, POST, OPTIONS",
          allow_headers: "Authorization"
        )
      end

      def index
        authenticate!
        entity_id = @authentication_token.entity_id
        resources = find_pullable_resources(entity_id).map do |resource|
          resource.klass.where(resource.entity_id_attribute_name => entity_id)
        end.flatten

        render json: resources
      end

      def options
        render json: {}, status: 200
      end

      def create
        authenticate!
        entity_id = @authentication_token.entity_id
        payload = Payload.new(entity_id: entity_id)
        payload.save params[:data]

        render json: payload.valid_resources, status: 201

      rescue TokenAuth::Payload::MalformedPayloadError
        render json: {}, status: 400
      end

      private

      def find_token!
        @authentication_token = TokenAuth::AuthenticationToken.find_by(
          client_uuid: @metadata[:key],
          is_enabled: true
        )

        return if @authentication_token

        fail TokenAuth::Concerns::ApiResources::Api::Unauthorized
      end

      def calculate_signature
        OpenSSL::Digest::MD5.hexdigest([
          params[:data] ? params[:data].to_json : nil,
          @metadata[:key],
          @metadata[:nonce],
          @metadata[:timestamp],
          @metadata[:url],
          @metadata[:method],
          @authentication_token.value
        ].compact.join)
      end

      def split_header
        if request.headers[:Authorization].nil?
          fail TokenAuth::Concerns::ApiResources::Api::Unauthorized
        end

        auth_headers = request.headers[:Authorization].split(",")
        @metadata = auth_headers.each_with_object({}) do |h, metadata|
          p = h.split("=")
          metadata[p[0].to_sym] = p[1].gsub(/(^")|("$)/m, "")
        end
      end

      def authenticate!
        split_header
        find_token!

        return if @metadata[:signature] == calculate_signature

        fail TokenAuth::Concerns::ApiResources::Api::Unauthorized
      end

      def find_pullable_resources(entity_id)
        SynchronizableResource.where(is_pullable: true, entity_id: entity_id)
      end

      def unauthorized
        render json: {}, status: 401
      end
    end
  end
end
