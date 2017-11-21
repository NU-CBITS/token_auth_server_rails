# frozen_string_literal: true

# no doc
class ParticipantCallbacks
  DEFAULT_GROUP_ID = 1

  attr_reader :participant

  def after_save(participant)
    @participant = participant
    create_pushable_resources
    create_pullable_resources
  end

  def allow_pushable_resource_types(types)
    @pushable_resource_types = types
  end

  def allow_pullable_resource_types(types)
    @pullable_resource_types = types
  end

  private

  def pushable_resource_types
    @pushable_resource_types || Rails.configuration.pushable_resource_types
  end

  def pullable_resource_types
    @pullable_resource_types || Rails.configuration.pullable_resource_types
  end

  def create_pushable_resource(type)
    TokenAuth::SynchronizableResource.create!(
      entity_id: participant.id,
      entity_id_attribute_name: "participant_id",
      name: type.underscore.pluralize,
      class_name: type,
      is_pullable: false,
      is_pushable: true
    )
  end

  def create_pullable_resource(type)
    TokenAuth::SynchronizableResource.create!(
      entity_id: participant.id,
      entity_id_attribute_name: "participant_id",
      name: type.underscore.pluralize,
      class_name: type,
      is_pullable: true,
      is_pushable: false
    )
  end

  def create_pushable_resources
    pushable_resource_types.each do |type|
      next if TokenAuth::SynchronizableResource.exists?(
        entity_id: participant.id,
        class_name: type
      )

      create_pushable_resource type
    end
  end

  def create_pullable_resources
    pullable_resource_types.each do |type|
      next if TokenAuth::SynchronizableResource.exists?(
        entity_id: participant.id,
        class_name: type
      )

      create_pullable_resource type
    end
  end
end
