module TokenAuth
  # A key shared with a client for authenticating requests.
  class AuthenticationToken < ActiveRecord::Base
    TOKEN_LENGTH = 32
    UUID_LENGTH = 36

    validates :participant_id, :value, :uuid, :client_uuid, presence: true
    validates :value, :participant_id, :client_uuid, uniqueness: true
    validates :value, length: { is: TOKEN_LENGTH }
    validates :uuid, length: { is: UUID_LENGTH }
    validates :is_enabled, inclusion: { in: [true, false] }

    before_validation :set_value, :set_uuid, on: :create

    def self.find_enabled(client_uuid:, value:)
      find_by(client_uuid: client_uuid, value: value, is_enabled: true)
    end

    private

    def set_value
      loop do
        self.value = SecureRandom.hex(TOKEN_LENGTH / 2)
        break unless self.class.exists?(value: value)
      end
    end

    def set_uuid
      self.uuid = SecureRandom.uuid
    end
  end
end
