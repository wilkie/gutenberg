module Gutenberg
  # Is available as an instance to the views.
  class HTMLSupervisor
    # The Gutenberg::Book instance
    attr_reader :book

    # Creates an instance of the supervisor for the given book.
    def initialize(book)
      @book = book
    end

    # Returns an unordered list representing the given outline.
    def format_outline(outline)
      return "" if outline.nil?
      if outline.text == "References"
        "</ul><li><a href='##{outline.slug}'>#{outline.text}</a></li>#{format_outline(outline.sibling)}<ul>"
      else
        "<li><a href='##{outline.slug}'>#{outline.text}</a><ul>#{format_outline(outline.child)}</ul></li>#{format_outline(outline.sibling)}"
      end
    end
  end
end
