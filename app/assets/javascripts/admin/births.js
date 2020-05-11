$(document).on("turbolinks:load", function() {
  $("#check_all_birth").on("click", function() {
    var cbxs = $('.approved input[type="checkbox"]');
    cbxs.prop("checked", !cbxs.prop("checked"));
  });

  $(".approved_birth").on("change", function(e) {
    var id;
    id = $(this).data("id");
    return $.ajax({
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
      },
      url: "/admin/births/" + id + ".json",
      type: "PUT",
      data: {
        approved: $(this).is(":checked")
      }
    }).done(function(e) {
      alert("Estado del nacimiento cambiado");
    });
  });

  $(".approved_birth_attachment").on("change", function(e) {
    var id;
    id = $(this).data("id");
    image_id = $(this).data("image");
    return $.ajax({
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
      },
      url: "/admin/births/" + id + ".json",
      type: "PUT",
      data: {
        image_id: image_id,
        approved_image: $(this).is(":checked")
      }
    }).done(function(e) {
      alert("Estado de la imagen cambiada");
    });
  });

  $(".close").on("click", function() {
    $(".modal").modal("hide");
  });

  $('#btnClose').click( function () {
    $('#modalShow').modal('hide')
  });
});
