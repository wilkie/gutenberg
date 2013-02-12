# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gutenberg/version'

Gem::Specification.new do |gem|
  gem.name          = "gutenberg"
  gem.version       = Gutenberg::VERSION
  gem.authors       = ["wilkie"]
  gem.email         = ["wilkie05@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "tilt"      # haml/etc
  gem.add_dependency "redcarpet" # markdown
  gem.add_dependency "nokogiri"  # html parsing, html striping
  gem.add_dependency "babosa"    # slug generation
end
