// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require twitter/bootstrap
//= require turbolinks
// require jquery-fileupload
//= require fileupload.js
//= require_tree .

//= require jquery-fileupload/vendor/jquery.ui.widget
//= require jquery-fileupload/vendor/tmpl
//= require jquery-fileupload/vendor/canvas-to-blob
//= require jquery-fileupload/jquery.iframe-transport
//= require jquery-fileupload/jquery.fileupload
//= require jquery-fileupload/jquery.fileupload-process
//= require jquery-fileupload/jquery.fileupload-validate
//= require jquery-fileupload/locale
//= require jquery-fileupload/jquery.fileupload-jquery-ui

var url ,chargement, loadMOOC

url='http://localhost:3000';

chargement = $('<div class="hidden"><p>Chargement...</p></div>');

function changeContent(tag, u, f){
    $(tag).empty();
    $(tag).append(chargement);
    $.get(u, function(data, status){
        $(tag).empty();
        $(tag).append(data);
        if (f) {
            f();
        };
    });
};

function loadMOOC(id){
    changeContent($("#info_mooc"), url+'/moocs/'+id, prepareFileupload);


};

function inputify(tag){
    this.inputtag=$('<input type="text" value="'+$(tag).text()+'"></input>');
    $(tag).after(inputtag);
    $(tag).remove();
};

function editMOOC(id){
    changeContent($("#mooc"), url+'/moocs/'+id+'/edit',prepareFileupload);
};

$(document).on('page:load ready', function(){
    loadMOOC($("#select_mooc").find(":selected").val());
    $(document).on('submit', '.edit_mooc', function() {
        noeud = $(this).parent();
        $.ajax({
            data: $(this).serialize(),
            type: $(this).attr('method'),
            url: $(this).attr('action'),
            success: function(response) {
                $(noeud).empty();
                $(noeud).append(response);
            }
        });
        return false; 
    });
});
