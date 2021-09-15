document.addEventListener('turbolinks:before-cache', function () {
  $('#categories_table').DataTable().destroy();
});

$(document).on("turbolinks:load", function() {
  $('#categories_table').DataTable({
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

  $("#category_profile_id").select2({
    tags: false,
    placeholder: "Seleccionar Perfil",
    width: "100%"
  });
});
