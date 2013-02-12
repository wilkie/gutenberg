require 'optparse'

require 'gutenberg'

module Gutenberg
  # The commandline interface to Gutenberg.
  class CLI
    # Usage banner
    BANNER = <<-USAGE
    Gutenberg - HTML Hypermedia Book Generator
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

        puts @opts
      end

      # Executes the command line version of gutenberg.
      def CLI.run
        begin
          parse_options
        rescue OptionParser::InvalidOption => e
          warn e
          exit -1
        end

        # Default
        exit 0
      end
    end
  end
end
