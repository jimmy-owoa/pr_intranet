$(document).on("page:receive", function() {
  tinymce.remove();
  tinymce.init({
    images_upload_url: "/admin/upload",
    automatic_uploads: false
  });
});