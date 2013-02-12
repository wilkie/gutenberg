module Gutenberg
  # The collection of resources that make up the book.
  class Book
    require 'yaml'

    # The title of the book
    attr_reader :title

    # Will create the book class and organize all metadata.
    def initialize(options = {})
      if options[:yaml]
        data = YAML::load_file(options[:yaml])
        options[:title] = options[:title] || data["title"]
        options[:authors] = options[:authors] || data["authors"]
        options[:style] = options[:style] || data["style"]
      end

      @title = options[:title] || "Untitled"
      @authors = options[:authors] || ["anonymous"]
      @style = options[:style] || "basic"
    end
  end
end
