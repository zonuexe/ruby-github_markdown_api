require 'uri'
require 'net/https'
require 'github_markdown_api/version'

# Abstract class of API Clients
# @abstract
class GitHubMarkdownAPI::APIClient
  # @param [Hash,String] args
  def initialize (args = {}, sub_args = {})
    case args
    when Hash
      set_option args
    when String
      # pending
    end
  end

  attr_reader :last_response

  # @return [Symbol] Scheme of API
  # @note `:http` of `:https`
  attr_accessor :scheme

  # @return [String] Hostname
  attr_accessor :host

  # @return [Fixnum] Port number
  attr_accessor :port

  # @return [Hash] Endpoint (Server path of API)
  attr_accessor :endpoints

  # @return [String] HTTP ContentType
  attr_accessor :content_type

  # @param  [Hash] args
  # @return [self]
  def set_option (args)
    option = default_options.merge(args)
    @scheme       = option[:scheme].intern
    @host         = option[:host].to_s
    @port         = option[:port]
    @endpoints    = option[:endpoints].to_hash
    @content_type = option[:content_type].to_s
    return self
  end

  # Returns hash of default options
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

  # Requests API
  # @param  [URI]    raw_uri
  # @param  [Hash]   request
  # @return [String]
  def request (raw_uri, post)
    http = Net::HTTP.new(raw_uri.host, raw_uri.port)
    if @scheme == :https
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    response = http.start{ http.request post }
    @last_response = response

    case response
    when Net::HTTPSuccess
      return response.body
    else
      raise RuntimeError, response
    end
  end

  # Renders HTML from Markdown
  # @param [String] markdown
  # @abstract
  def render (markdown)
    raise NotImplementedError, "#{__method__} is a abstract method."
  end

  # Returns endpoint of API type
  # @param  [Symbol,#to_sym] type
  # @return [URI]
  def endpoint (type)
    path  = @endpoints[type.to_sym]
    klass = case @scheme
            when :http;  URI::HTTP
            when :https; URI::HTTPS
            end
    param = {
      host: @host,
      path: path,
    }
    param[:port] = @port || 443

    return  klass.build(param)
  end
end
