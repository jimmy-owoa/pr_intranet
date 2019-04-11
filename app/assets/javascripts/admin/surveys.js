$(document).ready(function() {
  $(".select-question-type").on("change", function() {
    var selectedVal = $(this).val();
    if (selectedVal == "Escala lineal") {
      $("#lineal_message").show();
    } else {
      $("#lineal_message").hide();
    }
  });
  //  $('.select-question-type').change(
  //    function () {
  //      var option = document.getElementsByClassName("add_option")[0];
  //      if ($(this).val() == "Verdadero o Falso") {
  //        option.style.display = "none";
  //      } else {
  //        option.style.display = "block";
  //      }
  //    }); =
  // var triggered = false;
  // $(document).on({
  //   keypress: function(e) {
  //     if(!triggered){
  //       addOptionOnKeypress(e, "keypress");
  //     }
  //   },
  //   keyup: function(e) {
  //     if (!triggered) {
  //       addOptionOnKeypress(e, "keyup");
  //     }
  //   },
  //   keydown: function(e) {
  //     if (!triggered) {
  //       addOptionOnKeypress(e, "keydown");
  //     }
  //   }
  // });

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
