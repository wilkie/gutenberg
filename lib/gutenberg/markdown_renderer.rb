require 'gutenberg/node'

module Gutenberg
  require 'redcarpet'

  # Determines how to render markdown tags into HTML.
  class MarkdownRenderer < Redcarpet::Render::HTML
    require 'nokogiri'
    require 'cgi'

    # Returns the root Gutenberg::Node for the chapter contents.
    # You can traverse this data structure to get a layout of the headers
    # throughout the chapter.
    attr_reader :outline

    # The title of the chapter as given by the first header found in the
    # content.
    attr_reader :title

    # Creates a new renderer that can be given to Redcarpet. It expects to
    # receive a slug to use as a safe anchor and the chapter name in case a
    # primary header is not used. The name is overriden by a primary header.
    def initialize(slug, name, *args)
      @outline = Node.new(name || "Untitled")
      @last = @outline
      @slug = slug
      super *args
    end

    # Generates HTML for a markdown paragraph.
    def paragraph(text)
      match = text.match /^!([^ ]+)\s(.*)/
      if match
        "<div class='#{match[1]}'><p>#{match[2]}</p></div>\n"
      else
        "<p>#{text}</p>\n"
      end
    end

    # Generates HTML for a markdown codespan.
    def codespan(code)
      # Since codespans are inline with text, let's make sure we never
      # break up a codespan on wordwrap
      "<code>#{CGI::escapeHTML(code).gsub(/\-/, "&#8209;")}</code>"
    end

    # Generates HTML for a markdown code block.
    def block_code(code, language)
      code = CGI::escapeHTML(code);
      new_code = ""
      last_number = -1
      code.lines do |l|
        m = l.match(/^\!(\d)\!(.*)$/)
        if m
          if m[1] != last_number
            l = "<div class='ref_line s1 c#{m[1]}'><div>#{m[2]}\n"
            if last_number != -1
              l = "</div></div>" << l
            end
          else
            l = "#{m[2]}\n"
          end
          last_number = m[1]
        else
          if last_number != -1
            l = "</div></div>" << l
          end
          last_number = -1
        end
        new_code << l
      end
      "<pre><code>#{language}#{new_code}</code></pre>"
    end

    # Generates HTML for a markdown image.
    def image(link, title, alt_text)
      caption = ""
      caption = title
      title = Nokogiri::HTML(title).xpath("//text()").remove

      img_source = "<img src='#{link}' title='#{title}' alt='#{alt_text}' />"

      if link.match "http[s]?://(www.)?youtube.com"
        # embed the youtube link
        youtube_hash = link.match("youtube.com/.*=(.*)$")[1]
        img_source = "<div class='youtube'><div class='youtube_fixture'><img src='/images/youtube_placeholder.png' /><iframe class='youtube_frame' longdesc='#{alt_text}' src='http://www.youtube.com/embed/#{youtube_hash}'>#{alt_text}</iframe></div></div>"
      end

      caption = "<br /><div class='caption'>#{caption}</div>" unless caption == ""
      "</p><div class='image'>#{img_source}#{caption}</div><p>"
    end

    # Generates HTML for a markdown header.
    def header(text, header_level)
      new_node = Node.new text
      if header_level == 1
        @title = @title || text.strip
        @outline.text = text
        new_node = @outline
      elsif header_level == @last.level
        new_node.parent = @last.parent
        @last.sibling = new_node
      elsif header_level > @last.level
        new_node.parent = @last
        @last.child = new_node
      elsif header_level < @last.level
        new_node.parent = @last.parent.parent
        @last.parent.sibling = new_node
      end
      @last = new_node

      "<h#{header_level} id='#{new_node.slug}'>#{text}</h#{header_level}>"
    end
  end
end
