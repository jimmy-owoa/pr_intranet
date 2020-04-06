$(document).on('turbolinks:load', function () {
  let creationOption = document.getElementById('creation_option');
  let fileSelector = document.getElementById('file');
  let manualFilters = document.getElementById('manual_filters');
  // if (creationOption.value == "manual"){
  //   fileSelector.style.display = "none"
  // }

  if (creationOption) {    
    creationOption.onchange = function (event) {    
      if (creationOption.value == "file"){
        fileSelector.style.display = "block"
        manualFilters.style.display = "none"
      }else{
        fileSelector.style.display = "none"
        manualFilters.style.display = "block"
      }
    }
  }
});