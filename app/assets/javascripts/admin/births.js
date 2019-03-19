$(document).on('turbolinks:load', function () {
  $('#check_all_birth').on("click", function () {
    var cbxs = $('.approved input[type="checkbox"]');
    cbxs.prop("checked", !cbxs.prop("checked"));
  });

});