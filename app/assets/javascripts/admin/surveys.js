 $(document).ready(function () {
   $('.select-question-type').on('change', function () {
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
   //    });

 });