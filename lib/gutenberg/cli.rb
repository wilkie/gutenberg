require 'optparse'

require 'gutenberg'
require 'gutenberg/book'

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
          puts @opts
          exit -1
        end

        # Default
        book = Book.new(:yaml => ARGV[1])
        exit 0
      end
    end
  end
end
