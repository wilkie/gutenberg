function getParameters() {
  return decodeURIComponent(window.location.search.replace("?", "")).split('&')
}

function shouldTypeset() {
  params = getParameters();

  var ret = true;

  $.each(params, function(i, v) {
    if (v == "plain") {
      ret = false;
    }
  });

  return ret;
}

function detectUserAgent() {
  var match = navigator.userAgent.match(/(firefox|safari|chrome|opera|msie)/i);
  if (match) {
    $('body').addClass(match[0].toLowerCase());
  }
  return true;
}

function syntaxHighlight() {
  // add prettyprint class to all <pre><code></code></pre> blocks
  var prettify = false;
  $("pre code").parent().each(function() {
    $(this).addClass('prettyprint');
    prettify = true;
  });

  // if code blocks were found, bring in the prettifier ...
  if ( prettify ) {
    prettyPrint();
  }
}

function romanize (num) {
	if (!+num)
		return false;
	var	digits = String(+num).split(""),
		key = ["","C","CC","CCC","CD","D","DC","DCC","DCCC","CM",
		       "","X","XX","XXX","XL","L","LX","LXX","LXXX","XC",
		       "","I","II","III","IV","V","VI","VII","VIII","IX"],
		roman = "",
		i = 3;
	while (i--)
		roman = (key[+digits.pop() + (i * 10)] || "") + roman;
	return Array(+digits.join("") + 1).join("M") + roman;
}


function toc(refs) {
  toc = $('div.toc li');
  $.each(toc, function(i, v) {
    element = toc.slice(i, i+1);
    link = element.children('a');
    tag = link.attr('href').slice(1);
    text = link.text();
    width = link.innerWidth();
    page_number = refs[tag];
    element.prepend('<div class="toc_page_number" style="float: right"> ' + page_number + '</div>');
    pn = element.children('div.toc_page_number').first();
    while (width + pn.innerWidth() < element.innerWidth()) {
      pn.prepend('.');
    }
    pn[0].removeChild(pn[0].firstChild);
  });
}

function should_not_be_typeset(node) {
  return (node.is('script') || node.attr('id') == "cover");
}

function typeset(tag) {
  var $nodes = $(tag).children('[class!="not-rendered"]');
  var $old_nodes = $nodes;

  var aux_pages = 1;
  var pages = 0;

  var page_name;

  var toc_refs = {};

  var last_page = $('#cover');

  var tocReached = false;
  var endPreface = false;
  function form_page() {
    if (pages != 0) {
      page_name = pages;
    }
    else {
      page_name = romanize(aux_pages).toLowerCase();
    }

    $('<div id="page-' + page_name + '" class="page"></div>').insertAfter(last_page);

    var page = $('#page-' + page_name);
    last_page = page;

    var pageBreak = false;

    var padder;
    var pad_strategy;

    var page_height = page.height() - 10;

    var curY = 0;
    while($nodes.length > 0) {
      var node = $nodes.first();
      if (should_not_be_typeset(node)) {
        $nodes = $nodes.slice(1);
        continue;
      }

      if (curY > 0 && node.is('h1')) {
        // End the page
        pageBreak = true;

        // If this is the end of the toc, we start the book content.
        if (tocReached == true) {
          endPreface = true;
        }

        // Is this the table of contents? we are at the end of the preface.
        if (node.attr('id') == "toc") {
          tocReached = true;
        }
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

        if (!pageBreak && ($divs.length + $hs.length) > 0) {
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
        page.append("<div class='footer'>" + page_name + "</div>");
        page.children("div.footer").css("margin-top", "+=" + diff_height);

        if (pageBreak && endPreface && pages == 0) { pages = 1; return; }
        break;
      }

      // Node Added
      if (node.attr('id')) {
        toc_refs[node.attr('id')] = page_name;
      }

      curY = new_node.position().top + obj_height;

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

    if (pages > 0) {
      pages++;
    }
    else {
      aux_pages++;
    }
  }

  while ($nodes.length > 0) {
    form_page();
  }

  // Do table of contents
  toc(toc_refs);
  return true;
}

$(window).bind('load', function() {
  detectUserAgent();
  syntaxHighlight();
  if (shouldTypeset()) {
    typeset('body');
  }
});
