# frozen_string_literal: true
module TokenAuth
  # A resource that may be pushed and/or pulled by an entity.
  class SynchronizableResource < ActiveRecord::Base
    include UuidEnabled

    validates :uuid, :entity_id, :entity_id_attribute_name, :name, :class_name,
              presence: true
    validates :is_pullable, :is_pushable, inclusion: { in: [true, false] }

    def self.pullable_records_for(entity_id:, filter:)
      where(is_pullable: true, entity_id: entity_id)
        .map { |r| apply_filter(r.records, filter) }
        .flatten
    end

    def self.apply_filter(relation, filter)
      return relation unless filter && filter[:updated_at] &&
                             filter[:updated_at][:gt]

      timestamp = filter[:updated_at][:gt]

      relation.where(relation.arel_table[:updated_at].gt(timestamp))
    end

    def records
      klass.where(entity_id_attribute_name => entity_id)
    end

    def klass
      class_name.constantize
    end
  end
end
