# frozen_string_literal: true
require "rails_helper"

module TokenAuth
  RSpec.describe ConfigurationTokensController, type: :controller do
    routes { TokenAuth::Engine.routes }

    def config_token
      @config_token ||= begin
        token = instance_double("TokenAuth::ConfigurationToken",
                                entity_id: 1)
        allow(token).to receive_message_chain("class.model_name.human")
          .and_return("Configuration token")

        token
      end
    end

    describe "POST create" do
      before do
        allow(ConfigurationToken).to receive(:new) { config_token }
      end

      context "when the token saves successfully" do
        it "sets a notice" do
          allow(config_token).to receive(:save) { true }
          post :create, params: { entity_id: 1 }

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:notice]).to eq "Successfully saved Configuration token"
        end
      end

      context "when the token doesn't save successfully" do
        it "sets an alert" do
          allow(config_token).to receive(:save) { false }
          allow(config_token).to receive_message_chain("errors.full_messages")
            .and_return([])
          post :create, params: { entity_id: 1 }

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:alert]).to match(/Unable to save/)
        end
      end
    end

    describe "DELETE destroy" do
      before do
        allow(ConfigurationToken).to receive(:find_by)
          .and_return(config_token)
      end

      context "when the token is not found" do
        it "sets an alert" do
          allow(ConfigurationToken).to receive(:find_by) { nil }
          delete :destroy, entity_id: 1

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:alert]).to match(/Unable to find/)
        end
      end

      context "when the token destroys successfully" do
        it "sets a notice" do
          allow(config_token).to receive(:destroy) { true }
          delete :destroy, params: { entity_id: 1 }

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:notice]).to match(/Successfully destroyed/)
        end
      end

      context "when the token doesn't destroy successfully" do
        it "sets an alert" do
          allow(config_token).to receive(:destroy) { false }
          allow(config_token).to receive_message_chain("errors.full_messages")
            .and_return([])
          delete :destroy, params: { entity_id: 1 }

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:alert]).to match(/Unable to destroy/)
        end
      end
    end
  end
end
