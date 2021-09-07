document.addEventListener('turbolinks:before-cache', function () {
  $('#questions_table').DataTable().destroy();
});

$(document).on("turbolinks:load", function() {
  $('#questions_table').DataTable({
    "language": {
      "lengthMenu": "Mostrar _MENU_ registros por página",
      "zeroRecords": "Nothing found - sorry",
      "info": "Mostrando página _PAGE_ de _PAGES_",
      "infoEmpty": "No records available",
      "infoFiltered": "(filtered from _MAX_ total records)",
      "search": "Buscar",
      "paginate": {
        "previous": "Anterior",
        "next": "Siguiente"
      }
    }
  });

  $("#question_profile_id").select2({
    tags: false,
    placeholder: "Seleccionar Perfil",
    width: "100%"
  });

  $("#category").select2({
    tags: false,
    placeholder: "Seleccionar Categoría",
    width: "100%"
  });

  $("#question_subcategory_id").select2({
    tags: false,
    placeholder: "Seleccionar Subcategoría",
    width: "100%"
  });
});
