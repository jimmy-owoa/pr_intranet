$(document).on("turbolinks:load", function() {
  tinymce.remove();
  tinymce.init({
    images_upload_url: "/admin/upload",
    automatic_uploads: false
  });
});