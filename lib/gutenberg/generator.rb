require 'gutenberg/html_supervisor'

module Gutenberg
  # Generates HTML with the given style and book content.
  class Generator
    require 'tilt'

    # Constructs a generator for the given style.
    def initialize(style)
			@view_path = "#{File.dirname(__FILE__)}/styles/#{style}"
      @layout = Tilt.new("#{@view_path}/layout.haml")
    end

    # Produce HTML for the given Gutenberg::Book.
    def render(book)
      template = Tilt.new("#{@view_path}/book.haml")
      supervisor = HTMLSupervisor.new(book)
      @layout.render(supervisor) do
        template.render supervisor
      end
    end

    # Produce an HTML file for the given Gutenberg::Book.
    def render_to(book, file)
      File.open(file, "w+") do |f|
        f.write render(book)
      end
    end

    # Copies the assets required for the given book to the given output path.
    def copy(book, to)
      book.style.copy(to)
    end
  end
end
