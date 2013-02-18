# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gutenberg/version'

Gem::Specification.new do |gem|
  gem.name          = "gutenberg"
  gem.version       = Gutenberg::VERSION
  gem.authors       = ["wilkie"]
  gem.email         = ["wilkie05@gmail.com"]
  gem.description   = %q{A book generator that takes markdown input and produces a typeset HTML document.}
  gem.summary       = %q{This project can take markdown and use either a predefined style or a
                         custom style and use this to generate an HTML document. It uses javascript to
                         typeset the document and present it with the traditional book form factor.}
  gem.homepage      = "https://github.com/wilkie/gutenberg"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "tilt"        # haml/etc
  gem.add_dependency "redcarpet"   # markdown
  gem.add_dependency "nokogiri"    # html parsing, html striping
  gem.add_dependency "text-hyphen" # text hyphenation
  gem.add_dependency "babosa"      # slug generation
end
