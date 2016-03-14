# frozen_string_literal: true
module TokenAuth
  # A resource that may be pushed and/or pulled by an entity.
  class SynchronizableResource < ActiveRecord::Base
    include UuidEnabled

    validates :uuid, :entity_id, :entity_id_attribute_name, :name, :class_name,
              presence: true
    validates :is_pullable, :is_pushable, inclusion: { in: [true, false] }

    def klass
      class_name.constantize
    end
  end
end
