require "spec_helper"
require "github_readme"

RSpec.describe Readme do
  describe "#update_contributions" do
    it "replaces the existing data" do
      with_temp_directory do |dir|
        File.write("README.md", readme_body)
        readme = described_class.new("README.md")
        contributions = [
          double("Contribution", title: "A contribution",
                                 url: "http://example.com")
        ]

        readme.update(section: "contributions", contributions: contributions)

        expect(File.read("README.md")).to include(
          "[A contribution](http://example.com)"
        )
      end
    end
  end

  def with_temp_directory
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        yield(dir)
      end
    end
  end

  def readme_body
    <<~BODY
    Some intro text

    <!-- contributions starts -->
    <!-- contributions ends -->
    BODY
  end
end
