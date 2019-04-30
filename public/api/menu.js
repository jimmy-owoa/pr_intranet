function defer(method){
  if(document.getElementById("search_toolbar")){
    method();
  } else {
    setTimeout(function() { defer(method) }, 100);
  }
}

defer(function() {
  let vm = this;
  let textInput = document.getElementById("search_toolbar");
  let delayTimer = null;
  let menuConfig = document.getElementById("menu_config");
  textInput.onkeydown = event => {
    if (event.keyCode == 13) {
      event.preventDefault();
      this.text = document.getElementById("search_toolbar").value;
      document.getElementById("search_toolbar").value = "";
      window.location = menuConfig.dataset.baseSearchUrl + this.text;
      }
  };
  textInput.onkeyup = () => {
    clearTimeout(delayTimer);
    delayTimer = setTimeout(function() {
      this.text = document.getElementById("search_toolbar").value;
      let results_ul = document.getElementsByClassName("results_ul")[0];
      if (this.text.length > 2) {
        let Http = new XMLHttpRequest();
        let url = menuConfig.dataset.baseApiUrl + "/frontend/searchm?utf8=✓&term=" + this.text;
        Http.open("GET", url);
        Http.send();
        Http.onreadystatechange = e => {
          if (Http.readyState == 4) {
            let response = JSON.parse(Http.responseText);
            results_ul.innerHTML = "";
            if (response.length >= 1) {
              results_ul.style.display = "block";
              vm.results = _.capitalize(response);
              response.slice(-10).forEach(function(arrayItem) {
                let name = arrayItem.name;
                let link = "#/" + arrayItem.link;
                let href = document.createElement("A");
                let node = document.createElement("LI");
                let textnode = document.createTextNode(name);
                href.setAttribute("href", link);
                href.setAttribute("onclick", "closeResults()");
                href.appendChild(textnode);
                node.appendChild(href);
                results_ul.appendChild(node);
              });
              if (response.length >= 10) {
                let h = document.createElement("H4");
                let t = document.createTextNode("Ver más resultados");
                h.setAttribute("id", "more_results");
                h.appendChild(t);
                results_ul.appendChild(h);
                document
                  .getElementById("more_results")
                  .addEventListener("click", function(e) {
                    vm.search();
                  });
              }
            }
          }
        };
      } else {
        results_ul.style.display = "none";
      }
    }, 500);
  };
});
function closeResults() {
  document.getElementsByClassName("results_ul")[0].style.display = "none";
  document.getElementById("search_toolbar").value = "";
}