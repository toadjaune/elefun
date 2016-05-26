var fileUploadErrors = {
    maxFileSize: 'File is too big',
    minFileSize: 'File is too small',
    acceptFileTypes: 'Filetype not allowed',
    maxNumberOfFiles: 'Max number of files exceeded',
    uploadedBytes: 'Uploaded bytes exceed file size',
    emptyResult: 'Empty file upload result'
};

function progressbar() {
    return '<div class="progress progress-success progress-striped active col-sm-offset-1 col-sm-4"><div class="progress-bar" style="width:0%;"></div></div>'
};

function deleteFile(url, span) {
    return '<span class="col-sm-2">Fichier chargé</span>'+
            '<button class="btn btn-warning btn-xs col-sm-1 delete-file" data-confirm="Êtes-vous sûr ?" data-url='+url+'>Supprimer</button>'
};


function prepareFileupload() {
    // Initialize the jQuery File Upload widget:
    $('.fileupload').fileupload({
        dataType: 'json',
        add: function (e, data) {
            // MàJ du nom du fichier
            $($(e.target).find('.fsc')).empty();
            $($(e.target).find('.fsc')).append($("<scan>"+data.files[0].name+"</scan>"));
            // Ajout du bouton charger
            data.context = $('<button/>').text('Charger')
                .addClass("btn btn-success btn-xs col-sm-1 col-sm-offset-1")
                .replaceAll($(e.target).find('.prog-zone'))
            // Action en cas de click sur le bouton charger
                .click(function () {
                    data.context = $(progressbar()).replaceAll($(this));
                    data.submit();
                });
        },
        done: function (e, data) {
            var suppr = $('<div class="row"></div>');
            suppr.append($($(e.target).find('.categorie')))
                .append($(deleteFile(data.result.files[0].delete_url)))
                .replaceAll($(e.target));
            deleteFichier();
        },
        progress: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $(e.target).find('.progress-bar').css(
                'width',
                progress + '%'
                );
        }
    }); 

    //// Load existing files:
    //$.getJSON($('#fileupload').prop('action'), function (files) {
    //    var fu = $('#fileupload').data('blueimpFileupload'),
    //    template;
    //fu._adjustMaxNumberOfFiles(-files.length);
    //template = fu._renderDownload(files)
    //    .appendTo($('.fileupload .files'));
    //// Force reflow:
    //fu._reflow = fu._transition && template.length &&
    //    template[0].offsetWidth;
    //template.addClass('in');
    //$('#loading').remove();
    //});
};
