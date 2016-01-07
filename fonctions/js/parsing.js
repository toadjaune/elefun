//On présuppose disposer du json de l'organisation du cours data

cours = JSON.parse(data);
//il suffit pour peupler la bdd de parcourir le JSON en postfix.


//Affichage de l'arborescence du cours en parcours postfix

function tree(json, i = ""){
  console.log(i+json.display_name);
  i = i + " ";
  for child in json.children {
    tree(cours.blocks[child], i);
  }
}

tree(cours.root);