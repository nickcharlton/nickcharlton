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
      type = item.has_key?(:pull_request) ? "pull_request" : "issue"
      state = item[:draft] ? "draft" : item[:state]

      if type == "pull_request"
        state = item[:pull_request][:merged_at] ? "merged" : state
      end

      Contribution.new(
        id: item[:id],
        title: item[:title],
        url: item[:html_url],
        state: state,
        type: type,
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
    }
  end
end
