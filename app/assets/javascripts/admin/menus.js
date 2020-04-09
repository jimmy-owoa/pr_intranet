$(document).on('turbolinks:load', function () {
  $("#menu_parent_id").select2({
    theme: "bootstrap",
    width: "100%"
  });
  $("#menu_profile_id").select2({
    theme: "bootstrap",
    width: "100%"
  });
  $("#terms_names").select2({
    tags: true,
    tokenSeparators: [",", " "]
  });
  $("#tag_menu").select2({
    tags: false,
    tokenSeparators: []
  });
});
