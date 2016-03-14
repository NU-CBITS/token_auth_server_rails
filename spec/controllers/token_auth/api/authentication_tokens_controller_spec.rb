# frozen_string_literal: true
require "rails_helper"

module TokenAuth
  module Api
    RSpec.describe AuthenticationTokensController, type: :controller do
      routes { TokenAuth::Engine.routes }

      describe "POST create" do
        context "when the configuration token isn't found" do
          it "responds with bad request" do
            allow(ConfigurationToken).to receive(:find_match)
            post :create

            expect(response.status).to eq 400
          end
        end

        context "when the configuration token is found" do
          def config_token
            @config_token ||= double("config token")
          end

          def auth_token
            @auth_token ||= double("auth token")
          end

          before do
            allow(ConfigurationToken).to receive(:find_match) { config_token }
          end

          context "when the authentication token doesn't save successfully" do
            it "responds with bad request" do
              allow(config_token).to receive(:make_authentication_token)
              post :create

              expect(response.status).to eq 400
            end
          end

          context "when the authentication token saves successfully" do
            it "responds with the auth token payload" do
              allow(config_token).to receive(:make_authentication_token)
                .and_return(auth_token)
              allow(auth_token).to receive(:uuid) { "abc-123" }
              allow(auth_token).to receive(:value) { "x5q8" }
              post :create

              expect(response.status).to eq 201
              expect(response_json["data"]["type"])
                .to eq AuthenticationTokensController::RESOURCE_TYPE
              expect(response_json["data"]["id"]).to eq "abc-123"
              expect(response_json["data"]["value"]).to eq "x5q8"
            end
          end
        end
      end
    end
  end
end
