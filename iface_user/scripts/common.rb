#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'neo4j'
require 'date'

require_relative 'regroup/user'
require_relative 'regroup/session'

require_relative 'models/etiquetable'
require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'
require_relative 'models/fil'
require_relative 'models/response'
require_relative 'models/comment'
require_relative 'models/page'
require_relative 'models/video'
require_relative 'models/question'
require_relative 'models/quiz'
require_relative 'models/info_week'
require_relative 'models/week'
require_relative 'models/result'

require_relative 'parsers/problem'
require_relative 'parsers/user_session'
require_relative 'parsers/enrollment'
require_relative 'parsers/forum'
require_relative 'parsers/browser'



# Valeurs par défaut, propres au MOOC utilisé en dev
# TODO: les retirer à la fin
$fichier_structure  = File.new('fichiers/20003S02/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json','r')
$fichier_log        = File.new('fichiers/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
$auteur             = 'ENSCachan'
$id_cours           = '20003S02'
$periode            = 'Trimestre_1_2015'



OptionParser.new do |opts|

  opts.banner = 'Test'

  opts.on '-s', '--structure STRUCTURE_FILE', 'Fichier de structure du MOOC' do |s|
    $fichier_structure = File.new "fichiers/#{s}", 'r'
  end

  opts.on '-l', '--log LOG_FILE', 'Fichier de logs du MOOC' do |l|
    $fichier_log = File.new "fichiers/#{l}", 'r'
  end

  opts.on '-a', '--auteur AUTEUR', 'Auteur du MOOC' do |a|
    $auteur = a
  end

  opts.on '-i', '--id ID_COURS', 'ID du MOOC' do |i|
    $id_cours = i
  end

  opts.on '-p', '--periode PERIODE', 'Periode du MOOC' do |p|
    $periode = p
  end

end.parse!

$db = Neo4j::Session.open(:server_db)
