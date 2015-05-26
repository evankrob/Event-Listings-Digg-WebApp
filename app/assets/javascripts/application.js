// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  // Enable full table row links
  $(document).on('click', '.row-links tbody tr', function(e) {
    if ( $(e.target).is('a') ) return;
    location.href = $(this).attr("data-href");
    e.stopPropagation();
  });

  // Save cookie that the welcome message was dismissed
  $('.alert-welcome').bind('closed', function() {
    var date = new Date();
    date.setTime(date.getTime() + (60 * 24 * 69 * 60 * 1000)); // 60 days
    var expires = 'expires=' + date.toGMTString();

    var cookie = ['skip_welcome=true', expires];
    document.cookie = cookie.join('; ');
  });
});
