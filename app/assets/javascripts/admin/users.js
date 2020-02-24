$(document).on("turbolinks:load", function() {
  $("[rel=tooltip]").tooltip({ placement: "right" });
  $(".for_select").select2({
    tags: true,
    tokenSeparators: [",", " "],
    placeholder: "Seleccionar Etiqueta"
  });
  // ver user_term_ids para agregar tags
  $("#birthday").datetimepicker({
    format: "DD-MM-YYYY",
    maxDateNow: true
  });
  $("#date_entry").datetimepicker({
    format: "DD-MM-YYYY",
    maxDateNow: true
  });
  $("#user_term_ids").select2({
    tags: true,
    tokenSeparators: [",", " "],
    placeholder: "Crear Etiqueta"
  });
  $("#user_parent_id").select2({
    theme: "bootstrap",
    width: "100%"
  });
  $("#user_location_id").select2({
    theme: "bootstrap",
    width: "100%",
    placeholder: "Elegir Ciudad"
  });
  $(".card").hover(
    function() {
      $(this)
        .addClass("shadow-lg")
        .css("cursor", "pointer");
    },
    function() {
      $(this).removeClass("shadow-lg");
    }
  );
  $(".active_user").on("change", function(e) {
    var id;
    id = $(this).data("id");
    return $.ajax({
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
      },
      url: "/admin/users/" + id + ".json",
      type: "PUT",
      data: {
        approved: $(this).is(":checked")
      }
    }).done(function(e) {
      alert("Estado del usuario cambiado");
    });
  });

  $("#user_profile_ids").select2({
    tags: false,
    placeholder: "Seleccionar Perfil",
    width: "100%"
  });


  // Select 2 para seleccionar usuario en Formulario de nacimientos.
  $("#user_id").select2({
    tags: false,
    placeholder: "Seleccionar Usuario",
    width: "100%",
    allowClear: true
  });

  // Validación de select de usuario. Debe ser requerido.
  let select_user_id = document.getElementById("user_id");
  select_user_id ? select_user_id.required = true : '';
});
