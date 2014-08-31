(function() {
  var $, clearExpansion, normalizeContent, onRowClick, replaceContent, sumColspans;

  $ = jQuery;

  sumColspans = function($els) {
    var el, sum, _i, _len, _ref;
    sum = 0;
    for (_i = 0, _len = $els.length; _i < _len; _i++) {
      el = $els[_i];
      sum += +((_ref = $(el).attr('colspan')) != null ? _ref : 1);
    }
    return sum;
  };

  clearExpansion = function($table) {
    return $table.find('tr').removeClass('expanded').filter('.expanded-content').remove();
  };

  normalizeContent = function($row, content) {
    var $content, colspan;
    $content = content instanceof $ ? content : $($.parseHTML(content));
    if ($content.is('tr')) {
      return $content;
    }
    colspan = sumColspans($row.children());
    return $('<tr>').append($('<td>').attr('colspan', colspan).append($content));
  };

  replaceContent = function($table, $row, content) {
    var $normalizedContent;
    clearExpansion($table);
    $normalizedContent = normalizeContent($row, content);
    $normalizedContent.addClass('expanded-content');
    return $row.addClass('expanded').after($normalizedContent);
  };

  onRowClick = function($table, callback, event) {
    var $row;
    $row = $(event.currentTarget);
    if ($row.is('.expanded')) {
      return clearExpansion($table);
    } else {
      return callback($row, replaceContent.bind(null, $table, $row));
    }
  };

  $.fn.extend({
    expandableRow: function(callback) {
      return this.each((function(_this) {
        return function(i, table) {
          var $table;
          $table = $(table);
          return $table.on('click', 'tbody tr', onRowClick.bind(null, $table, callback));
        };
      })(this));
    }
  });

}).call(this);
