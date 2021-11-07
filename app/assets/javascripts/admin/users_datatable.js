$(document).on("turbolinks:load", function() {
  $('#users_table').DataTable({
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
      },
    },
    initComplete: function() {
      var api = this.api();
      var searchWait = 0;
      var searchWaitInterval;
      // Selecciona el input de búsqueda
      $(".dataTables_filter input")
      .unbind() // Desvincula eventos por defecto del buscador
      .bind("input", function(e) { // enlazar el comportamiento deseado en el buscador
          var item = $(this);
          searchWait = 0;
          if(!searchWaitInterval) searchWaitInterval = setInterval(function(){
              searchTerm = $(item).val();
              // if(searchTerm.length >= 3 || e.keyCode == 13) {
                  clearInterval(searchWaitInterval);
                  searchWaitInterval = '';
                  // Call the API search function
                  api.search(searchTerm).draw();
                  searchWait = 0;
              // }
              searchWait++;
          },1000);                       
          return;
      });
    },
    processing: true,
    serverSide: true,
    searchDelay: 600,
    draw: 1,
    ajax: {
      url: $('#users_table').data('source'),
    },
    columns: [
      { title: 'Nombre(s)', data: 'name', orderable: false, targets: 'no-sort' },
      { title: 'Apellido(s)', data: 'lastname', orderable: false, targets: 'no-sort' },
      { title: 'Email', data: 'email', orderable: false, targets: 'no-sort' },
      { title: 'Anexo', data: 'annexed', orderable: false, targets: 'no-sort' },
      { title: 'Activo', data: 'active', orderable: false, targets: 'no-sort' },
      { title: 'Acciones', data: 'actions', orderable: false, targets: 'no-sort' },
    ]
  });
});

function user_filter_action() {
  document.getElementById("user_filter").click()
}