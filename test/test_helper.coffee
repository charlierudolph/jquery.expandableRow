jsdom = require 'jsdom'

before (done) ->
  jsdom.env '<body>',
    ['../node_modules/jquery/dist/jquery.js', '../lib/jquery.expandableRow.js']
    (err, @window) =>
      throw err[0].data.error if err?
      @$ = @window.jQuery
      @window.console.log = -> console.log.apply console, arguments
      done()

global.withHtml = (html) ->
  beforeEach ->
    @$('body').off().html(html)
    @$(@window.document).off()
