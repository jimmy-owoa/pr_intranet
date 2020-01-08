$(document).on("turbolinks:load", function() {
  $("#terms_names").select2({
    tags: true,
    tokenSeparators: [",", " "]
  });
  $("#post_profile_id").select2({
    tags: false,
    placeholder: "Seleccionar Perfil",
    width: "100%"
  });

  $("#gallery_id").select2({
    tags: false,
    placeholder: "Seleccionar Galería",
    width: "100%",
    allowClear: true
  });

  $('#published_at').on('mousedown',function(event){ event.preventDefault(); })

  $("#published_at").datetimepicker({
    icons: { 
      time: 'fas fa-clock',
      date: 'fas fa-calendar',
      up: 'fas fa-arrow-up',
      down: 'fas fa-arrow-down',
      previous: 'fas fa-arrow-circle-left',
      next: 'fas fa-arrow-circle-right',
      today: 'far fa-calendar-check-o',
      clear: 'fas fa-trash',
      close: 'fas fa-times' 
    },
      format: "DD/MM/YYYY HH:mm",
      buttons: {showClose: true },
      sideBySide: true,
      autoClose: true,
  });


  $(".owl-carousel").owlCarousel({
    items: 2,
    nav: true,
    navText: [
      "<i class='fa fa-chevron-left'></i>",
      "<i class='fa fa-chevron-right'></i>"
    ]
  });
  $("#post_post_type").select2({
    theme: "bootstrap",
    width: "100%"
  });
  $("#post_visibility").select2({
    theme: "bootstrap",
    placeholder: "Elegir  visibilidad",
    width: "100%"
  });
  $("#post_permission").select2({
    theme: "bootstrap",
    placeholder: "Elegir permiso",
    width: "100%"
  });
  $("#post_status").select2({
    theme: "bootstrap",
    placeholder: "Elegir estado",
    width: "100%"
  });
  $("#tag_post").select2({
    tags: false,
    tokenSeparators: [],
    placeholder: "Seleccionar Etiqueta"
  });
  $("#post_format").select2({
    theme: "bootstrap",
    placeholder: "Elegir formato",
    width: "100%"
  });
  $("#select_all").change(function() {
    var checkboxes = $('.categories input[type="checkbox"]');
    checkboxes.prop("checked", $(this).is(":checked"));
  });

  // Permite mostrar campo para subida de video sólo si la publicación es de tipo Video.
  let post_type = document.getElementById('post_post_type');
  let div_video = document.getElementById('post_input_video');
  let div_gallery = document.getElementById('post_input_gallery');
  if (div_video) {
    if (post_type.value != "Video") {
      div_video.style.display = "none";  
    } else {
      div_video.style.display = "show";
      div_gallery.style.display = "none";  
    }
  }
  if (post_type) {
    post_type.onchange = function (event) {
      if (post_type.value == "Video") {
        div_video.style.display = "block";
        div_gallery.style.display = "none";
      } else {
        div_video.style.display = "none";
        div_gallery.style.display = "block";
      }
    }
  }
});
