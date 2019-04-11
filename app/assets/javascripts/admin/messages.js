$(document).on('turbolinks:load', function () {
  $('#excluding_tag').select2({
    tags: false,
    tokenSeparators: [],
    placeholder: "Seleccionar Etiquetas"
  });
  $('#inclusive_tag').select2({
    tags: false,
    tokenSeparators: [],
    placeholder: "Seleccionar Etiquetas"
  });
});