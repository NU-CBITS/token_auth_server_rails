# frozen_string_literal: true
module TokenAuth
  # An inbound resource. Inbound resource requests are validated and an
  # attempt is made to upsert them.
  class Payload
    attr_reader :valid_resources, :errors

    class MalformedPayloadError < StandardError
    end

    def self.resource_type(params)
      params.extract!(:type)[:type]

    rescue NoMethodError
      nil
    end

    def initialize(entity_id:)
      @entity_id = entity_id
      @valid_resources = []
      @errors = []
    end

    def save(entities_params)
      raise MalformedPayloadError unless entities_params.respond_to?(:each)

      entities_params.each do |entity_params|
        type = self.class.resource_type(entity_params)
        resource = find_pushable_resource(type)

        if resource
          upsert_resource(
            klass: resource.klass,
            params: entity_params.merge(
              "#{ resource.entity_id_attribute_name }": @entity_id
            )
          )
        else
          @errors << "invalid resource '#{ type }'"
        end
      end
    end

    private

    def find_pushable_resource(type)
      SynchronizableResource.find_by(
        name: type,
        is_pushable: true,
        entity_id: @entity_id
      )
    end

    def upsert_resource(klass:, params:)
      attributes = deserialize(params)
      resource = klass.find_or_initialize_by(uuid: attributes.delete("uuid"))

      if resource.update(attributes)
        @valid_resources << resource
      else
        @errors << resource.errors.full_messages.join(", ")
      end

    rescue ActiveRecord::UnknownAttributeError => error
      @errors << error.message
    end

    def deserialize(params)
      attrs = {}
      params.each do |name, value|
        name = name.to_s.underscore
        name = "uuid" if name == "id"
        attrs[name] = value
      end

      attrs
    end
  end
end
