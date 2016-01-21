require "rails_helper"

module TokenAuth
  class MockThing
  end

  RSpec.describe Payload do
    describe "#save" do
      context "when the type is unrecognized" do
        it "registers an error" do
          params = [{ type: "baz", foo: "bar" }]
          payload = Payload.new(entity_id: 1)
          payload.save params

          expect(payload.valid_resources.length).to eq 0
          expect(payload.errors.length).to eq 1
        end
      end

      context "when a type is recognized" do
        let!(:pushable_resource) do
          SynchronizableResource.create!(
            entity_id: 1,
            entity_id_attribute_name: "participant_id",
            name: "things",
            class_name: "TokenAuth::MockThing",
            is_pushable: true
          )
        end
        let(:params) { [{ type: "things", uuid: "123", foo: "bar" }] }
        let(:payload) { Payload.new(entity_id: 1) }
        let(:mock_thing) { double("mock thing") }

        context "when the entities params are malformed" do
          it "registers an error" do
            payload.save([[]])

            expect(payload.valid_resources.length).to eq 0
            expect(payload.errors.length).to eq 1
          end
        end

        context "when its resource is saved successfully" do
          it "captures the serialized version" do
            allow(mock_thing).to receive(:update)
              .with("participant_id" => 1, "foo" => "bar").and_return(true)
            allow(MockThing).to receive(:find_or_initialize_by)
              .with(uuid: "123").and_return(mock_thing)
            payload.save params

            expect(payload.errors.length).to eq 0
            expect(payload.valid_resources.length).to eq 1
            expect(payload.valid_resources.first).to eq(mock_thing)
          end
        end

        context "when its resource fails to save without an error" do
          it "captures the error" do
            err = double("errors", full_messages: ["whoomp!"])
            allow(mock_thing).to receive(:update)
              .with("participant_id" => 1, "foo" => "bar").and_return(false)
            allow(mock_thing).to receive(:errors) { err }
            allow(MockThing).to receive(:find_or_initialize_by)
              .with(uuid: "123").and_return(mock_thing)
            payload.save params

            expect(payload.valid_resources.length).to eq 0
            expect(payload.errors.length).to eq 1
            expect(payload.errors.first).to eq("whoomp!")
          end
        end

        context "when its resource fails to save with an unknown attr error" do
          it "captures the error" do
            allow(mock_thing).to receive(:update)
              .with("participant_id" => 1, "foo" => "bar")
              .and_raise(ActiveRecord::UnknownAttributeError.new(mock_thing,
                                                                 "foo"))
            allow(MockThing).to receive(:find_or_initialize_by)
              .with(uuid: "123").and_return(mock_thing)
            payload.save params

            expect(payload.valid_resources.length).to eq 0
            expect(payload.errors.length).to eq 1
            expect(payload.errors.first).to match(/unknown attribute/)
          end
        end
      end
    end
  end
end
