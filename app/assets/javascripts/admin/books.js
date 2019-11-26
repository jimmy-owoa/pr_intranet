$(document).on('turbolinks:load', function () {
    $("#book_author_id").select2({
      tags: false,
      placeholder: "Seleccionar Perfil",
      width: "100%"
    });
  
    $("#book_editorial_id").select2({
      tags: false,
      placeholder: "Seleccionar Perfil",
      width: "100%"
    });
});