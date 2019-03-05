$(document).on('turbolinks:load', function () {
  $('#exclusive_tag').select2({
    tags: false,
    tokenSeparators: [],
    placeholder: "Seleccionar Tags"
  });
  $('#inclusive_tag').select2({
    tags: false,
    tokenSeparators: [],
    placeholder: "Seleccionar Tags"
  });
});