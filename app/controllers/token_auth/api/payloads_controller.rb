# frozen_string_literal: true

require "openssl"

module TokenAuth
  module Api
    # Processes inbound and outbound resources.
    class PayloadsController < ::TokenAuth::Api::BaseController
      include TokenAuth::Concerns::CorsSettings

      attr_reader :authentication_token

      rescue_from TokenAuth::Concerns::ApiResources::Api::Unauthorized,
                  with: :unauthorized

      before_action do |controller|
        controller.cors_set_access_control_headers(
          allow_methods: "GET, POST, OPTIONS",
          allow_headers: "Authorization"
        )
      end

      def index
        authenticate!
        render json: pullable_records,
               meta: { timestamp: Time.zone.now.iso8601 }
      end

      def options
        render json: {}, status: 200
      end

      def create
        authenticate!
        payload = Payload.new(entity_id: authentication_token.entity_id)
        payload.save request_data

        headers["Errors"] = payload.errors.join(", ")
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

        raise TokenAuth::Concerns::ApiResources::Api::Unauthorized
      end

      def request_data
        return nil unless request.post?

        params[:data] || []
      end

      def calculate_signature
        OpenSSL::Digest::MD5.hexdigest([
          request_data ? request_data.to_json : nil,
          @metadata[:key],
          @metadata[:nonce],
          @metadata[:timestamp],
          @metadata[:url],
          @metadata[:method],
          authentication_token.value
        ].compact.join)
      end

      def split_header
        if request.headers[:Authorization].nil?
          raise TokenAuth::Concerns::ApiResources::Api::Unauthorized
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

        raise TokenAuth::Concerns::ApiResources::Api::Unauthorized
      end

      def pullable_records
        entity_id = authentication_token.entity_id

        SynchronizableResource.pullable_records_for(
          entity_id: entity_id,
          filter: params[:filter]
        )
      end

      def unauthorized
        render json: {}, status: 401
      end
    end
  end
end
