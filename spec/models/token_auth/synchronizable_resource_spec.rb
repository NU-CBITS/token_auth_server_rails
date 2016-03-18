# frozen_string_literal: true
require "rails_helper"

module TokenAuth
  RSpec.describe SynchronizableResource, type: :model do
    describe ".apply_filter" do
      context "when there is a range filter on updated_at" do
        def create_record
          SynchronizableResource.create!(
            entity_id: rand,
            entity_id_attribute_name: "entity_id",
            name: "synchronizable_resources",
            class_name: "TokenAuth::SynchronizableResource"
          )
        end

        it "includes results within the range" do
          create_record

          results = SynchronizableResource
                    .apply_filter(SynchronizableResource,
                                  updated_at: {
                                    gt: Time.zone.now - 1.minute
                                  })

          expect(results.count).to eq 1
        end

        it "excludes results outside the range" do
          create_record

          results = SynchronizableResource
                    .apply_filter(SynchronizableResource,
                                  updated_at: {
                                    gt: Time.zone.now + 1.minute
                                  })

          expect(results.count).to eq 0
        end
      end
    end
  end
end
