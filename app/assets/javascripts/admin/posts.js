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

  $('#publisehd_at').on('mousedown',function(event){ event.preventDefault(); })

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
      keepOpen: true
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
  var uploader = $("#fileinputuploader");

  uploader
    .fileinput({
      showPreview: true,
      showCaption: false,
      showUpload: false,
      uploadUrl: "/admin/attachments",
      uploadAsync: true,
      allowedFileExtensions: [
        "png",
        "jpg",
        "jpeg",
        "gif",
        "svg",
        "mp4",
        "mov",
        "ogg"
      ],
      msgInvalidFileExtension: "El archivo debe ser una imagen.",
      removeFromPreviewOnError: true,
      language: "es",
      ajaxSettings: {
        method: "POST"
      },
      browseLabel: "Buscar archivos",
      dropZoneTitle: "Arrastrar y Soltar archivos aquí",
      removeLabel: "Eliminar archivos",
      previewTemplates: {},
      layoutTemplates: {
        actions: ""
      }
    })
    .on("filebatchselected", function(event, files) {
      uploader.fileinput("upload");
    });

  uploader.on("fileerror", function(event, data, msg) {
    console.log(msg);
  });

  uploader.on("fileuploaded", function(event, data, previewId, index) {
    console.log(data.response);
    $("<input>")
      .attr({
        type: "hidden",
        id: "attachment_" + data.response.attachment_id,
        name: "attachments_attributes[" + data.response.attachment_id + "][id]",
        value: data.response.attachment_id
      })
      .appendTo("form");
  });
});
