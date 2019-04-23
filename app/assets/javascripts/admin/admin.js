$(document).on("turbolinks:load", function() {
  $("#term").on("keyup", function(e) {
    if (e.which == 13) {
      $("#submit_term").click();
    }
  });
});
