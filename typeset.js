function detectUserAgent() {
  var match = navigator.userAgent.match(/(firefox|safari|chrome|opera|msie)/i);
  if (match) {
    $('body').addClass(match[0].toLowerCase());
  }
  return true;
}

function typeset(tag) {
  var $nodes = $(tag).children('[class!="not-rendered"]');
  var $old_nodes = $nodes;
  var last_page;
  var pages = 0;

  function form_page() {
    var body = $(tag);

    if (last_page == undefined) {
      body.prepend('<div id="page-' + pages + '" class="page"></div>');
    }
    else {
      $('<div id="page-' + pages + '" class="page"></div>').insertAfter(last_page);
    }

    var page = $('#page-' + pages);
    last_page = page;

    var pageBreak = false;

    var padder;
    var pad_strategy;

    var page_height = page.height() - 10;

    var curY = 0;
    while($nodes.length > 0) {
      var node = $nodes.first();
      if (node.is('script')) {
        $nodes = $nodes.slice(1);
        continue;
      }

      if (curY > 0 && node.is('h1')) {
        // End the page
        pageBreak = true;
      }

      var new_node = node.clone();
      page.append(new_node);

      obj_height = new_node.outerHeight(true);
      if (pageBreak || curY + obj_height > page_height) {
        new_node.remove();

        if (node.is('p') && !pageBreak) {
          p = node.clone();
          p.empty();
          p.addClass('split');
          page.append(p);
          p = page.children("p.split");

          // Break up the paragraph
          var $contents = node.contents();
          var $words = new Array();
          for (var i = 0; i < $contents.length; i++) {
            if ($contents[i].nodeType == 3) {
              jQuery.each($contents[i].nodeValue.split(' '), function() {
                $words[$words.length] = this;
              });
            }
            else {
              var ntag = $contents[i].nodeName;
              var text = $contents[i].firstChild.nodeValue;

              jQuery.each(text.split(' '), function() {
                $words[$words.length] = "<" + ntag + ">" + this + "</" + ntag + ">";
              });
            }
          }

          for(var i = 0; i < $words.length; i++) {
            var word = $words[i];
            p.append(' ');
            p.append(word);
            obj_height = p.outerHeight(true);
            if (curY + obj_height > page_height) {
              // Remove word
              p[0].removeChild(p[0].lastChild);
              p[0].removeChild(p[0].lastChild);

              // Reform rest of paragraph
              node.empty();
              for ( ; i < $words.length; i++) {
                node.addClass('split-next');
                node.append(' ');
                node.append($words[i]);
              }
              break;
            }
          }

          obj_height = p.outerHeight(true);
          curY = (p.position().top - page.position().top) + obj_height;
        }

        // Space to play with
        var diff_height = page_height - curY;

        var $ps = page.children('p + p');
        var $divs = page.children('div');
        var $hs = page.children('h2');

        if (($divs.length + $hs.length) > 0) {
          var num_things = $ps.length + (2 * $divs.length) + (3 * $hs.length);

          var padding = diff_height / num_things;
          $ps.css('margin-top',      '+=' + padding);
          $divs.css('margin-top',    '+=' + padding);
          $divs.css('margin-bottom', '+=' + padding);
          $hs.css('margin-top',      '+=' + 3*padding);

          curY = page_height;
          diff_height = 0;
        }

        // Append footer
        page.append("<div class='footer'>" + (pages + 1) + "</div>");
        page.children("div.footer").css("margin-top", "+=" + diff_height);
        break;
      }

      curY = (new_node.position().top - page.position().top) + obj_height;

      if (node.is('h2') || node.is('h3')) {
        padder = new_node;
        pad_strategy = "push_down";
      }
      else if (node.is('div') || node.is('blockquote')) {
        padder = new_node;
        pad_strategy = "float";
      }

      node.remove();
      $nodes = $nodes.slice(1);
    }

    pages++;
  }

  while ($nodes.length > 0) {
    form_page();
  }
  return true;
}
