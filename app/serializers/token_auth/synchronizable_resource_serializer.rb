# frozen_string_literal: true

module TokenAuth
  # Serializer for SynchronizableResource.
  class SynchronizableResourceSerializer < ActiveModel::Serializer
    attributes :name

    def id
      object.uuid
    end
  end
end
