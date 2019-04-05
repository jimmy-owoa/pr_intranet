$(document).on("turbolinks:load", function() {
  $("#benefit_groups").select2({
    tags: false,
    tokenSeparators: [",", " "]
  });
});
