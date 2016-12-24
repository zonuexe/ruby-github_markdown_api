require 'uri'
require 'net/https'

# Abstract class of API Clients
# @abstract
class GitHubMarkdownAPI::APIClient
  def self.render(markdown)
    new.render(markdown)
  end

  # @param [Hash,String] args
  def initialize(args = {}, sub_args = {})
    case args
    when Hash
      set_option(args)
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
  def set_option(args)
    option = default_options.merge(args)

    self.scheme = option[:scheme].to_sym
    self.host = option[:host].to_s
    self.port = option[:port]
    self.endpoints = option[:endpoints].to_h
    self.content_type = option[:content_type].to_s

    self
  end

  # Renders HTML from Markdown
  # @param [String] markdown
  # @abstract
  def render(markdown)
    raise NotImplementedError, "#{__method__} is a abstract method."
  end

  private

  # Requests API
  # @param  [URI]    raw_uri
  # @param  [Hash]   request
  # @return [String]
  def request(raw_uri, post)
    http = Net::HTTP.new(raw_uri.host, raw_uri.port)

    if scheme == :https
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    response = http.start { http.request(post) }
    @last_response = response

    case response
    when Net::HTTPSuccess
      response.body
    else
      raise RuntimeError, response
    end
  end

  # Returns endpoint of API type
  # @param  [Symbol,#to_sym] type
  # @return [URI]
  def endpoint(type)
    path = endpoints[type.to_sym]
    scheme_class = URI.scheme_list.fetch(scheme.to_s.upcase)

    param = {
      host: host,
      path: path,
      port: (port || 443)
    }

    scheme_class.build(param)
  end

  # Returns hash of default options
  # @return [Hash]
  def default_options
    {
      scheme:       GitHubMarkdownAPI::DEFAULT_SCHEME,
      host:         GitHubMarkdownAPI::DEFAULT_HOST,
      port:         GitHubMarkdownAPI::DEFAULT_PORT,
      endpoints:    GitHubMarkdownAPI::DEFAULT_ENDPOINTS,
      auth:         GitHubMarkdownAPI::DEFAULT_AUTH,
      content_type: GitHubMarkdownAPI::DEFAULT_CONTENT_TYPE,
    }
  end
end
