require 'gutenberg/renderer'

module Gutenberg
  # Represents a chapter of the book.
  class Chapter
    require 'redcarpet'

    attr_accessor :title
    attr_accessor :authors

    def initialize(options = {})
      if options[:markdown_file]
        renderer = Gutenberg::Renderer.new(@slug)
        Redcarpet::Markdown.new(renderer, :fenced_code_blocks => true)

        # Will throw on error
        content = File.read(options[:markdown_file])
      end

      @title = options[:title] || "Untitled"
      @authors = options[:authors] || []
    end
  end
end
