require "json"
require "excon"
require "event"

class GithubEvents
  def initialize(username:)
    @username = username
  end

  def recent
    response = client.get
    data = JSON.parse(response.body, symbolize_names: true)

    data.map do |item|
      event_id = item[:id]
      event_type = item[:type]
      event_created_at = item[:created_at]
      repo_name = item[:repo][:name]

      case event_type
      when "IssueCommentEvent"
        issue = item[:payload][:issue]
        comment = item[:payload][:comment]

        title = issue[:title]
        url = comment[:html_url]

        Event.new(
          id: event_id,
          type: event_type,
          topic: repo_name,
          title: title,
          url: url,
          created_at: event_created_at
        )
      when "PullRequestEvent"
        action = item[:payload][:action]
        pr = item[:payload][:pull_request]

        if action == "closed"
          action = pr[:merged_at] ? "merged" : action
        end

        title = pr[:title]
        url = pr[:html_url]

        Event.new(
          id: event_id,
          type: event_type,
          action: action,
          topic: repo_name,
          title: title,
          url: url,
          created_at: event_created_at
        )
      end
    end
  end

  private

  attr_reader :username

  def client
    Excon.new("https://api.github.com/users/#{username}/events/public", headers: headers)
  end

  def headers
    {
      "User-Agent" => "Recent Public GitHub Events (#{username})",
      "Accept" => "application/vnd.github+json"
    }
  end
end
