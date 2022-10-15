require "json"
require "excon"
require "feedjira"

class RssFeed
  def initialize(url:)
    @url = url
  end

  def recent(count: 5)
    response = client.get
    feed = Feedjira.parse(response.body)

    feed.entries.first(count).map do |entry|
      FeedItem.new(
        id: entry.id,
        title: entry.title,
        url: entry.links.first,
        created_at: entry.published,
        updated_at: entry.updated,
      )
    end
  end

  private

  attr_reader :url

  def client
    Excon.new(url)
  end
end
