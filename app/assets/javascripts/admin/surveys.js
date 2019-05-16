$(document).ready(function() {
  $("[rel=tooltip]").tooltip({ placement: "right" });
  $(".select-question-type").on("change", function() {
    var selectedVal = $(this).val();
    if (selectedVal == "Múltiple") {
      document.getElementById("message_selection").innerHTML =
        "Selección Múltiple: Permite seleccionar más de una opción. Ej: ¿Qué deportes te gustan? Opciones: Tenis, Basquetbol, Futbol";
    } else if (selectedVal == "Simple") {
      document.getElementById("message_selection").innerHTML =
        "Seleccion Simple: Radio Button para elegir solamente una opción.";
    } else if (selectedVal == "Verdadero o Falso") {
      document.getElementById("message_selection").innerHTML =
        "Se puede seleccionar Verdadero o Falso.";
    } else if (selectedVal == "Texto") {
      document.getElementById("message_selection").innerHTML =
        "Campo para ingresar solamente texto.  Ej: ¿En que calle vives? - Alameda.";
    } else if (selectedVal == "Número") {
      document.getElementById("message_selection").innerHTML =
        "Campo para ingresar solamente número.  Ej: ¿Cuantos años tienes? - 18";
    } else if (selectedVal == "Selección") {
      document.getElementById("message_selection").innerHTML =
        "Un campo de selección con multiples opciones.";
    } else if (selectedVal == "Escala lineal") {
      document.getElementById("message_selection").innerHTML =
        "Escala lineal es considerada desde 0 a 10";
    }
  });

  $(document).on({
    keydown: function(e) {
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
});
