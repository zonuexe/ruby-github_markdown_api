require 'uri'
require 'net/https'
require 'github_markdown_api/version'
require 'github_markdown_api/api_client'

# Client implementation of Markdown Raw API
class GitHubMarkdownAPI::Raw < GitHubMarkdownAPI::APIClient
  # @param  [String] markdown
  # @return [String]
  def render (markdown)
    raw_uri = endpoint(:raw)
    header  = {
      'Content-Type' => @content_type
    }
    post = Net::HTTP::Post.new(raw_uri, header)
    post.body = markdown

    request(raw_uri, post)
  end
end
