require "rails_helper"

module TokenAuth
  RSpec.describe ConfigurationToken, type: :model do
    def valid_attributes
      { entity_id: 1 }
    end

    def create_token!
      ConfigurationToken.create!(valid_attributes)
    end

    describe ".find_match" do
      it "returns nil for inappropriate queries" do
        [nil, "", 123].each do |value|
          expect(ConfigurationToken.find_match(value)).to be_nil
        end
      end

      it "returns nil for expired tokens" do
        token = create_token!
        token.update(expires_at: DateTime.current - 1.minute)

        expect(ConfigurationToken.find_match(token.value)).to be_nil
      end

      it "returns records with exact value matches" do
        expect(ConfigurationToken.find_match(create_token!.value)).not_to be_nil
      end

      it "returns records with case insensitive value matches" do
        token = create_token!
        token.update!(value: "A" * ConfigurationToken::TOKEN_LENGTH)

        query = "a" * ConfigurationToken::TOKEN_LENGTH
        expect(ConfigurationToken.find_match(query)).not_to be_nil
      end

      it "returns records with mismatched whitespace in the query" do
        token = create_token!
        query = token.value.clone
        query.insert(2, "\t").insert(4, "   ")

        expect(ConfigurationToken.find_match(query)).not_to be_nil
      end
    end

    describe "#make_authentication_token" do
      def auth_token
        @auth_token ||= double("auth token", save!: nil)
      end

      before do
        allow(AuthenticationToken).to receive(:new) { auth_token }
      end

      it "returns nil if the auth token fails to save" do
        allow(auth_token).to receive(:save!)
          .and_raise(ActiveRecord::ActiveRecordError)

        expect(create_token!.make_authentication_token(client_uuid: 1))
          .to be_nil
      end

      it "returns nil if the config token is expired" do
        token = create_token!
        token.update(expires_at: DateTime.current - 1.hour)

        expect(token.make_authentication_token(client_uuid: "x")).to be_nil
      end

      it "returns the auth token" do
        expect(create_token!.make_authentication_token(client_uuid: 3))
          .to eq auth_token
      end
    end

    describe "initialization" do
      it "sets the expiration date" do
        expect(create_token!.expires_at).to be > Time.zone.now
      end

      it "sets the token value" do
        expect(create_token!.value.length)
          .to eq ConfigurationToken::TOKEN_LENGTH
      end
    end
  end
end
