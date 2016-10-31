/* OVERRIDE */

// answerhub/teamhub.home/themes/base/scripts/teamhub.user.commands.js:95
register_command('editUserPhoto', {
    createDialogNodes: function() {
        var $nodes = commandUtils.createUploadDialogNodes();

        // Hide default input file and create fake input to change text if it is not IE
        if (navigator.appName !== 'Microsoft Internet Explorer') {
            var $form = $nodes.find('form');
            $form.css({position: 'relative', overflow: 'hidden'});
            // move it out of the screen instead of hidding
            var $inputFile = $form.find('[type="file"]').css({left: '-99999em', position: 'absolute'});
            var $buttonSelect = $(document.createElement('BUTTON')).
                                text(pageContext.i18n.uploadProfilePictureSelectButton).
                                addClass('btn btn-default');
            var $buttonLabel = $(document.createElement('SPAN')).
                                text(pageContext.i18n.changeAvatarSelectNoPhoto);

            $buttonSelect.on('click', function(e) {
                e.preventDefault();
                $inputFile.trigger('click');
            });

            $inputFile.on('change', function() {
                $buttonLabel.text(this.value);
            });

            $form.append($(document.createElement('DIV')).addClass('fake-avatar-input').append($buttonSelect, $buttonLabel));
        }

        $extra = $('<div><h3>' +
                    this.getMessage('or') +
                    '</h3><div class="click-on-avatar"><a href="#" class="use-gravatar btn btn-default">' +
                    this.getMessage('gravatar') +
                    '</a> <img src="' +
                    this.getMessage('gravatarUrl') +
                    '&s=32' + '"/></div></div>');

        $nodes.append($extra);
        return $nodes;
    },

    execute: function(evt) {
        var parser = this;
        commandUtils.showUploadDialog(evt, {
            nodes: parser.createDialogNodes(),
            //tpl: 'edit-topic-icon',
            authorizeUrl: parser.getParsedUrl('authorizeUrl'),
            onSuccess: function(trackingId, data) {
                $.ajax({
                    type: 'POST',
                    url: parser.getUrl(),
                    data: {file: data.fileId},
                    success: function(data) {
                        if (data.success) {
                            $('#profile-user-avatar').attr('src', parser.getParsedUrl('user.uploaded.photo') + '?bypassCache=' + (Math.floor(Math.random()*1001)));
                        } else {

                        }
                    },
                    dataType: 'json'
                });
            },
            previewDialogOptions: {
                forceSquare: true
            },
            dialogContext: {
                title: 'Change your avatar picture',                /* Change */
                iconUrl: this.getUrl('topic.icon'),
                beforeShow: function($dialog) {
                    $dialog.find('.use-gravatar').click(function() {
                        $.get(parser.getParsedUrl('resetUrl'));
                        $('#profile-user-avatar').attr('src', parser.getMessage('gravatarUrl') + '&s=128');
                        commandUtils.closeDialogFunction($dialog)();
                        return false;
                    });
                }
            }
        });
    }
});