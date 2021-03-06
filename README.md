# Learning Analytics

## Instructions d'installation

 * Installer openjdk 8 ; sous Debian 8, il faudra passer par les backports :
   * `echo -e "\n\n# Backports, pour installer OpenJDK 8 :\ndeb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list`
   * `apt-get update && apt-get -t jessie-backports install openjdk-8-jdk`
 * Installer rvm (https://rvm.io/rvm/install)
 * Ne pas oublier de bien ajouter `source ~/.rvm/scripts/rvm` à votre .bashrc
 * Se déplacer dans le dépôt. rvm va râler, et vous demander de faire diverses choses (installer la bonne version de ruby, truster le Gemfile, etc ...). Sortir du dossier et y revenir jusqu'à ce qu'il ne dise plus rien.
 * Pour la suite, bien rester dans le dossier du dépôt
 * gem install bundler
 * sudo apt-get install redis
 * bundle install
 * rake neo4j:install
 * Installer neo4j-shell-tools pour l'export en .csv (se placer dans iface_user/)
   * `curl -Lk -o neo4j-shell-tools.zip http://dist.neo4j.org/jexp/shell/neo4j-shell-tools_2.3.2.zip && \
      unzip neo4j-shell-tools.zip -nd db/neo4j/development/lib && \
      rm neo4j-shell-tools.zip && \
      chmod -R 755 db/neo4j/development/lib && \
      db/neo4j/development/bin/neo4j restart `

## Commandes utiles :
* rails server      : Lance le serveur web sur le port 3000
* sidekiq           : Lance sidekiq, nécéssaire pour le lancement de scripts en background
* rake neo4j:start  : Lance le serveur neo4j (sur le port 7474)
* rake neo4j:shell  : Lance une CLI neo4j
* bundle install    : à lancer à chaque changement de gems
* rake db:migrate   : à lancer à chaque changement de structure de bdd
* rake db:seed      : initialise la BDD avec des données initiales
* rake db:populate  : remplit la BDD avec des données quelconques, histoire de pas avoir une BDD vide (utile seulement en dev)
