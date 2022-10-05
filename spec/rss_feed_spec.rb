require "spec_helper"
require "github_readme"

RSpec.describe RssFeed do
  describe "#recent" do
    it "fetches the top 5 most recent posts" do
      Excon.stub({}, { status: 200, body: atom_feed })
      gc = described_class.new(url: "https://nickcharlton.net/atom.xml")

      recent = gc.recent

      expect(recent.count).to eq(5)
    end

    it "builds a Contribution from a feed item" do
      Excon.stub({}, { status: 200, body: atom_feed })
      gc = described_class.new(url: "https://nickcharlton.net/atom.xml")

      recent = gc.recent

      expect(recent.first).to have_attributes(
        title: "Week Notes #31",
        url: "https://nickcharlton.net/posts/week-notes-31.html",
        created_at: Time.new(2022, 03, 02),
      )
    end

    def atom_feed
      File.read("spec/fixtures/atom_feed.xml")
    end
  end
end
