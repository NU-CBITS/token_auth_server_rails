module TokenAuth
  # Manages Authentication Tokens.
  class AuthenticationTokensController < ::TokenAuth::BaseController
    def update
      token = AuthenticationToken.find_by_participant_id(params[:id])

      if token.update(token_params)
        redirect_to tokens_url(token.participant_id),
                    notice: t("activerecord.success_saving",
                              name: token.class.model_name.human)
      else
        redirect_to tokens_url(token.participant_id),
                    alert: t("activerecord.failure_saving",
                             name: token.class.model_name.human,
                             errors: errors_on(token))
      end
    end

    def destroy
      token = AuthenticationToken.find_by_participant_id(params[:id])

      if token.destroy
        redirect_to tokens_url(token.participant_id),
                    notice: t("activerecord.success_destroying",
                              name: token.class.model_name.human)
      else
        redirect_to tokens_url(token.participant_id),
                    alert: t("activerecord.failure_destroying",
                             name: token.class.model_name.human,
                             errors: errors_on(token))
      end
    end

    private

    def errors_on(model)
      model.errors.full_messages.join ", "
    end

    def token_params
      params.permit(:is_enabled)
    end
  end
end
