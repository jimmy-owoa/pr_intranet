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
//= require activestorage
//= require select2
//= require nicescroll
//= require turbolinks
//= require popper
//= require bootstrap-sprockets
//= require toastr
//= require moment
//= require tempusdominus-bootstrap-4.js
//= require cocoon
//= require vendors
//= require tinymce
//= require admin/admin
//= require admin/posts
//= require admin/attachments
//= require admin/users
//= require admin/births
//= require admin/gallery
//= require admin/products
//= require admin/menus
//= require admin/sections
//= require admin/messages
//= require admin/terms
//= require admin/surveys
//= require admin/benefit_groups
//= require owl.carousel
//= require alertify
//= require alertify/confirm-ujs
//= require clipboard
//= require jquery.minicolors
//= require jquery.minicolors.simple_form
//= require ahoy
//= require_self

// #clipboard
$(document).ready(function() {
  $(".clipboard-btn").tooltip({
    trigger: "click",
    placement: "bottom"
  });

  function setTooltip(btn, message) {
    $(btn)
      .tooltip("show")
      .attr("data-original-title", message)
      .tooltip("show");
  }

  function hideTooltip(btn) {
    setTimeout(function() {
      $(btn).tooltip("hide");
    }, 1000);
  }

  var clipboard = new Clipboard(".clipboard-btn");

  clipboard.on("success", function(e) {
    setTooltip(e.trigger, "¡Copiado!");
    hideTooltip(e.trigger);
  });

  clipboard.on("error", function(e) {
    setTooltip(e.trigger, "Failed!");
    hideTooltip(e.trigger);
  });
});
