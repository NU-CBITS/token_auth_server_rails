# frozen_string_literal: true

# Hook into model lifecycle events.
class UuidCallbacks
  def self.before_validation(model)
    model.uuid ||= SecureRandom.uuid
  end
end
