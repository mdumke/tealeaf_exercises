# Additional Tools

cheatsheet

tealeaf academy

## HAML

- when the haml-gem is installed, you can preprocess haml to html manually with `haml index.haml index.html`
- content can be written on the same line as the tag like `%h1 hello, work!`
- attributes can be added with {} and Ruby-hash syntax, e.g. `%section{ some: 'value' }`, or with () and html syntax, e.g. `%section(some="value")`
- also, Ruby code can be put on the same single line: `.item{ some: 'value' }= @item.text`
- the backslash will escape the following character, so `\= @post` will be printed as `= @post`, not being processed as Ruby but simply read as a string
- there is a Ruby helper-method for continuing with text on the same line, not introducing spaces, where the output of a block will be inserted before the succeeding text

    %p
      Click this
      = succeed "." do
        %a{ href: '#' } link

- there are a number of ways to comment out text  or blocks of code in haml:

    / this line is regular comment in html
    -# this line will not show up in html
    /
      all the lines nested
      here will not be shown

- conditional comments, e.g. for IE checking, have to be put in brackets

    /[if lt IE 9]
      %script{ src: 'html5shiv.js' }

- Filters can be used to execute code in Haml. Filters start with a colon and code is nested under them, common filters are  `cdata`, `plain`, `javascript`, `ruby`, `markdown` and a number of others
- attribute-hashes can be stretched over multiple lines if they break after a comma
- learn.shayhowe.com/advanced-html-css/preprocessors/


## Try jQuery tutorial

- common jQuery tasks:
- finding elements on a page
  - every webbrowser has a slightly different javascript interface: jQuery takes care of the differences so the same code will run in every browser
  - to find elements, use `jQuery('h1');` or `$('h1');` - but be careful, in jQuery's *safe-mode* the $ will not be available
  - jQuery will return a list of all elements that match a query-specification
  - selection can happen by id (`$('#container')`) or by class (`$('.highlight')`)
  - to find nested elements, use descendent selectors like `$('#tour_id event')`
  - to select only nested elements which are direct children, use the child selector: `$('#tour > li')`
  - to select multiple subclasses, use the comma like so: `$('#tour .on_sale, .asia')`
  - there is a `:first` pseudoselector for selecting only the first element in a list: `$('#laundry-list li:first')`
  - jQuery also has an `:even` pseudoselector to select every other element: `$('#laundry-list > li:even')`
  - *traversing the DOM* means finding elements not with desendant selectors but with helper methods, so instead of `$('#items li')` we cound say `$('#items').find('li')`
  - similarly, there are `.first()` and `.last()` methods for selecting elements
  - traversing the DOM is usually a bit faster than using descendant selectors
  - walking the DOM is possible with method chaining like `$('#items').first().next()`
  - traversing up can be accomplished via `$('#items').first().parent()`
  - traversing down is possible with `$('#element').children('li')` which corresponds to `$('#element > li')`
  - select elements within a list of elements that fulfill a certain condition with `$('#some_id').filter('.some_class');`

- changing the html-content
  - retrieve content via, e.g. `$('h1').text();` and modify it with `$('h1').text('an even more important headline');`
  - be careful that js-events which change the page do not fire until the page is loaded
  - to create a new DOM node, send the html into the jQuery function, e.g. `var new_element = $('<p>Some new content</p>');`
  - to add new nodes to the DOM, there are a number of methods available: `.before`, `.after` (work at the sibling-level) and `.prepend()` and `.append()` (work at the child-level)
  - remove an element by selecting it an calling `.remove()` on it
  - `appendTo(<element>)`, `prependTo(<element>)`, `.insertAfter(<element>)` and `.insertBefore(<element>)` have the same effect as the ones described above but the order of declaration is reversed
  - it is easy to add and remove classes to elements using `$('#element').addClass('my-class');` (`.removeClass(<name>);`)

- listening to events and reacting accordingly
  - we can listen to document-events with e.g. `jQuery(document).ready(function () { ... });`
  - to listen to events on any element, the general syntax is `$('element').on(<event>, <event handler>);`
  - this may look like `$('#item').on('click', function () { console.log('click!'); });`
  - inside the callback function, `this` will refer the the object that received an event, so we could e.g. remove it via `$(this).remove();`
  - for an element, we can find the ancestor with a given class using `$(this).closest('.some_class').after(add_me_to_the_dom);`
  - `$(this).parent('.some_class')` will find *all* the ancestors with the given class, while `closest` will find only one (or none)
  - when we need more information about elements in interaction, we can add `data-attributes` and refer to them with jQuery using `$('element').data(<name>)` (or set the data via `data(<name>, <value>)`
  - we can specify on which elements *inside* other elements we want to listen for events like `$('.some_class').on('click', 'button', <callback>);` ('event delegation')





- animating content on a page and talking over the network to get new content


