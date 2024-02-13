require "spec_helper"
require "github_events"

RSpec.describe Event do
  describe "#to_event_line" do
    context "with an issue comment" do
      it "is a markdown formatted line to the event" do
        event = new_event(type: "IssueCommentEvent")

        expect(event.to_event_line).to eq("Commented on _[Event](http://example.com)_")
      end
    end

    def new_event(type:)
      described_class.new(
        id: nil,
        type: type,
        action: "created",
        topic: "nickcharlton/nickcharlton",
        title: "Event",
        url: "http://example.com",
        created_at: nil
      )
    end
  end
end
