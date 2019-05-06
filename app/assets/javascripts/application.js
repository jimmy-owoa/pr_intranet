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
//= require jquery.minicolors
//= require jquery.minicolors.simple_form
//= require ahoy
//= require_self

alertify.defaults = {
  // language resources
  glossary: {
    // dialogs default title
    title: "AlertifyJS",
    // ok button text
    ok: "Si",
    // cancel button text
    cancel: "Cancelar"
  },

  // theme settings
  theme: {
    // class name attached to prompt dialog input textbox.
    input: "ajs-input",
    // class name attached to ok button
    ok: "ajs-ok",
    // class name attached to cancel button
    cancel: "ajs-cancel"
  }
};
