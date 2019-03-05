$(document).on('turbolinks:load', function () {
  $('#term_permission').select2({
    theme: "bootstrap",
    placeholder: "Elegir formato",
    width: '100%'
  });
});