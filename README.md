# Docker-Metrics

Ruby wrapper for docker metrics tools(support both LXC driver)

## Installation

Add this line to your application's Gemfile:

    gem 'docker-metrics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker-metrics

## Usage

You should have docker already installed on your system before using this library

Example:

``` ruby
require 'docker/metrics'

name = 'container_name'

container=Docker::Metrics::container(name)

report = container.gather_data

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/docker-metrics-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
