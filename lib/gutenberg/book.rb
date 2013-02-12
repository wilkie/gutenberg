require 'gutenberg/chapter'

module Gutenberg
  # The collection of resources that make up the book.
  class Book
    require 'yaml'

    # The title of the book
    attr_reader :title

    # The authors of the book
    attr_reader :authors

    # The preferred style to use to generate it
    attr_reader :style

    # The chapters gathered in this book
    attr_reader :chapters

    # Will create the book class and organize all metadata. Can be passed the
    # following options:
    # :yaml    - the filename of YAML that describes the book
    #
    # :title   - the title of the book (default: "Untitled")
    # :authors - an array of authors (default: ["anonymous"])
    # :style   - the styling to use upon generation (default: "basic")
    #
    # :chapters - an array of chapter files (default: [])
    def initialize(options = {})
      if options[:yaml]
        data = YAML::load_file(options[:yaml])

        options[:title]    = options[:title]    || data["title"]
        options[:authors]  = options[:authors]  || data["authors"]
        options[:style]    = options[:style]    || data["style"]

        options[:chapters] = options[:chapters] || data["chapters"]
      end

      @title    = options[:title]   || "Untitled"
      @authors  = options[:authors] || ["anonymous"]
      @style    = options[:style]   || "basic"

      chapters = options[:chapters] || []

      @chapters = []
      chapters.each do |c|
        @chapters << Chapter.new(:markdown_file => c)
      end
    end
  end
end
