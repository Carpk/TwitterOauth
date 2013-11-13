$(document).ready(function() {
  $('.tweetform').on('submit', function(event) {
    event.preventDefault();
    form = $(this)
    var data = form.serialize();
    var postURL = form.attr("action")
    console.log(data)
    $.post(postURL, data, function(response){
      var url = "/status/" + response;
      $.get(url);
    });
  })
});


