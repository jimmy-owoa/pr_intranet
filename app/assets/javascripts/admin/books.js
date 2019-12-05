$(document).on('turbolinks:load', function () {
    $("#book_author_id").select2({
      tags: false,
      placeholder: "Seleccionar Autor",
      width: "100%",
      allowClear: true
    });
  
    $("#book_editorial_id").select2({
      tags: false,
      placeholder: "Seleccionar Editorial",
      width: "100%",
      allowClear: true
    });

    $("#book_category_book_id").select2({
      tags: true,
      placeholder: "Seleccionar Categoría",
      width: "100%",
      allowClear: true
    });
});