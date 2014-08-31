require './test_helper'

html = '''
<table>
  <thead>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  </thead>

  <tbody>
    <tr data-row="1">
      <td></td>
      <td></td>
      <td></td>
    </tr>

    <tr data-row="2">
      <td></td>
      <td colspan="2"></td>
    </tr>

    <tr data-row="3">
      <td></td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
'''

describe 'jquery expandable row', ->
  withHtml html

  beforeEach ->
    @$table = @$('table')

  describe 'inserting a div', ->
    beforeEach ->
      @$table.expandableRow ($row, cb) -> cb("<div>Expanded row #{$row.data('row')}</div>")

    context 'clicking on a row', ->
      beforeEach ->
        @$table.find('[data-row=1]').click()

      it 'adds the expanded class to the row', ->
        expect(@$table.find('tr[data-row=1]').hasClass('expanded')).to.be.true

      it 'inserts an expanded row', ->
        expect(@$table.find('tbody tr')).to.have.lengthOf 4
        expect(@$table.find('tr.expanded-content')).to.have.lengthOf 1

      it 'inserts the expanded row after the clicked row', ->
        expect(@$table.find('tr.expanded-content')[0]).to.eql @$table.find('tr[data-row=1]').next()[0]

      it 'wraps the content in a table cell with the proper colspan', ->
        expect(@$table.find('tr.expanded-content').html()).to.eql '<td colspan="3"><div>Expanded row 1</div></td>'


      context 'clicking on the same row', ->
        beforeEach ->
          @$table.find('tr[data-row=1]').click()

        it 'removes the expanded class from the row', ->
          expect(@$table.find('tr[data-row=1]').hasClass('expanded')).to.be.false

        it 'removes the expanded content row', ->
          expect(@$table.find('tbody tr')).to.have.lengthOf 3
          expect(@$table.find('tr.expanded-content')).to.have.lengthOf 0


      context 'clicking on a different row', ->
        beforeEach ->
          @$table.find('tr[data-row=2]').click()

        it 'moves the expanded class', ->
          expect(@$table.find('tr[data-row=1]').hasClass('expanded')).to.be.false
          expect(@$table.find('tr[data-row=2]').hasClass('expanded')).to.be.true

        it 'adds the new expanded content and removes the old expanded content', ->
          expect(@$table.find('tbody tr')).to.have.lengthOf 4
          expect(@$table.find('tr.expanded-content')).to.have.lengthOf 1
          expect(@$table.find('tr.expanded-content')[0]).to.eql @$table.find('tr[data-row=2]').next()[0]
          expect(@$table.find('tr.expanded-content').html()).to.eql '<td colspan="3"><div>Expanded row 2</div></td>'


    context 'clicking on a header row', ->
      beforeEach ->
        @$table.find('thead tr').click()

      it 'does nothing', ->
        expect(@$table.find('thead tr')).to.have.lengthOf 1


  describe 'multiple inserts', ->
    beforeEach ->
      @$table.expandableRow ($row, cb) ->
        cb('<div>Temp</div>')
        cb('<div>Final</div>')

    context 'clicking on a row', ->
      beforeEach ->
        @$table.find('tr[data-row=1]').click()

      it 'later calls replace earlier calls', ->
        expect(@$table.find('tr.expanded-content').html()).to.contain '<div>Final</div>'


  describe 'inserting text', ->
    beforeEach ->
      @$table.expandableRow ($row, cb) -> cb("Expanded row #{$row.data('row')}")

    context 'on row click', ->
      beforeEach ->
        @$table.find('tr[data-row=1]').click()

      it 'wraps the content in a table cell with the proper colspan', ->
        expect(@$table.find('tr.expanded-content').html()).to.eql '<td colspan="3">Expanded row 1</td>'


  describe 'inserting a jQuery object', ->
    beforeEach ->
      @$table.expandableRow ($row, cb) -> cb(@$("<div>Expanded row #{$row.data('row')}</div>"))

    context 'on row click', ->
      beforeEach ->
        @$table.find('tr[data-row=1]').click()

      it 'wraps the content in a table cell with the proper colspan', ->
        expect(@$table.find('tr.expanded-content').html()).to.eql '<td colspan="3"><div>Expanded row 1</div></td>'


  describe 'inserting a table row', ->
    beforeEach ->
      @$table.expandableRow ($row, cb) ->
        num = $row.data('row')
        cb("<tr><td>Col1 row #{num}</td><td>Col2 row #{num}</td><td>Col3 row #{num}</td></tr>")

    context 'on row click', ->
      beforeEach ->
        @$table.find('tr[data-row=1]').click()

      it 'inserts the content as is', ->
        expect(@$table.find('tr.expanded-content').html()).to.eql '<td>Col1 row 1</td><td>Col2 row 1</td><td>Col3 row 1</td>'
