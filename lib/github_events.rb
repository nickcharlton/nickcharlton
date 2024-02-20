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
      event_action = item[:payload][:action]
      event_created_at = item[:created_at]
      repo_name = item[:repo][:name]

      case event_type
      when "IssuesEvent"
        issue = item[:payload][:issue]

        title = issue[:title]
        url = issue[:html_url]

        if event_action == "closed"
          if issue[:state_reason] == "completed"
            event_action = "completed"
          end
        end
      when "IssueCommentEvent"
        next unless event_action == "created"

        issue = item[:payload][:issue]
        comment = item[:payload][:comment]

        title = issue[:title]
        url = comment[:html_url]
      when "PullRequestEvent"
        pr = item[:payload][:pull_request]

        if event_action == "closed"
          event_action = pr[:merged_at] ? "merged" : event_action
        end

        title = pr[:title]
        url = pr[:html_url]
      else
        puts "Skipping unhandled event_type: #{event_type}"
        next
      end

      Event.new(
        id: event_id,
        type: event_type,
        action: event_action,
        topic: repo_name,
        title: title,
        url: url,
        created_at: event_created_at
      )
    end.compact
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
