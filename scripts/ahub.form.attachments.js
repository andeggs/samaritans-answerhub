function addAttachmentToForm(attachment) {
    $('#main-attachments-container').slideDown();

    var $el = null;

    function createDeleteButton() {
        return $('<span>&nbsp;| </span><a class="node-attachment-delete" href="#"><i class="icon-remove"></i></a>');
    }

    if (attachment.isImage) {
        $el = $('<div class="img-node-attachment"></div>');
        var $link = $('<a href="' + attachment.url + '" target="_blank"></a>');

        $link.append($('<img src="' + attachment.url + '" width="100" />'));
        $link.append($('<span>' + attachment.fileName + '(' + attachment.size + ')' + '</span>'));
        $el.append($link);
        $el.append($('<input type="hidden" name="attachments" value="' + attachment.fileId + '" />'));

        $el.append(createDeleteButton());

        $('#img-attachments-container').append($el);

    } else {
        $el = $('<div class="node-attachment"></div>');
        $el.append('<span class="attachment-icon"></span>');
        $el.append($('<a href="' + attachment.url + '" target="_blank">' + attachment.fileName + '</a>'));
        $el.append($('<span> (' + attachment.size + ')</span>'));
        $el.append($('<input type="hidden" name="attachments" value="' + attachment.fileId + '" />'));

        $el.append(createDeleteButton());

        $('#attachments-container').append($el);
    }
}

function getAuthorizeContext(image) {
    var current = [];

    $('#main-attachments-container').find('input[name=attachments]').each(function() {
        current.push($(this).val());
    });

    var ret = {};
    $.extend(ret, pageContext.authorizeUploadContext);

    if (current.length > 0) {
        ret.current = current;
    }

    if (image) {
        ret.image = image;
    }

    return ret;
}

function replaceAttachmentUrl(txtBox){
    var txt = txtBox.val();
    txtBox.val(txt.replace(/(\/storage\/|\/storage\/[^\/]+\/)temp\//gi, '$1attachments/'));
}

$(document).ready(function() {
    $(document).on('click','.node-attachment-delete', function() {
        var $link = $(this);
        var fileId = $link.parent().find('input[type=hidden]').val();

        $.getJSON(pageContext.url.cancelUpload, {file: fileId});

        $link.parent().fadeOut('fast', function() {
            // Remove the attachment from the box
            $link.parent().remove();

            // Make the attachments box disappear if there are no attachments
            if ($(".img-node-attachment").length < 1 && $(".node-attachment").length < 1) {
                $('#main-attachments-container').slideUp();
            }
        });
        // Remove the image from the content area
        $('.redactor_editor #'.concat(fileId)).remove();
        // Just doing this so redactor knows something changed
        $('.redactor').redactor('insertText', '');
        $('.commentBox').redactor('insertText', '');
        return false;
    });
    $('.widget-content form').each(function(i,e){
        $(e).submit(function(ev){
            var box = $(e).find('.redactor') || null;
            if(box !== null && box.is('textarea')){
                replaceAttachmentUrl(box);
            }
        });
    });
});