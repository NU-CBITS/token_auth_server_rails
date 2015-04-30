module TokenAuth
  # Manages Configuration Tokens.
  class ConfigurationTokensController < ApplicationController
    def create
      token = ConfigurationToken.new(entity_id: params[:entity_id])

      if token.save
        redirect_to tokens_url(token.entity_id),
                    notice: t("activerecord.success_saving",
                              name: token.class.model_name.human)
      else
        redirect_to tokens_url(token.entity_id),
                    alert: t("activerecord.failure_saving",
                             name: token.class.model_name.human,
                             errors: errors_on(token))
      end
    end

    def destroy
      token = ConfigurationToken.find_by_entity_id(params[:entity_id])

      if token.destroy
        redirect_to tokens_url(token.entity_id),
                    notice: t("activerecord.success_destroying",
                              name: token.class.model_name.human)
      else
        redirect_to tokens_url(token.entity_id),
                    alert: t("activerecord.failure_destroying",
                             name: token.class.model_name.human,
                             errors: errors_on(token))
      end
    end

    private

    def errors_on(model)
      model.errors.full_messages.join ", "
    end
  end
end
