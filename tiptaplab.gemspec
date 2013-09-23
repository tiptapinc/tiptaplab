# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiptaplab/version'

Gem::Specification.new do |spec|
  spec.name          = "tiptaplab"
  spec.version       = Tiptaplab::VERSION
  spec.authors       = ["Ian McLean"]
  spec.email         = ["engineering@tiptap.com"]
  spec.description   = %q{TipTapLab API Integration}
  spec.summary       = %q{Provides the ability to track and compare psychological trait information using the TipTapLab API.}
  spec.homepage      = "http://github.com/tiptapinc/tiptaplab"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
