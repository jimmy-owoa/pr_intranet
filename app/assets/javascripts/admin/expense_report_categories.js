document.addEventListener('turbolinks:before-cache', function () {
  $('#expense_report_categories_table').DataTable().destroy();
});

$(document).on("turbolinks:load", function() {
  $('#expense_report_categories_table').DataTable({
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

});
