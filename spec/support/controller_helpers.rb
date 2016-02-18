# frozen_string_literal: true
module ControllerHelpers
  def create_invalid_credentials
    request.headers[TokenAuth::Concerns::ApiResources::AUTH_HEADER] = "oops"
  end

  def create_disabled_credentials
    allow(TokenAuth::AuthenticationToken).to receive(:find_enabled) { nil }
    request.headers[TokenAuth::Concerns::ApiResources::AUTH_HEADER] = "woot"
  end

  def create_valid_credentials
    participant = double("participant")
    token = double("token", participant: participant)
    allow(TokenAuth::AuthenticationToken).to receive(:find_enabled) { token }
    request.headers[TokenAuth::Concerns::ApiResources::AUTH_HEADER] = "woot"
  end

  def response_json
    @json ||= JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
end
