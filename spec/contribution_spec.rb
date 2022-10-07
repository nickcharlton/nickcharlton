require "spec_helper"
require "github_readme"

RSpec.describe Contribution do
  describe "#to_readme_line" do
    context "with an open issue" do
      it "is a markdown link to the contribution" do
        contribution = new_contribution(type: "issue", state: "open")

        expect(contribution.to_readme_line).to eq(
          "![](icons/issue_open.svg) [Contribution](http://example.com)\n",
        )
      end
    end

    context "with a closed issue" do
      it "is a markdown link to the contribution" do
        contribution = new_contribution(type: "issue", state: "closed")

        expect(contribution.to_readme_line).to eq(
          "![](icons/issue_closed.svg) [Contribution](http://example.com)\n",
        )
      end
    end

    context "with an open pull request" do
      it "is a markdown link to the contribution" do
        contribution = new_contribution(type: "pull_request", state: "open")

        expect(contribution.to_readme_line).to eq(
          "![](icons/pull_request_open.svg) [Contribution](http://example.com)\n",
        )
      end
    end

    context "with an closed pull request" do
      it "is a markdown link to the contribution" do
        contribution = new_contribution(type: "pull_request", state: "closed")

        expect(contribution.to_readme_line).to eq(
          "![](icons/pull_request_closed.svg) [Contribution](http://example.com)\n",
        )
      end
    end

    context "with an merged pull request" do
      it "is a markdown link to the contribution" do
        contribution = new_contribution(type: "pull_request", state: "merged")

        expect(contribution.to_readme_line).to eq(
          "![](icons/pull_request_merged.svg) [Contribution](http://example.com)\n",
        )
      end
    end

    context "with an draft pull request" do
      it "is a markdown link to the contribution" do
        contribution = new_contribution(type: "pull_request", state: "draft")

        expect(contribution.to_readme_line).to eq(
          "![](icons/pull_request_draft.svg) [Contribution](http://example.com)\n",
        )
      end
    end

    def new_contribution(type:, state:)
      described_class.new(
        id: nil,
        title: "Contribution",
        url: "http://example.com",
        state: state,
        type: type,
        created_at: nil,
        updated_at: nil,
      )
    end
  end
end
