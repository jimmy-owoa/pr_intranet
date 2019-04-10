$(document).on('turbolinks:load', function () {
  $('#check_all').on("click", function () {
    var cbxs = $('.approved input[type="checkbox"]');
    cbxs.prop("checked", !cbxs.prop("checked"));
  });

  $(".approved").on("change", function (e) {
    var id;
    id = $(this).data("id");
    return $.ajax({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      url: "/admin/products/" + id + ".json",
      type: 'PUT',
      data: {
        approved: $(this).is(":checked")
      }
    }).done(function (e) {});
  });

  // $('body').on('keyup', '#product_price', function (e) {
  //   var decimal, num, parts, value;
  //   value = $(this).val().toString().replace(/\./g, '');
  //   parts = value.split(',');
  //   decimal = '';
  //   if (parts.length > 1) {
  //     value = parts.slice(0, -1).join('');
  //     decimal = parts[parts.length - 1];
  //   }
  //   num = value.split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g, '$1.');
  //   num = num.split('').reverse().join('').replace(/^[\.]/, '');
  //   if (parts.length > 1) {
  //     num = num + ',' + decimal;
  //   }
  //   return $(this).val(num);
  // });  

});