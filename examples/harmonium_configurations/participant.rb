# frozen_string_literal: true

# no doc
class Participant < ApplicationRecord
  # ...
  has_many :synchronizable_resources,
           class_name: ::TokenAuth::SynchronizableResource.to_s,
           foreign_key: :entity_id,
           dependent: :destroy
  has_many :authentication_tokens,
           class_name: ::TokenAuth::AuthenticationToken.to_s,
           foreign_key: :entity_id,
           dependent: :destroy
  has_many :configuration_tokens,
           class_name: ::TokenAuth::ConfigurationToken.to_s,
           foreign_key: :entity_id,
           dependent: :destroy

  has_one :participant_identification, inverse_of: :participant

  after_create :assign_readings
  after_save ParticipantCallbacks.new
  # ...
end
