GitHubMarkdownAPI
=================

GitHub's [Markdown Rendering API](http://developer.github.com/v3/markdown/) client and command-line tool.

Installation
------------

Add this line to your application's Gemfile:

    gem 'github_markdown_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install github_markdown_api

Usage
-----

In ruby script:

```ruby
require 'github_markdown_api'

md = <<EOM
AWESOME SCRIPT
==============

It's a wonderful markup languages!

 * Markdown
 * reStructuredText
EOM

github_md = GitHubMarkdownAPI::Client.new
html = github_md.raw(md)

puts html
#=>
# <h1>
# <a name="awesome-script" class="anchor" href="#awesome-script"><span class="octicon octicon-link"></span></a>AWESOME SCRIPT</h1>
# 
# <p>It's a wonderful markup languages!</p>
# 
# <ul>
# <li>Markdown</li>
# <li>reStructuredText</li>
# </ul>
```

In command-line:

```sh
% cat ./awesome.md
AWESOME SCRIPT
==============

It's a wonderful markup languages!

 * Markdown
 * reStructuredText

% github_markdown_api ./awesome.md > ./awesome.html
% cat ./awesome.html
<h1>
<a name="awesome-script" class="anchor" href="#awesome-script"><span class="octicon octicon-link"></span></a>AWESOME SCRIPT</h1>

<p>It's a wonderful markup languages!</p>

<ul>
<li>Markdown</li>
<li>reStructuredText</li>
</ul>
```

### Advansed

```
my_md_api = GitHubMarkdownAPI::Client.new(
    scheme:    'http',
	host:      'your.markdown.serv',
	port:      3939,
	endpoints: {raw: '/md/raw'},
)

puts my_md_api(markdown)
```

Contributing
------------

 1. Fork it
 2. Create your feature branch (`git checkout -b my-new-feature`)
 3. Commit your changes (`git commit -am 'Add some feature'`)
 4. Push to the branch (`git push origin my-new-feature`)
 5. Create new Pull Request
