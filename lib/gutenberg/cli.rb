require 'optparse'

require 'gutenberg'
require 'gutenberg/book'
require 'gutenberg/generator'

module Gutenberg
  # The commandline interface to Gutenberg.
  class CLI
    # Usage banner
    BANNER = <<-USAGE
    gutenberg - HTML Hypermedia Book Generator

    Generate a book
      gutenberg my_book.yml
    USAGE

    class << self
      # Parse and respond to the command line options.
      def parse_options
        options = {}
        @opts = OptionParser.new do |opts|
          opts.banner = BANNER.gsub(/^    /, '')

          opts.separator ''
          opts.separator 'Options:'

          opts.on('-h', '--help', 'Display this help') do
            puts opts
            exit 0
          end
        end

        @opts.parse!
      end

      # Executes the command line version of gutenberg.
      def CLI.run
        begin
          parse_options
        rescue OptionParser::InvalidOption => e
          warn e
          exit -1
        end

        if ARGV.empty?
          book_yaml = "book.yml"
        else
          book_yaml = ARGV[0]
        end

        # Default
        book = Book.new(:yaml => book_yaml)
        basename = File.basename(book_yaml, File.extname(book_yaml))
        gen  = Generator.new("basic")
        gen.render_to book, "#{basename}.html"
        gen.copy book, "."
        exit 0
      end
    end
  end
end
