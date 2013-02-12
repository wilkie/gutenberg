require 'gutenberg/renderer'

module Gutenberg
  # Represents a chapter of the book.
  class Chapter
    require 'redcarpet'
    require 'babosa'

    attr_accessor :title
    attr_accessor :authors
    attr_accessor :slug
    attr_accessor :content

    def initialize(options = {})
      if options[:markdown_file]
        options[:slug] = options[:slug] || options[:markdown_file].gsub(/.md$/, "").to_slug.to_s

        renderer = Gutenberg::Renderer.new(options[:slug])
        Redcarpet::Markdown.new(renderer, :fenced_code_blocks => true)

        # Will throw on error
        options[:content] = options[:content] || File.read(options[:markdown_file])
      end

      options[:content] = options[:content] || ""

      # Grab data from markdown
      match = options[:content].match(/^---$(.*?)^---$(.*)/m)

      unless match.nil?
        meta_data = match[1]
        options[:content] = match[2]

        meta_data = YAML.load(meta_data)

        options[:title] = options[:title] || meta_data["title"]
        options[:author] = options[:author] || meta_data["authors"]
        options[:scripts] = options[:scripts] || meta_data["scripts"]
        options[:summary] = options[:summary] || meta_data["summary"]
      end

      @title   = options[:title] || "Untitled"
      @authors = options[:authors] || []
      @slug    = options[:slug] || "chapter"
      @content = options[:content] || ""
    end
  end
end
