require 'uri'
require 'net/https'
require 'github_markdown_api/version'

class GitHubMarkdownAPI::Client
  # @param [Hash] args
  def initialize (args = {})
    set_option args
  end

  attr_reader :last_response

  def render
    
  end

  # @param  [Hash] args
  # @return []
  def set_option (args)
    option = default_options.merge(args)
    @scheme       = option[:scheme].intern
    @host         = option[:host].to_s
    @port         = option[:port].to_i
    @endpoints    = option[:endpoints].to_hash
    @content_type = option[:content_type].to_s
    return self
  end

  # @return [Hash]
  def default_options
    return {
      scheme:       GitHubMarkdownAPI::DEFAULT_SCHEME,
      host:         GitHubMarkdownAPI::DEFAULT_HOST,
      port:         GitHubMarkdownAPI::DEFAULT_PORT,
      endpoints:    GitHubMarkdownAPI::DEFAULT_ENDPOINTS,
      auth:         GitHubMarkdownAPI::DEFAULT_AUTH,
      content_type: GitHubMarkdownAPI::DEFAULT_CONTENT_TYPE,
    }
  end

  # @param  [String] markdown
  # @return [String]
  def raw (markdown)
    raw_uri = endpoint(:raw)
    header  = {
      'Content-Type' => @content_type
    }
    post = Net::HTTP::Post.new(raw_uri, header)
    post.body = markdown

    request = Net::HTTP.new(raw_uri.host, raw_uri.port)
    if @scheme == :https
      request.use_ssl = true
      request.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    response = request.start{|http| http.request(post) }
    @last_response = response

    case response
    when Net::HTTPSuccess
      return response.body
    else
      raise RuntimeError, response
    end
  end

  # @param  [Symbol,#to_sym]
  # @return [URI]
  def endpoint(type)
    path  = @endpoints[type.to_sym]
    klass = case @scheme
            when :http;  URI::HTTP
            when :https; URI::HTTPS
            end
    uri = klass.build(host: @host, path: path, port: @port)
    return uri
  end
end
