require "spec_helper"
require "github_readme"

RSpec.describe GithubContributions do
  describe "#recent" do
    it "fetches the top 5 most recent contributions" do
      Excon.stub({},
        { status: 200, body: fixture(name: "github_contributions_all") }
      )
      gc = described_class.new(username: "nickcharlton")

      recent = gc.recent

      expect(recent.count).to eq(5)
    end

    context "when a pull request is open" do
      it "builds a Contribution" do
        Excon.stub({},
          { status: 200, body: fixture(name: "github_contributions_open_pull_request") }
        )
        gc = described_class.new(username: "nickcharlton")

        recent = gc.recent

        expect(recent.first).to have_attributes(
          title: "Add Samba printing to the README",
          url: "https://github.com/lukevp/ESC-POS-.NET/pull/185",
          state: "open",
          type: "pull_request"
        )
      end
    end

    context "when a pull request is draft" do
      it "builds a Contribution" do
        Excon.stub({},
          { status: 200, body: fixture(name: "github_contributions_draft_pull_request") }
        )
        gc = described_class.new(username: "nickcharlton")

        recent = gc.recent

        expect(recent.first).to have_attributes(
          title: "Add Samba printing to the README",
          url: "https://github.com/lukevp/ESC-POS-.NET/pull/185",
          state: "draft",
          type: "pull_request"
        )
      end
    end

    context "when a pull request is merged" do
      it "builds a Contribution" do
        Excon.stub({},
          { status: 200, body: fixture(name: "github_contributions_merged_pull_request") }
        )
        gc = described_class.new(username: "nickcharlton")

        recent = gc.recent

        expect(recent.first).to have_attributes(
          title: "Use file_field instead of text_field in the form",
          url: "https://github.com/thoughtbot/administrate-field-image/pull/22",
          state: "merged",
          type: "pull_request"
        )
      end
    end

    it "builds a Contribution from an issue" do
      Excon.stub({},
        { status: 200, body: fixture(name: "github_contributions_issue") }
      )
      gc = described_class.new(username: "nickcharlton")

      recent = gc.recent

      expect(recent.first).to have_attributes(
        title: "ERB Lint fails with not installed error",
        url: "https://github.com/wearerequired/lint-action/issues/495",
        state: "open",
        type: "issue"
      )
    end

    def fixture(name:)
      File.read("spec/fixtures/#{name}.json")
    end
  end
end
