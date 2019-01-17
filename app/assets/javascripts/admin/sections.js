$(document).on('turbolinks:load', function () {
  $("#section_url").select2({
    theme: "bootstrap",
    width: '100%',
    minimumInputLength: 1,
    formatInputTooShort: "",
    language: {
      inputTooShort: function () {
        return 'Ingresar al menos 1 caracter';
      }
    }
  });
})