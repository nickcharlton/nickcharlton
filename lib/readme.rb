class Readme
  def initialize(file_path)
    @file_path = file_path
  end

  def update_contributions(contributions)
    content = contributions.map do |contribution|
      "[#{contribution.title}](#{contribution.url})\n"
    end.join("\n")

    new_contents = insert(file_contents, "contributions", content)
    File.write(file_path, new_contents)
  end

  private

  attr_reader :file_path

  def file_contents
    File.read(file_path)
  end

  def insert(document, marker, content)
    replacement = <<~REPLACEMENT
      <!-- #{marker} starts -->
      #{content}
      <!-- #{marker} ends -->
    REPLACEMENT

    document.gsub(
      /<!\-\- #{marker} starts \-\->.*<!\-\- #{marker} ends \-\->/m,
      replacement.chomp
    )
  end
end
