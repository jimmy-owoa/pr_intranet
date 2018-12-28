$(document).on('turbolinks:load', function () {
  $('.for_select').select2({
    tags: true,
    tokenSeparators: [',', ' '],
    placeholder: "Crear Tags"
  });
  $('#birthday').datetimepicker({
    format: 'DD-MM-YYYY'
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
  $(".card").hover(
    function () {
      $(this).addClass('shadow-lg').css('cursor', 'pointer');
    },
    function () {
      $(this).removeClass('shadow-lg');
    }
  );

});