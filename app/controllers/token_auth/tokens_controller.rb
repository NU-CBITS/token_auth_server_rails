module TokenAuth
  # Manage configuration and authentication tokens.
  class TokensController < ::TokenAuth::BaseController
    def index
      @participant_id = params[:id]
      @authentication_token = AuthenticationToken
                              .find_by_participant_id(@participant_id)
      @configuration_token = ConfigurationToken
                             .find_by_participant_id(@participant_id)
    end
  end
end
