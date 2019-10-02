$(document).on("turbolinks:load", function() {
  $("#message_profile_id").select2({
    tags: false,
    placeholder: "Seleccionar Perfil",
    width: "100%"
  });
});
