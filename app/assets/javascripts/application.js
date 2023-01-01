// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require jquery.purr
//= require best_in_place
//= require activestorage
//= require select2
//= require nicescroll
//= require turbolinks
//= require popper
//= require bootstrap-sprockets
//= require toastr
//= require moment
//= require data-confirm-modal
//= require tempusdominus-bootstrap-4.js
//= require cocoon
//= require vendors
//= require tinymce
//= require admin/admin
//= require admin/profiles
//= require admin/helpcenter_questions
//= require admin/helpcenter_categories
//= require admin/helpcenter_tickets
//= require admin/expense_report_inbox
//= require admin/expense_report_requests
//= require admin/expense_report_categories
//= require admin/users_datatable
//= require owl.carousel
//= require clipboard
//= require jquery.minicolors
//= require jquery.minicolors.simple_form
//= require_self
//= require admin/helpcenter_tickets_inbox

dataConfirmModal.setDefaults({
  title: "¿Esta segura(o) que desea eliminar este elemento?",
  commit: "Aceptar",
  cancel: "Cancelar"
});

// Valida que el archivo subido sea de tipo imagen
function validateImage(fileFieldId) {
  const imageFile = document.getElementById(`${fileFieldId}`);

  if (imageFile) {
    let imageType = imageFile.files[0].type; 
    if (imageType === "image/jpeg" || imageType == "image/png" ) {
      imageFile.value;
    } else {
      alert("Archivo no válido. El archivo debe ser de tipo imagen (JPEG o PNG)");
      imageFile.value = "";
    }
  }
}