# frozen_string_literal: true
require "rails_helper"

RSpec.describe "token_auth/tokens/index", type: :view do
  context "when the Configuration Token has expired" do
    it "is indicated" do
      assign(:configuration_token, double("token", expired?: true))
      assign(:entity_id, 1)
      render template: "token_auth/tokens/index"

      expect(rendered).to have_content "Expired"
    end
  end

  context "when the Configuration Token has not expired" do
    it "has its expiration indicated" do
      assign(:configuration_token,
             double("token",
                    expired?: false,
                    expires_at: Time.zone.now + 1.hour,
                    value: "asdf"))
      assign(:entity_id, 1)
      render template: "token_auth/tokens/index"

      expect(rendered).to have_content "Expires in about 1 hour"
    end
  end
end
