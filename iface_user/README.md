# Learning Analytics

## Instructions d'installation

 * Installer rvm (https://rvm.io/rvm/install)
 * Ne pas oublier de bien ajouter `source ~/.rvm/scripts/rvm` à votre .bashrc
 * Se déplacer dans le dépôt. rvm va râler, et vous demander de faire diverses choses (installer la bonne version de ruby, truster le Gemfile, etc ...). Sortir du dossier et y revenir jusqu'à ce qu'il ne dise plus rien.
 * Pour la suite, bien rester dans le dossier du dépôt
 * gem install bundler
 * sudo apt-get install redis
 * bundle install
 * rake neo4j:install


## Commandes utiles :
* rails server      : Lance le serveur web sur le port 3000
* sidekiq           : Lance sidekiq, nécéssaire pour le lancement de scripts en background
* rake neo4j:start  : Lance le serveur neo4j (sur le port 7474)
* bundle install    : à lancer à chaque changement de gems
* rake db:migrate   : à lancer à chaque changement de structure de bdd
* rake db:seed      : remplit la BDD avec des données par défaut 
* rake db:populate  : remplit la BDD avec des données quelconques, histoire de pas avoir une BDD vide (utile seulement en dev)
