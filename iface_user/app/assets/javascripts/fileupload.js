var fileUploadErrors = {
    maxFileSize: 'File is too big',
    minFileSize: 'File is too small',
    acceptFileTypes: 'Filetype not allowed',
    maxNumberOfFiles: 'Max number of files exceeded',
    uploadedBytes: 'Uploaded bytes exceed file size',
    emptyResult: 'Empty file upload result'
};

function prepareFileupload() {
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        dataType: 'json',
        done: function (e, data) {
            $.each(data.result.files, function (index, file) {
                $('<p/>').text(file.name).appendTo(document.body);
            });
        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress').css(
                'width',
                progress + '%'
                );
        }
    });
    // 
    // Load existing files:
    $.getJSON($('#fileupload').prop('action'), function (files) {
        var fu = $('#fileupload').data('blueimpFileupload'),
        template;
    fu._adjustMaxNumberOfFiles(-files.length);
    template = fu._renderDownload(files)
        .appendTo($('.fileupload .files'));
    // Force reflow:
    fu._reflow = fu._transition && template.length &&
        template[0].offsetWidth;
    template.addClass('in');
    $('#loading').remove();
    });
};
