$(document).on("turbolinks:load", function () {
  $(".clipboard-btn_survey").tooltip({
    trigger: "click",
    placement: "bottom"
  });

  function addTip(element) {
    var selectedVal = $(element).val();
    var message_selection = $(element).parent().parent().children().last()
    if (selectedVal == "Múltiple") {
      message_selection.html("Selección Múltiple: Permite seleccionar más de una opción. Ej: ¿Qué deportes te gustan? Opciones: Tenis, Basquetbol, Futbol");
      $(element).parent().parent().parent().siblings().removeClass("hidden");
      if($(element).parent().parent().parent().siblings(".nested-fields").length == 0){
        $(element).parent().parent().parent().siblings().last().children("a").click();
      }
    } else if (selectedVal == "Simple") {
      message_selection.html("Seleccion Simple: Radio Button para elegir solamente una opción.");
       if($(element).parent().parent().parent().siblings(".nested-fields").length == 0){
        $(element).parent().parent().parent().siblings().last().children("a").click();
      }
    } else if (selectedVal == "Verdadero o Falso") {
      message_selection.html("Se puede seleccionar Verdadero o Falso.");
      $(element).parent().parent().parent().siblings().addClass("hidden");
    } else if (selectedVal == "Texto") {
      message_selection.html("Campo para ingresar solamente texto.  Ej: ¿En que calle vives? - Alameda.");
      $(element).parent().parent().parent().siblings().addClass("hidden");
    } else if (selectedVal == "Número") {
      message_selection.html("Campo para ingresar solamente número.  Ej: ¿Cuantos años tienes? - 18");
      $(element).parent().parent().parent().siblings().addClass("hidden");
    } else if (selectedVal == "Selección") {
      message_selection.html("Un campo de selección con multiples opciones.");
       if($(element).parent().parent().parent().siblings(".nested-fields").length == 0){
        $(element).parent().parent().parent().siblings().last().children("a").click();
      }
    } else if (selectedVal == "Escala lineal") {
      message_selection.html("Escala lineal es considerada desde 0 a 10");
      $(element).parent().parent().parent().siblings().addClass("hidden");
    }
  }

  function setTooltip(btn, message) {
    $(btn)
      .tooltip("show")
      .attr("data-original-title", message)
      .tooltip("show");
  }

  function hideTooltip(btn) {
    setTimeout(function () {
      $(btn).tooltip("hide");
    }, 1000);
  }

  // Clipboard

  var clipboard = new Clipboard(".clipboard-btn_survey");

  clipboard.on("success", function (e) {
    setTooltip(e.trigger, "Copiado");
    hideTooltip(e.trigger);
  });

  clipboard.on("error", function (e) {
    setTooltip(e.trigger, "error!");
    hideTooltip(e.trigger);
  });

  $("[rel=tooltip]").tooltip({ placement: "right" });

  $.each($(".select-question-type"),function(){
    addTip(this);
  });
  $(".select-question-type").on("change", function () {
    addTip(this);
  });
  $("#questions").on('cocoon:after-insert', function () {
    $(".select-question-type").on("change", function () {
      addTip(this);
    });
  });


  $(document).on({
    keydown: function (e) {
      addOptionOnKeypress(e);
    }
  });

  function addOptionOnKeypress(e) {
    if (e.keyCode == 13 || e.keyCode == 10) {
      e.preventDefault();
      var input_parent = $($(e.target).parents()[4]);
      var add_options = input_parent
        .siblings(".add_option")
        .children(".add_fields")
        .first();
      add_options.trigger("click");

      var inputs = input_parent.next(".nested-fields").find(":input");
      var next_index = inputs.index(this) + 1;
      inputs
        .eq(next_index)
        .focus()
        .attr("placeholder", "Opción");

      var input_parent2 = $($(e.target).parents()[2]);
      var add_options = input_parent2
        .siblings(".add_option")
        .children(".add_fields")
        .first();
      add_options.trigger("click");

      var inputs2 = input_parent2.next(".nested-fields").find(":input");
      var next_index = inputs2.index(this) + 1;
      inputs2
        .eq(next_index)
        .focus()
        .attr("placeholder", "Opción");
    }
  }

  $("#survey_published_at").datetimepicker({
    sideBySide: true,
    icons: {
      up: "fa fa-chevron-circle-up",
      down: "fa fa-chevron-circle-down",
      next: "fa fa-chevron-circle-right",
      previous: "fa fa-chevron-circle-left"
    },
    format: "DD/MM/YYYY HH:mm",
    buttons: {showClose: true },
    autoclose: true
  });

  // script que realiza el cierre de datetimepicker cuando se selecciona un campo exterior
  $(document).on('mouseup touchstart', function (e) {
    var container = $(".bootstrap-datetimepicker-widget");
      if (!container.is(e.target) && container.has(e.target).length === 0) {
        container.hide();
      }
  });
});
