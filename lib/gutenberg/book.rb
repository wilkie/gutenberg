module Gutenberg
  class Book
    require 'yaml'

    attr_reader :title

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
