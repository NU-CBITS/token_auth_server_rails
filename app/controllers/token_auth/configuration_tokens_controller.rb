# frozen_string_literal: true

module TokenAuth
  # Manages Configuration Tokens.
  class ConfigurationTokensController < ApplicationController
    def create
      token = ConfigurationToken.new(entity_id: params[:entity_id])

      if token.save
        redirect_to tokens_index,
                    notice: t("activerecord.success_saving",
                              name: token.class.model_name.human)
      else
        redirect_to tokens_index,
                    alert: t("activerecord.failure_saving",
                             name: token.class.model_name.human,
                             errors: errors_on(token))
      end
    end

    def destroy
      token = ConfigurationToken.find_by(entity_id: params[:entity_id])

      if token.nil?
        redirect_to tokens_index,
                    alert: t("activerecord.cannot_find",
                             name: ConfigurationToken.model_name.human)
      elsif token.destroy
        redirect_to tokens_index,
                    notice: t("activerecord.success_destroying",
                              name: ConfigurationToken.model_name.human)
      else
        redirect_to tokens_index,
                    alert: t("activerecord.failure_destroying",
                             name: ConfigurationToken.model_name.human,
                             errors: errors_on(token))
      end
    end

    private

    def tokens_index
      tokens_url params[:entity_id]
    end

    def errors_on(model)
      model.errors.full_messages.join ", "
    end
  end
end
