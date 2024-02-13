require "spec_helper"
require "github_events"

RSpec.describe GithubEvents do
  describe "#recent" do
    it "fetches the last 90 days of events" do
      Excon.stub({}, {status: 200, body: fixture(name: "github_events_all")})
      gc = described_class.new(username: "nickcharlton")

      recent = gc.recent

      expect(recent.count).to be(30)
    end

    context "with closed issue" do
      it "builds an Event" do
        Excon.stub({}, {status: 200, body: fixture(name: "github_events_issues_event_completed")})
        gc = described_class.new(username: "nickcharlton")

        recent = gc.recent

        expect(recent.first).to have_attributes(
          type: "IssuesEvent",
          action: "completed",
          topic: "thoughtbot/appraisal",
          title: "`customize_gemfiles` not working correctly with Ruby 3.1 due to hash used for keyword arguments",
          url: "https://github.com/thoughtbot/appraisal/issues/213"
        )
      end
    end
    context "with an new issue comment" do
      it "builds an Event" do
        Excon.stub({}, {status: 200, body: fixture(name: "github_events_issue_comment")})
        gc = described_class.new(username: "nickcharlton")

        recent = gc.recent

        expect(recent.first).to have_attributes(
          type: "IssueCommentEvent",
          topic: "thoughtbot/appraisal",
          title: "Running appraisal specs with Bundler >= 2.4.0 broken",
          url: "https://github.com/thoughtbot/appraisal/issues/218#issuecomment-1941379712"
        )
      end
    end

    context "with a deleted issue comment" do
      it "skips the event"
    end

    context "with an edited issue comment" do
      it "skips the event"
    end

    context "with merged pull request" do
      it "builds an Event" do
        Excon.stub({}, {status: 200, body: fixture(name: "github_events_merged_pull_request")})
        gc = described_class.new(username: "nickcharlton")

        recent = gc.recent

        expect(recent.first).to have_attributes(
          type: "PullRequestEvent",
          action: "merged",
          topic: "thoughtbot/administrate",
          title: "Bump dotenv-rails from 2.8.1 to 3.0.0",
          url: "https://github.com/thoughtbot/administrate/pull/2513"
        )
      end
    end

    context "with a deleted event" do
      it "skips the event" do
        Excon.stub({}, {status: 200, body: fixture(name: "github_events_deleted")})
        gc = described_class.new(username: "nickcharlton")

        expect(gc.recent).to be_empty
      end
    end
  end

  def fixture(name:)
    File.read("spec/fixtures/#{name}.json")
  end
end
