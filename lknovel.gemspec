# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lknovel/meta'

Gem::Specification.new do |spec|
  spec.name          = "lknovel"
  spec.version       = Lknovel::VERSION
  spec.authors       = ["Zhong Jianxin"]
  spec.email         = ["azuwis@gmail.com"]
  spec.summary       = %q{Generate epub from http://lknovel.lightnovel.cn/}
  spec.homepage      = "https://github.com/azuwis/ruby-lknovel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency 'gepub'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'parallel'

  spec.add_development_dependency 'pry-rescue'
end
