# frozen_string_literal: true

require "active_support/concern"

module TokenAuth
  # Create a uuid, and add validation for format and presence of uuid.
  module UuidEnabled
    extend ActiveSupport::Concern

    included do
      before_validation { self.uuid ||= SecureRandom.uuid }

      validates :uuid, length: { is: 36 }, uniqueness: true, presence: true
    end
  end
end
