# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker/metrics/version'

Gem::Specification.new do |spec|
  spec.name          = "docker-metrics-ruby"
  spec.version       = Docker::Metrics::VERSION
  spec.authors       = ["cheyang"]
  spec.email         = ["cheyang@163.com"]
  spec.summary       = %q{Docker container metrics wrapper.}
  spec.description   = %q{Docker container metrics wrapper.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "mixlib-log", '>= 0'
  spec.add_dependency 'docker-api', '>= 0'
  spec.add_dependency 'lxc-ruby', '>= 0'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
