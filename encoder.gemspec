# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encoder/version'

Gem::Specification.new do |spec|
  spec.name          = "encoder"
  spec.version       = Encoder::VERSION
  spec.authors       = ["Nik Wolfgramm"]
  spec.email         = ["nik.wolfgramm@swisstxt.ch"]
  spec.description   = %q{A simple gem for automating the encoding process with ffmpeg}
  spec.summary       = %q{encoder - automating the encoding process with ffmpeg}
  spec.homepage      = "https://github.com/swisstxt/encoder"
  spec.license       = "MIT"


  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency "thor"
  spec.add_dependency "streamio-ffmpeg"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
