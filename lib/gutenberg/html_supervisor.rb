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

    # Returns the acknowledgements section.
    def format_acknowledgements()
      s = "<ul>"
      if @book.style.attribute?
        s << "<li>Layout and style '#{@book.style.name}' provided by "
        if @book.style.author_url
          s << "<a href='#{@book.style.author_url}'>#{@book.style.author}</a>"
        else
          s << @book.style.author
        end
        s << "."
        s << "</ul><ul>"
      end
      @book.style.assets.each do |a|
        next unless a.attribute?
        next unless a.name
        s << "<li>"
        if a.collection_url
          s << "<a href='#{a.collection_url}'>#{a.name}</a>"
        elsif a.name
          s << a.name
        end
        s << " is provided by "
        if a.author_url
          s << "<a href='#{a.author_url}'>#{a.author}</a>"
        elsif a.author
          s << a.author
        else
          s << "anonymous"
        end
        if a.collection
          s << " as part of "
          s << "#{a.collection}"
        end
        s << ".</li>"
      end
      s << "</ul>"
    end
  end
end
