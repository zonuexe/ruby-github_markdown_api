# Client implementation of Markdown Raw API
class GitHubMarkdownAPI::Raw < GitHubMarkdownAPI::APIClient
  # @param  [String] markdown
  # @return [String]
  def render(markdown)
    raw_uri = endpoint(:raw)

    headers = {
      'Content-Type' => @content_type
    }

    post = Net::HTTP::Post.new(raw_uri, headers)
    post.body = markdown

    request(raw_uri, post)
  end
end
