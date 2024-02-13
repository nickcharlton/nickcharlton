class Event
  attr_accessor :id, :type, :action, :topic, :title, :url, :created_at

  def initialize(id:, type:, action:, topic:, title:, url:, created_at:)
    @id = id
    @type = type
    @action = action
    @topic = topic
    @title = title
    @url = url
    @created_at = created_at
  end

  def to_event_line
    "#{event_description}"
  end

  private

  def event_description
    {
      "IssueCommentEvent" => "Commented on"
    }.fetch(type)
  end
end
