$(document).on("turbolinks:load", function() {
  $(".image-picker").imagepicker();
  $("#excluding_tags").select2({
    tags: false,
    tokenSeparators: [",", " "]
  });
  $("#inclusive_tags").select2({
    tags: false,
    tokenSeparators: [",", " "]
  });
  $("#categories").select2({
    tags: false,
    tokenSeparators: [",", " "]
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
