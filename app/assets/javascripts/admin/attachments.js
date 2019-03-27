$(document).on("turbolinks:load", function () {
  // $(".image-picker").imagepicker();

  // $('#attachment_attachment').change(
  //   function () {
  //     if ($(this).val()) {
  //       $('input:submit').attr('disabled', false);
  //     }
  //   }
  // )

  // $('#search_att').on("blur", function () {
  //   $.ajax({
  //     type: "GET",
  //     url: "/admin/searchatt",
  //     data: {
  //       search: $(this).val()
  //     },
  //     success: function (result) {
  //       image_selector.html('');
  //       image_selector.data('picker').sync_picker_with_select();
  //       console.log(result);
  //     }
  //   })
  // })

  var uploader = $("#fileinputuploader");

  uploader
    .fileinput({
      showPreview: true,
      showCaption: false,
      showUpload: false,
      uploadUrl: "/admin/attachments",
      uploadAsync: true,
      allowedFileExtensions: ["png", "jpg", "jpeg", "gif", "svg"],
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
    .on("filebatchselected", function (event, files) {
      uploader.fileinput("upload");
    });

  uploader.on("fileerror", function (event, data, msg) {
    console.log(msg);
  });

  uploader.on("fileuploaded", function (event, data, previewId, index) {
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