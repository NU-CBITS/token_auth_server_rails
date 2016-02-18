# frozen_string_literal: true
require "rails_helper"

module TokenAuth
  RSpec.describe AuthenticationTokensController, type: :controller do
    routes { TokenAuth::Engine.routes }

    def auth_token
      @auth_token ||= (
        token = instance_double("TokenAuth::AuthenticationToken",
                                entity_id: 1)
        allow(token).to receive_message_chain("class.model_name.human")
          .and_return("Authentication token")

        token
      )
    end

    before do
      allow(AuthenticationToken).to receive(:find_by_entity_id)
        .and_return(auth_token)
    end

    describe "PATCH update" do
      context "when the token updates successfully" do
        it "sets a notice" do
          allow(auth_token).to receive(:update) { true }
          patch :update, entity_id: 1

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:notice]).to eq "Successfully saved Authentication token"
        end
      end

      context "when the token doesn't update successfully" do
        it "sets an alert" do
          allow(auth_token).to receive(:update) { false }
          allow(auth_token).to receive_message_chain("errors.full_messages")
            .and_return([])
          patch :update, entity_id: 1

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:alert]).to match(/Unable to save/)
        end
      end
    end

    describe "DELETE destroy" do
      context "when the token destroys successfully" do
        it "sets a notice" do
          allow(auth_token).to receive(:destroy) { true }
          delete :destroy, entity_id: 1

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:notice])
            .to eq "Successfully destroyed Authentication token"
        end
      end

      context "when the token doesn't destroy successfully" do
        it "sets an alert" do
          allow(auth_token).to receive(:destroy) { false }
          allow(auth_token).to receive_message_chain("errors.full_messages")
            .and_return([])
          delete :destroy, entity_id: 1

          expect(response).to redirect_to tokens_url(1)
          expect(flash[:alert]).to match(/Unable to destroy/)
        end
      end
    end
  end
end
