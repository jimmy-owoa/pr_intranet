$(document).on('turbolinks:load', function () {
  $('.image-picker').imagepicker();

  $("select.image-picker").imagepicker({
    hide_select: true,
    selected: function (option) {
      var values = this.val();
    }
  });

  $('#gallery_attachment_ids').change(
    function () {
      if ($(this).val()) {
        $('input:submit').attr('disabled', false);
      }
    });

  $("#posts").select2({
    tags: false,
    tokenSeparators: [",", " "]
  });
});