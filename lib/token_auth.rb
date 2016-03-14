# frozen_string_literal: true
require "token_auth/engine"

require "active_model_serializers"
ActiveModel::Serializer.config.adapter = :json_api

# nodoc
module TokenAuth
end
