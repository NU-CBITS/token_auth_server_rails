require "rails_helper"

module TokenAuth
  RSpec.describe AuthenticationToken, type: :model do
    def valid_attributes
      { entity_id: 2, client_uuid: 321 }
    end

    describe "validations" do
      it "accepts valid attributes" do
        AuthenticationToken.create!(valid_attributes)
      end
    end

    describe "initialization" do
      it "sets the token value" do
        expect(AuthenticationToken.create!(valid_attributes).value.length)
          .to eq AuthenticationToken::TOKEN_LENGTH
      end

      it "sets the uuid" do
        expect(AuthenticationToken.create!(valid_attributes).uuid.length)
          .to eq AuthenticationToken::UUID_LENGTH
      end
    end
  end
end
