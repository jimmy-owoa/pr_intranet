$(document).on('turbolinks:load', function () {
  $('#terms_names').select2({
    tags: true,
    tokenSeparators: [',', ' ']
  });
  $('#published_at').datetimepicker({
    todayHighlight: true,
    format: 'DD-MM-YYYY HH:MM'
  });
  $(".owl-carousel").owlCarousel({
    items: 2,
    nav: true,
    navText: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"]
  });
  $("#post_post_type").select2({
    theme: "bootstrap",
    width: '100%'
  });
});