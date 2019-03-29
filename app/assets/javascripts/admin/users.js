$(document).on('turbolinks:load', function () {
  $('.for_select').select2({
    tags: true,
    tokenSeparators: [',', ' '],
    placeholder: "Seleccionar Tags"
  });
  // ver user_term_ids para agregar tags
  $('#birthday').datetimepicker({
    format: 'DD-MM-YYYY',
    maxDateNow: true
  });
  $('#date_entry').datetimepicker({
    format: 'DD-MM-YYYY',
    maxDateNow: true
  });
  $('#user_term_ids').select2({
    tags: true,
    tokenSeparators: [',', ' '],
    placeholder: "Crear Tags"
  });
  $("#user_parent_id").select2({
    theme: "bootstrap",
    width: '100%'
  });
  $("#user_address").select2({
    theme: "bootstrap",
    width: '100%',
    placeholder: 'Elegir Ciudad'
  });
  $(".card").hover(
    function () {
      $(this).addClass('shadow-lg').css('cursor', 'pointer');
    },
    function () {
      $(this).removeClass('shadow-lg');
    }
  );
});