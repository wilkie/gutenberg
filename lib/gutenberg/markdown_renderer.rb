require 'gutenberg/node'

module Gutenberg
  require 'redcarpet'

  class MarkdownRenderer < Redcarpet::Render::HTML
    require 'nokogiri'
    require 'babosa'
    require 'cgi'

    attr_reader :outline
    attr_reader :title

    def initialize(slug, name, *args)
      @outline = Node.new(name || "Untitled")
      @last = @outline
      @slug = slug
      super *args
    end

    def codespan(code)
      # Since codespans are inline with text, let's make sure we never
      # break up a codespan on wordwrap
      "<code>#{CGI::escapeHTML(code).gsub(/\-/, "&#8209;")}</code>"
    end

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
