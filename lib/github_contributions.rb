require "json"
require "excon"

class GithubContributions
  def initialize(username:)
    @username = username
  end

  def recent(count: 5)
    response = client.get(query: {
      "q" => "author:#{username} sort:updated-desc is:public", per_page: count
    })

    data = JSON.parse(response.body, symbolize_names: true)

    data[:items].map do |item|
      Contribution.new(
        id: item[:id],
        title: item[:title],
        url: item[:html_url],
        state: item[:state],
        type: item.has_key?(:pull_request) ? "pull_request" : "issue",
        created_at: item[:created_at],
        updated_at: item[:updated_at]
      )
    end
  end

  private

  attr_reader :username

  def client
    Excon.new("https://api.github.com/search/issues", headers: headers)
  end

  def headers
    {
      "User-Agent" => "Recent GitHub Contributions (#{username})",
      "Accept" => "application/vnd.github+json",
      "Authorization" => "token #{ENV['GITHUB_TOKEN']}"
    }
  end
end
