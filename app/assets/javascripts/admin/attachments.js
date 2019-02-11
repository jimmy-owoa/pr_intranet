$(document).on('turbolinks:load', function () {
  $('.image-picker').imagepicker();

  $('#attachment_attachment').change(
    function () {
      if ($(this).val()) {
        $('input:submit').attr('disabled', false);
      }
    });

});