require "rails_helper"

module TokenAuth
  module Concerns
    RSpec.describe ApiResources, type: :controller do
      controller(ActionController::Base) do
        include ::TokenAuth::Concerns::ApiResources

        def fake_action
          render nothing: true
        end
      end

      before do
        routes.draw do
          get "fake_action" => "anonymous#fake_action"
          match "fake_options",
                to: "anonymous#options",
                via: :options
        end
      end

      describe "OPTIONS options" do
        context "when valid auth credentials are provided" do
          it "responds with 200" do
            create_valid_credentials
            process :options, "OPTIONS", clientUuid: "abc"

            expect(response.status).to eq 200
          end
        end
      end

      describe "GET fake_action" do
        context "when no auth token is provided" do
          it "responds with 401" do
            get :fake_action

            expect(response.status).to eq 401
          end
        end

        context "when an auth token is provided" do
          context "when auth credentials are invalid" do
            it "responds with 401" do
              create_invalid_credentials
              get :fake_action, clientUuid: "abc"

              expect(response.status).to eq 401
            end
          end

          context "when auth credentials are disabled" do
            it "responds with 401" do
              create_disabled_credentials
              get :fake_action, clientUuid: "abc"

              expect(response.status).to eq 401
            end
          end

          context "when auth credentials are valid" do
            it "responds with 200" do
              create_valid_credentials
              get :fake_action, clientUuid: "abc"

              expect(response.status).to eq 200
            end
          end
        end
      end
    end
  end
end
