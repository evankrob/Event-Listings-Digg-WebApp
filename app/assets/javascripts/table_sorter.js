// Presumes a table like
// <table>
//   <thead>...
//   <tbody>...
//  ...
// 
// args:
//   table id
//   array of 0-indexed columns to sort
function TableSorter() {
  this.table = document.getElementById(arguments[0])
  this.tbody = this.table.getElementsByTagName('tbody')[0]
  this.column_indecies = arguments[1]
  this.num_columns = this.column_indecies.length
  this.headers = this.table.getElementsByTagName('thead')[0].getElementsByTagName('th')
  this.num_total_columns = this.headers.length

  // Array of directions to sort. Indecies are columns. true is asc, false is desc
  this.directions = []
  for ( var i=0; i<this.num_columns; i++ ) { this.directions[i] = false }

  // Hash of rows (key is row uid)
  this.rows = null
  this.num_rows = null
  // Array of row positions (index is row uid, value is position)
  this.positions = null

  this.pull()
  this.build_cache()

  // Bind headers to sort
  var sorter = this
  for ( var i=0; i<this.num_total_columns; i++ ) {
    for ( var ii=0; ii<this.num_columns; ii++ ) {
      if ( this.column_indecies[ii] == i ) {
        this.headers[i].className += this.headers[i].className ? ' sortable' : 'sortable'
        this.headers[i].setAttribute('data-sort-index', i)
        this.headers[i].onclick = function() { sorter.flip(this); sorter.sort(this); sorter.push() }
      }
    }
  }
}

// Sort the cache data
TableSorter.prototype.sort = function(header) {
  var index = parseInt(header.getAttribute('data-sort-index'))
  for ( var i=0; i<this.num_total_columns; i++ ) {
    this.headers[i].className = this.headers[i].className.replace(' sorted asc', '')
    this.headers[i].className = this.headers[i].className.replace(' sorted desc', '')
    if ( i == index ) {
      this.headers[i].className += this.directions[index] ? ' sorted asc' : ' sorted desc'
    }
  }
  // XXX Naught naughty global
  tmp_table_sorter_sort_column_index = index + 1 // +1 because el 0 is the row's uid
  this.cache.sort(this.directions[index] ? sort_column_asc : sort_column_desc)
}

// Apply the cache's new sort order to the DOM
TableSorter.prototype.push = function() {
  for ( var i=0; i<this.num_rows-1; i++ ) {
    var uid = this.cache[i][0]
    var next_uid = this.cache[i+1][0]
    // Skip it if it's already there
    //if ( i != this.positions[uid] ) {
      this.tbody.insertBefore(this.rows[uid], this.tbody.getElementsByTagName('tr')[i])
      this.positions[uid] = i
    //}
  }
}

// Toggle and record which direction this columns is sorting
TableSorter.prototype.flip = function(header) {
  var index = parseInt(header.getAttribute('data-sort-index'))
  this.directions[index] = !this.directions[index]
}

// Pull table rows into a var
TableSorter.prototype.pull = function() {
  this.rows = {}
  var tmp_rows = this.tbody.getElementsByTagName('tr')
  this.num_rows = tmp_rows.length
  this.positions = []
  for ( var i=0; i<this.num_rows; i++ ) {
    this.rows[i] = tmp_rows[i]
    this.positions[i] = i
  }
}

// Build a cache of sortable values
TableSorter.prototype.build_cache = function() {
  var num_regexp = /^\d+(\.\d+)?$/
  // Populate cache of values to sort by
  this.cache = new Array()
  for ( var i=0; i<this.num_rows; i++ ) {
    this.cache[i] = [i]
    // Chache the values of the rows that are sorted
    var cells = this.rows[i].getElementsByTagName('td')
    for ( var c=0; c<this.num_total_columns; c++ ) {
      var in_array = false
      for ( var ii=0; ii<this.num_columns; ii++ ) {
        if ( this.column_indecies[ii] == c ) { in_array = true }
      }
      if ( in_array ) {
        var cell = cells[c]
        this.cache[i][c+1] = cell.getAttribute('data-value') ? cell.getAttribute('data-value') : cell.textContent || cell.innerText || '' // textContent is correct
        if ( num_regexp.test(this.cache[i][c+1]) ) this.cache[i][c+1] = parseFloat(this.cache[i][c+1]) // Convert to number if neccessary
        //alert('Column ' + c + ' in row ' + i + ' = ' + this.cache[i][c+1])
      } else {
        this.cache[i][c+1] = null
      }
    }
  }
}

// The first element in each array is a unique row id - we don't care about it here
function sort_column_asc(a, b) {
  //alert('Compare ' + a[tmp_table_sorter_sort_column_index] + ' and ' +b[tmp_table_sorter_sort_column_index])
  if ( a[tmp_table_sorter_sort_column_index] == b[tmp_table_sorter_sort_column_index] ) {
    return 0
  } else if ( a[tmp_table_sorter_sort_column_index] > b[tmp_table_sorter_sort_column_index] ) {
    return 1
  } else {
    return -1
  }
}

function sort_column_desc(a, b) {
  //alert('Compare ' + a[tmp_table_sorter_sort_column_index] + ' and ' +b[tmp_table_sorter_sort_column_index])
  if ( a[tmp_table_sorter_sort_column_index] == b[tmp_table_sorter_sort_column_index] ) {
    return 0
  } else if ( a[tmp_table_sorter_sort_column_index] > b[tmp_table_sorter_sort_column_index] ) {
    return -1
  } else {
    return 1
  }
}

