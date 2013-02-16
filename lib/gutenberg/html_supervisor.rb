module Gutenberg
  # Is available as an instance to the views.
  class HTMLSupervisor
    # The Gutenberg::Book instance
    attr_reader :book

    # Creates an instance of the supervisor for the given book.
    def initialize(book)
      @book = book
    end
  end
end
