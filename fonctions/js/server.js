 function loadJSON(callback) {   
    console.log("Début du parsing");
    var xobj = new XMLHttpRequest();
        xobj.overrideMimeType("application/json");
    xobj.open('GET', '../../data/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json', true); // Replace 'my_data' with the path to your file
    xobj.onreadystatechange = function () {
          if (xobj.readyState == 4 && xobj.status == "200") {
            // Required use of an anonymous callback as .open will NOT return a value but simply returns undefined in asynchronous mode
            callback(xobj.responseText);
          }
    };
    console.log("Fin du parsing");
    xobj.send(null); 
    
 }


function init() {
 console.log("Début de l'initialisation");
 loadJSON(function(response) {
  // Parse JSON string into object
    var data = JSON.parse(response);
 });
  for (var key in data) {
    console.log(key + ' -> ' + data[key]);    
  }
}

function read_json() {
  console.log("Début du parsing");
  $.getJSON('../../data/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json', function(data) {
    for (var key in data) {
      console.log(key + ' -> ' + data[key]);    
    }
  });
  console.log("Fin du parsing");
}