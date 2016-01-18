require "rails_helper"
require "openssl"

module TokenAuth
  module Api
    RSpec.describe PayloadsController, type: :controller do
      routes { TokenAuth::Engine.routes }

      entity_id = 111
      let(:auth_token) do
        TokenAuth::AuthenticationToken.create!(
          entity_id: entity_id,
          is_enabled: true,
          client_uuid: "client1"
        )
      end
      let(:auth_prefix) do
        [
          "key=\"#{ auth_token.client_uuid }\"",
          "nonce=12345",
          "timestamp=9876",
          "url=\"https://api.example.com/payloads.json\""
        ].join(",")
      end

      describe "GET index" do
        let(:invalid_authorization_get) do
          [auth_prefix, "method=\"GET\"", "signature=\"asdf\""].join(",")
        end
        let(:valid_signature_get) do
          OpenSSL::Digest::MD5.hexdigest(
            auth_token.client_uuid + "12345" + "9876" \
            "https://api.example.com/payloads.json" + "GET" + auth_token.value
          )
        end
        let(:valid_authorization_get) do
          [
            auth_prefix,
            "method=\"GET\"",
            "signature=\"#{ valid_signature_get }\""
          ].join(",")
        end

        context "when the auth header is missing" do
          it "responds with 401" do
            get :index

            expect(response.status).to eq 401
          end
        end

        context "when the auth token cannot be found" do
          it "responds with 401" do
            @request.headers["Authorization"] = 'key="baz"'
            get :index

            expect(response.status).to eq 401
          end
        end

        context "when the signature does not match" do
          it "responds with 401" do
            @request.headers["Authorization"] = invalid_authorization_get
            get :index

            expect(response.status).to eq 401
          end
        end

        context "when the signature matches" do
          it "responds with 200" do
            @request.headers["Authorization"] = valid_authorization_get
            get :index

            expect(response.status).to eq 200
          end

          context "and there is a pullable resource" do
            it "responds with the serialized resource" do
              resource = SynchronizableResource.create!(
                is_pullable: true,
                entity_id: entity_id,
                entity_id_attribute_name: "entity_id",
                name: "synchronizable_resources",
                class_name: "TokenAuth::SynchronizableResource"
              )
              @request.headers["Authorization"] = valid_authorization_get
              get :index

              expect(response_json["data"].length).to eq 1
              expect(response_json["data"][0]["attributes"]["name"])
                .to eq "synchronizable_resources"
              expect(response_json["data"][0]["id"]).to eq resource.uuid
            end
          end
        end
      end

      describe "OPTIONS" do
        it "responds with 200" do
          process :options, "OPTIONS"

          expect(response.status).to eq 200
        end
      end

      describe "POST create" do
        let(:invalid_authorization_post) do
          [auth_prefix, "method=\"POST\"", "signature=\"asdf\""].join(",")
        end
        let(:valid_signature_post) do
          OpenSSL::Digest::MD5.hexdigest(
            "[]" + auth_token.client_uuid + "12345" + "9876" \
            "https://api.example.com/payloads.json" + "POST" + auth_token.value
          )
        end
        let(:valid_authorization_post) do
          [
            auth_prefix,
            "method=\"POST\"",
            "signature=\"#{ valid_signature_post }\""
          ].join(",")
        end
        let(:valid_signature_bad_payload_post) do
          OpenSSL::Digest::MD5.hexdigest(
            "\"baz\"" + auth_token.client_uuid + "12345" + "9876" \
            "https://api.example.com/payloads.json" + "POST" + auth_token.value
          )
        end
        let(:valid_authorization_bad_payload_post) do
          [
            auth_prefix,
            "method=\"POST\"",
            "signature=\"#{ valid_signature_bad_payload_post }\""
          ].join(",")
        end

        context "when the auth header is missing" do
          it "responds with 401" do
            post :create

            expect(response.status).to eq 401
          end
        end

        context "when the auth token cannot be found" do
          it "responds with 401" do
            @request.headers["Authorization"] = 'key="baz"'
            post :create

            expect(response.status).to eq 401
          end
        end

        context "when the signature does not match" do
          it "responds with 401" do
            @request.headers["Authorization"] = invalid_authorization_post
            post :create

            expect(response.status).to eq 401
          end
        end

        context "when the signature matches" do
          context "and the payload is malformed" do
            it "responds with 400" do
              @request.headers["Authorization"] =
                valid_authorization_bad_payload_post
              post :create, data: "baz"

              expect(response.status).to eq 400
            end
          end

          it "responds with 201" do
            @request.headers["Authorization"] = valid_authorization_post
            post :create, data: []

            expect(response.status).to eq 201
          end
        end
      end
    end
  end
end
