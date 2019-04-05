$(document).on('turbolinks:load', function () {
  $('#terms_names').select2({
    tags: true,
    tokenSeparators: [',', ' ']
  });
  $('#published_at').datetimepicker({
    sideBySide: true,
    icons: {
      up: "fa fa-chevron-circle-up",
      down: "fa fa-chevron-circle-down",
      next: 'fa fa-chevron-circle-right',
      previous: 'fa fa-chevron-circle-left'
    },
    format: 'DD/MM/YYYY HH:mm',
    autoclose: true
  })

  $(".owl-carousel").owlCarousel({
    items: 2,
    nav: true,
    navText: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"]
  });
  $("#post_post_type").select2({
    theme: "bootstrap",
    width: '100%'
  });
  $("#post_visibility").select2({
    theme: "bootstrap",
    placeholder: "Elegir  visibilidad",
    width: '100%'
  });
  $("#post_permission").select2({
    theme: "bootstrap",
    placeholder: "Elegir permiso",
    width: '100%'
  });
  $("#post_status").select2({
    theme: "bootstrap",
    placeholder: "Elegir estado",
    width: '100%'
  });
  $('#tag_post').select2({
    tags: false,
    tokenSeparators: [],
    placeholder: "Seleccionar Tags"
  });
  $('#post_format').select2({
    theme: "bootstrap",
    placeholder: "Elegir formato",
    width: '100%'
  });
  $('#select_all').change(function () {
    var checkboxes = $('.categories input[type="checkbox"]');
    checkboxes.prop('checked', $(this).is(':checked'));
  });

});