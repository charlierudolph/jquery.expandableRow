$ = jQuery


sumColspans = ($els) ->
  sum = 0
  sum += +($(el).attr('colspan') ? 1) for el in $els
  sum


clearExpansion = ($table) ->
  $table
    .find('tr').removeClass('expanded')
    .filter('.expanded-content').remove()


normalizeContent = ($row, content) ->
  $content = if content instanceof $ then content else $( $.parseHTML(content) )
  return $content if $content.is('tr')
  colspan = sumColspans($row.children())
  $('<tr>').append $('<td>').attr('colspan', colspan).append($content)


replaceContent = ($table, $row, content) ->
  clearExpansion($table)
  $normalizedContent = normalizeContent($row, content)
  $normalizedContent.addClass('expanded-content')
  $row.addClass('expanded').after($normalizedContent)


onRowClick = ($table, callback, event) ->
  $row = $(event.currentTarget)

  if $row.is('.expanded')
    clearExpansion($table)
  else
    callback($row, replaceContent.bind(null, $table, $row))


$.fn.extend

  expandableRow: (callback) ->
    @each (i, table) =>
      $table = $(table)
      $table.on 'click', 'tbody tr', onRowClick.bind(null, $table, callback)
