# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_markdown_api/version'

Gem::Specification.new do |spec|
  spec.name          = "github_markdown_api"
  spec.version       = GitHubMarkdownAPI::VERSION
  spec.authors       = ["USAMI Kenta"]
  spec.email         = ["tadsan@zonu.me"]
  spec.description   = %q{GitHub Markdown API client and command-line tool}
  spec.summary       = %q{}
  spec.homepage      = "http://dt.zonu.me/"
  spec.licenses      = %w[LGPLv3 NYSL]

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'hashize'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
