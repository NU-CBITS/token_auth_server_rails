# frozen_string_literal: true
module TokenAuth
  # Serializer for SynchronizableResource.
  class SynchronizableResourceSerializer < ActiveModel::Serializer
    attributes :name
    attribute :uuid, key: :id
  end
end
