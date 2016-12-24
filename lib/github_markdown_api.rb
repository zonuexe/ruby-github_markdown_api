require 'github_markdown_api/version'

module GitHubMarkdownAPI
  DEFAULT_SCHEME       = :https
  DEFAULT_HOST         = 'api.github.com'
  DEFAULT_PORT         = nil
  DEFAULT_ENDPOINTS    = {
    raw:  '/markdown/raw',
    attr: '/markdown',
  }
  DEFAULT_AUTH         = nil
  DEFAULT_CONTENT_TYPE = 'text/plain'

  autoload :APIClient, 'github_markdown_api/api_client'
  autoload :Raw, 'github_markdown_api/raw'
end
