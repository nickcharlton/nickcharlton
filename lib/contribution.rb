class Contribution
  attr_accessor :id, :title, :url, :updated_at, :created_at, :state, :type

  def initialize(id:, title:, url:, state:, type:, created_at:, updated_at:)
    @id = id
    @title = title
    @url = url
    @state = state
    @type = type
    @created_at = created_at
    @updated_at = updated_at
  end
end

