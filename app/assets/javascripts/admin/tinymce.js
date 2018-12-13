$(document).on('turbolinks:load', function () {
  if (typeof tinyMCE != 'undefined') {
    tinyMCE.init({
      selector: "textarea.tinymce",
      height: 5000,
      toolbar: [
        "styleselect | bold italic | alignleft aligncenter alignright alignjustify",
        "bullist numlist outdent indent | link image | code | codesample"
      ],
      plugins: "image,link,code,codesample,autoresize,imagetools,media,table,insertdatetime,charmap,print,preview,anchor,searchreplace,visualblocks,fullscreen"
    });
  } else {
    setTimeout(arguments.callee, 50);
  }
});
