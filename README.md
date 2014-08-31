# jQuery Expandable Row

A simple jquery plugin that allows you to easily setup tables with expandable rows

## Usage

1. Grab the source from the lib directory
2. Include the script in your application after jQuery
3. `$('table').expandableRow(onRowClick)`

#### onRowClick

`onRowClick` should be a function that takes in two arguments.
  + the clicked row (a JQuery object)
  + a function to execute with the expandand content (HTML or a jQuery object)
    - If the expanded content is a table row, it will simply be inserted.
    - Otherwise it will be wrapped in a table cell with a colspan to give it full width and then wrapped in a table row.

```coffeescript
onRowClick = ($row, cb) ->
  cb("Expanded Content for #{$row.data('id')}")
```

Expand can be called multiple times and will replace the content.
Here is an example where we show an expanded loading row and then show the expanded content after it has been loaded via ajax.

```coffeescript
onRowClick = ($row, cb) ->
  cb("<div class="loading"><div>")
  $.ajax "/content/#{$row.data('id')}",
    success: (data) => cb(data)
```

## Contributing

1. Fork the repository
2. Run `npm install`
3. Run the tests with `npm test`

Please do not create pull requests with changes to the lib directory.
These will be updated with each release.
