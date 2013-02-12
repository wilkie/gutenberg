require 'gutenberg/renderer'

module Gutenberg
  # Represents a chapter of the book.
  class Chapter
    require 'redcarpet'

    attr_accessor :title
    attr_accessor :authors
    attr_accessor :slug

    def initialize(options = {})
      if options[:markdown_file]
        options[:slug] = options[:slug] || options[:markdown_file].gsub(/.md$/, "")

        renderer = Gutenberg::Renderer.new(options[:slug])
        Redcarpet::Markdown.new(renderer, :fenced_code_blocks => true)

        # Will throw on error
        content = File.read(options[:markdown_file])
      end

      @title   = options[:title] || "Untitled"
      @authors = options[:authors] || []
      @slug    = options[:slug] || "chapter"
    end
  end
end
