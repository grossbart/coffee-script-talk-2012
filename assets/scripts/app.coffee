# The main application, that prepares everything for Shower.js
# Author: Peter Gassner <peter@interactivethings.com>

# Load the source data of our slides and wrap it in the appropriate
# HTML structure for use in the slideshow.
prepareSlides = (data) ->
  slides = markdown.toHTML(data)

  # As a first step, we split our document at headings (h1, h2, h3),
  # which we defined to be the start of a new slide. This means we
  # can't have more than one heading per slide. That's ok.
  slides = slides.split /(?=<h[123])/

  # We transform our HTML slides using regular expressions instead of
  # the DOM because it is *a lot* more performant. We can do this
  # because we're dealing with Markdown HTML, which by definition can't
  # be fancy (i.e. has lots of specialty HTML constructs).
  wrapSlide = (slide, idx) ->
    # If our slide starts with a <h1>, we make it bigger
    classes = "shout cover w" if slide[..2] is '<h1'
    # We give each list item a class of .inner so they build up sequentially
    slide   = slide.replace /<li>/gi, '<li class="inner">'
    # We do two things with <code> elements:
    #  1. Check whether they start with a syntax specifier (e.g. ":::javascript")
    #  2. Set a class for the syntax highlighter (defaults to "coffeescript")
    slide   = slide.replace /<code>(?::::(\w+)\n)?(.*)/gi, (all, syntax, code) ->
      "<code class='#{syntax or "coffeescript"}'>#{code}"
    # At last, we wrap our slide in the required HTML structure
    """
    <div class="slide #{classes}" id="slide-#{idx}">
      <div>
        <section>
          #{slide}
        </section>
      </div>
    </div>
    """

  # Transform our flat document into a structure suitable for our slideshow plugin
  slides = (wrapSlide(slide, idx) for slide, idx in slides).join("\n")

  # Finally, we append our slides (which are still a simple String at this
  # moment) to the HTML document. We do this after any preceding slides, which
  # in our case is the introductory slide.
  $('.slide').last().after slides

  # We want some syntax highlighting, too!
  hljs.initHighlighting()

  # Then we hide all comments that start with our special '#-' syntax,
  # which means that we want to display this comment when editing,
  # but not on the slide
  $('.comment').each (i, el) ->
    $(el).hide() if el.innerHTML[..1] is '#-'

  # Now that the HTML is ready, we can start our slideshow as defined by
  # the Shower.js slideshow plugin
  startSlideshow()


# Create a new Ace editor instance and attach it to
# the HTML element with the id `id`
createEditor = (id) ->
  editor = ace.edit(id)

  # Some settings to make the editor better suited for our purposes
  editor.setTheme("ace/theme/textmate")
  editor.getSession().setTabSize(2)
  editor.getSession().setUseSoftTabs(true)
  editor.renderer.setShowGutter(true)
  editor.renderer.setShowPrintMargin(false)
  editor.setHighlightActiveLine(false)

  # Each time the source code is edited, we want to automatically
  # compile it. To not get too crazy, we use _.debounce to only compile
  # after user input has stopped for a certain amount of time
  editor.getSession().on 'change', _.debounce (-> compileSource(editor)), 200

  # We return our newly created editor instance
  editor


# Show the source code editor and preload the selected text
openEditor = (editor, text, mode) ->
  # Figure out the syntax mode the editor should use.
  # We define these explicitly, because they have to be
  # loaded as <script>s in index.html
  Mode = switch mode
    when "coffeescript" then require("ace/mode/coffee").Mode
    when "javascript"   then require("ace/mode/javascript").Mode
    when "ruby"         then require("ace/mode/ruby").Mode
    else throw "Ace syntax mode '#{mode}' not defined"
  editor.getSession().setMode(new Mode())
  editor.getSession().setValue(text)

  # Show the editor. We do this by moving it into the viewport instead
  # of showing/hiding it, because it won't initialize correctly, if it
  # isn't visible in the beginning.
  $("##{editor.container.id}").parent().css(left: 0)


# Hide the source code editor
hideEditor = (editor) ->
  # Hide the editor by moving it out of the viewport. See openEditor
  # for the reason why.
  $("##{editor.container.id}").parent().css(left: 9999)

  # Make sure an open compiled view will be hidden if the editor is hidden
  toggleCompiledView(editor, true)


# Show or hide the panel with the compiled JavaScript source code
toggleCompiledView = (editor, hide = false) ->
  view = $("##{editor.container.id}").parent().find('.compiled')
  leftMargin  = 400
  rightMargin = 1060
  if hide or parseInt(view.css('left'), 10) is leftMargin
    view.animate left: rightMargin, duration: 0.5
  else
    view.animate left: leftMargin,  duration: 0.5


# Set up the compilation function, to run when you stop typing.
compileSource = (editor) ->
  # Get the current contents of the editor
  source = editor.getSession().getValue()

  # Create a logBuffer to display multiple lines, if more than
  # one thing has been logged
  logBuffer = []

  # Store a reference to the editor container
  $container = $("##{editor.container.id}").parent()

  # Where we put logged data
  $out = $container.find('.output')

  # Define our own log method for use in the examples. It's very
  # short so it can be easily typed, however it can be confused
  # with Math.log...
  window.log = (args...) ->
    # Put each logged object through the JSON stringifier to make
    # sure Objects and Arrays are displayed in a nice way
    args = (JSON.stringify(arg) for arg in args)

    # Add the args to the logBuffer
    logBuffer.push args.join ', '

    # Remove old entries from the logBuffer, if there are too many
    logBuffer.shift() if logBuffer.length > 5

  # Write out the logBuffer to HTML
  flushLog = ->
    # Format each line in the logBuffer for display
    lines = ("→ #{line}" for line in logBuffer)
    $out.html lines.join("<br>")

  # Try compiling the supplied CoffeeScript source code
  try
    # Use the bare flag so CoffeeScript doesn't wrap our output
    # using the JS module pattern
    compiledJS = CoffeeScript.compile source, bare: on

    # Replace multiple linebreaks with one to not waste vertical space
    compiledJS = compiledJS.replace /\n+/g, "\n"

    # Run the source code
    CoffeeScript.eval source

    # If we get here without errors, we clear the log output
    # and remove the error class, if any
    $out.html('').removeClass('error')
    flushLog()

    # Create a new <pre> element instead of using innerHTML, because
    # it would otherwise not apply wrapping correctly
    $pre = $('<pre></pre>')

    # Output the compiled soure to the source view
    $container.find('.compiled').html $pre.html("<code class='javascript'>#{compiledJS}</code>")

    # Finally, highlight the source code
    hljs.highlightBlock($pre.find('code').get(0))

  # If there are errors, display them in the log and mark the log
  # output as having errors
  catch error
    $out.addClass('error')
    log error.message
    flushLog()


# Start the application as soon as the DOM is ready
$ ->
  # Load the slides data and prepare the slides after it's loaded
  $.ajax 'data/slides.md', success: prepareSlides, dataType: 'text'

  # Create a new source code editor instance
  coffeeEditor = createEditor('coffee-editor')

  # Define startX and startY to check mouse interaction
  startX = null
  startY = null

  # Handle clicks on <code> elements. Open the source code
  # editor only when the mouse has not moved (e.g. to highlight
  # or select some text)
  $(document).delegate 'code', 'mousedown', (evt) ->
    # Define the mouse's start point on mousedown
    [startX, startY] = [evt.pageX, evt.pageY]

  # If the mouse hasn't moved too far, open an editor only when
  # the mouse hasn't moved too far
  $(document).delegate 'code', 'mouseup', (evt) ->
    [moveX,  moveY]  = [startX - evt.pageX, startY - evt.pageY]
    [startX, startY] = [null, null]
    if Math.abs(moveX) < 5 and Math.abs(moveY) < 5
      $el = $(evt.target).closest('code')
      openEditor coffeeEditor, $el.text(), $el.attr('class')

  # Close the source code editor
  $(document).delegate '.close',           'click', -> hideEditor(coffeeEditor)

  # Show or hide the compiled Javascript source in the editor
  $(document).delegate '.toggle-compiled', 'click', -> toggleCompiledView(coffeeEditor)
