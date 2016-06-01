var baseURL = "/bdd_script_associations";

function elementListeScript(infos){
  var sortie = '<tr class="';
  // Coloration du fond en fonction de l'état
  switch(infos['etat']){
    case "Jamais lancé":
      sortie += 'info';
      break;
    case "En attente":
      sortie += 'warning';
      break;
    case  "Réussi":
      sortie += 'success';
      break;
    case "Échoué":
      sortie += 'danger';
      break;
    case "En cours":
      sortie += 'active';
      break;
    default:
      break;
  };
  // Nom Script
  sortie += '"><td colspan="2">'+infos['nom']+'</td>';
  // Etat Script
  sortie += '<td>'+infos['etat']+'</td>';
  // Bouton Script
  sortie += '<td><span data-id_script="'+infos['id']+'" class="btn';
  switch(infos['etat']){
    case "En cours":
    case "En attente":
      sortie += ' btn-danger bouton-reset">Réinitialiser';
      break;
    default:
      sortie += ' btn-success bouton-lancement">Lancer';
      break;
  };
  sortie += '</span></td>';
  // Fin ligne
  sortie += '</td>';
  return sortie;
};

function displayScripts(s){
  var div = $('#bdd-script-container');
  div.empty();
  scripts = s['scripts'].sort(function(a,b){return a['numero']-b['numero'];});
  for (var i=0; i<scripts.length; i++) {
    div.append(elementListeScript(scripts[i]));
  }
  prepareBoutonsScript()
};

function affichageScripts(){
  $.ajax({
    url: '/moocs/'+ $("#select_mooc").find(":selected").val() +'/bdd_script_associations.json',
    type: 'GET',
    success: function(response){
      displayScripts(response);
    }
  });
};

function runScript(id){
  $.ajax({
    url: baseURL+"/"+id+"/launch.json",
    type: 'GET',
    success: function(response){
      displayScripts(response);
    }
  });
};

function resetScript(id){
  $.ajax({
    url: baseURL+"/"+id+"/reset.json",
    type: 'GET',
    success: function(response){
      displayScripts(response);
    }
  });
};

function runAllScripts(){
  $.ajax({
    url: '/moocs/'+ $("#select_mooc").find(":selected").val() +'/launch_all_scripts.json',
    type: 'GET',
    success: function(response){
      displayScripts(response);
    }
  });
};


function prepareScript() {
  // Bouton actualiser
  $('#refresh-script').click(affichageScripts);
  // Auto-refresh
  setInterval(affichageScripts, 15000);
  // Lancement de tous les scripts
  $('#run-all').click(runAllScripts);
};

function prepareBoutonsScript(){
  // Lancement de script
  $(".bouton-lancement").click(function(e){
    runScript(e.target.dataset.id_script);
  });
  // Reset de Script
  $(".bouton-reset").click(function(e){
    resetScript(e.target.dataset.id_script);
  });
};
