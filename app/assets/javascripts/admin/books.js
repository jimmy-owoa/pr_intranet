$(document).on('turbolinks:load', function () {
    $("#book_author_id").select2({
      tags: true,
      placeholder: "Seleccionar Autor",
      width: "100%",
      allowClear: true
    });
  
    $("#book_editorial_id").select2({
      tags: true,
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

    // Colocar atributo "required = true" en campos de select2
    let select_author = document.getElementById("book_author_id");
    let select_editorial = document.getElementById("book_editorial_id");
    let select_category = document.getElementById("book_category_book_id");
    if (select_author && select_editorial && select_category) {
      select_author.required = true;
      select_editorial.required = true;
      select_category.required = true;
    }
  });