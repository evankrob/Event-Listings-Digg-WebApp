//= require active_admin/base
$(function() {
  $('<li><label>&nbsp;</label><button id="show_preview">Preview</button> <a href="http://warpedvisions.org/projects/textile-cheat-sheet/" target="_blank">Formatting help</a></li>').insertAfter('#event_description_input');
  $('<div id="preview"></div>').insertAfter('fieldset.inputs');

  $('#show_preview').click(function() {
    $('#preview').html('<em>Loading...</em>');
    $.post('/textile/preview', {text: $('#event_description').val()}, function(data) {
      $('#preview').html('<h3>Description Preview</h3>' + data);
    });
    return false;
  });
});
