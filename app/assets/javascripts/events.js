$(function() {
  $('.live-loader li > a').click(function() {
    var loader = $(this).closest('.live-loader');
    loader.find('.active').removeClass('active');
    $(this).parent('li').addClass('active');

    var path = $(this).attr('href');
    var target = $(loader.attr('data-target'));
    var query = JSON.parse(loader.attr('data-query'));
    live_load(path+'.ajax', query, target);
    return false;
  });

  $('.live-load').each(function() {
    var live = $(this);
    var path = live.attr('data-path');
    var query = JSON.parse(live.attr('data-query'));
    live_load(path, query, live);
  });

  $('#live-search').typeahead({
    minLength: 2,
    items: 10,
    source: function(query, process) {
      var params = {q: query, limit: 10};
      $.get('/search/quick.json', params, function(results) {
        var matches = [];

        for ( var i=0; i<results.events.length; i++) {
          var event = results.events[i];
          var html = '<span>' + event.name + '</span><br />' +
                     '<small class="muted">' + event.venue + ' (' + event.city + ') | ' + event.next_date + '</small>' +
                     '<span class="link hide">' + event.link + '</span>';
          matches.push(html);
        }

        for ( var i=0; i<results.specials.length; i++) {
          var special = results.specials[i];
          var html = '<span>' + special.venue + '</span><br />' +
                     '<small class="muted">' + special.days.join(', ') + '</small>' +
                     '<span class="link hide">' + special.link + '</span>';
          matches.push(html);
        }

        process(matches);
      });
    },
    matcher: function(item) {
      return true; // Always true because the matching is done server side
    },
    highlighter: function(item) {
      return item; // Don't highlight it because there's html
    },
/*
    sorter: function(items) {
      return items; // Also done server side
    },
*/
    updater: function(item) {
      $(item).each(function() {
        var it = $(this);
        if ( it.hasClass('link') ) window.location = it.html();
      });
      return '';
    }
  });

  var tag_list = $(".tag_list");
  if ( tag_list.size() ) {
    var event_tags = tag_list.val().split(/,\s?/);
    tag_list.val('');
    tag_list.tagsManager({
      prefilled: event_tags,
      typeahead: true,
      typeaheadSource: function(query, process) {
        $.get('/tags.json', {q: query}, function(data) { process(data) });
      },
      hiddenTagListName: tag_list.attr('data-hidden-field-name')
    });

    tag_list.blur(function() {
      if ( this.value ) tag_list.tagsManager('pushTag', this.value);
    });
  }

  // Enable timepicker
  $('.timepicker').timepicker();
});

function live_load(path, query, target) {
  target.html('<img src="/assets/loading.gif" /> <span class="muted"><em>Loading events...</em></span>');
  $.get(path, query, function(html) { target.html(html) });
}
