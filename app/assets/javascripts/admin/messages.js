$(document).on("turbolinks:load", function() {
  $("#message_profile_id").select2({
    tags: false,
    placeholder: "Seleccionar Perfil",
    width: "100%"
  });
  
  $("#message_message_type").change(function(){
    $("#message_profile_id").prop('disabled', $(this).val() !== 'general');
  });
});
