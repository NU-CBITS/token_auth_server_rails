module TokenAuth
  # Manage configuration and authentication tokens.
  class TokensController < ::TokenAuth::BaseController
    def index
      @entity_id = params[:id]
      @authentication_token = AuthenticationToken
                              .find_by_entity_id(@entity_id)
      @configuration_token = ConfigurationToken
                             .find_by_entity_id(@entity_id)
    end
  end
end
