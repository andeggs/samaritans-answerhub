function removePluginFromConfig(plugin, type) {
    var config;
    if(type && pageContext.editor.configs[type]){
        config = pageContext.editor.configs[type];
    } else {
        //using .extend to clone
        config = $.extend(true, {}, pageContext.editor.configs.standard);
    }
    var i = 0;
    buttons = pageContext.editor.pluginButtons[plugin];
    while(i < buttons.length){
        var button = buttons[i];
        config.buttons.splice(config.buttons.indexOf(button), 1);
        i++
    }
    config.plugins.splice(config.plugins.indexOf(plugin), 1);
    pageContext.editor.configs[type] = config;
}

pageContext.editor = {
    configs: {
        standard: {
            buttons: ['code', 'bold', 'italic', 'blockquote', 'unorderedlist', 'orderedlist', 'image', 'file', 'link' ],
            plugins: ['upload', 'autotaguser', 'code']
        }
    },
    pluginButtons: {
        upload: ['image', 'file'],
        code: ['code']
    }
};

$(function () {

    var storage = $.localStorage;

    function readDraftValues($form, redactor, keys, load, setup, saveDraft) {
        var ret = false;
        var formAction = $form.attr('data-draftKey');
        keys.push(formAction);

        $form.find('input:not(.redactor, .submit)').each(function() {
            var name = $(this).attr('name');
            var storageKey = formAction + ':' + name;

            keys.push(storageKey);

            var oldVal = storage.get(storageKey);

            if (oldVal) {
                ret = true;

                if (load) {
                    if ($(this).is('.select2-offscreen')) {

                        var sel2Data = [];
                        var loadedTags = oldVal.split(',');

                        $.each(loadedTags, function(i, tag) {
                            sel2Data.push({
                                id: tag,
                                text: tag
                            });
                        });

                        $(this).select2("data", sel2Data);

                    } else {
                        $(this).val(oldVal);
                    }
                }
            }

            if (setup) {
                $(this).change(function() {
                    storage.set(storageKey, $(this).val());
                    saveDraft();
                })
            }
        });

        var oldContent = storage.get(formAction);
        var spaceSelect = storage.get('space_select');
        var spaceSelectText = storage.get('space_select_text');

        if (oldContent) {
            ret = true;
            if (load) {
                $("#space_select").val(spaceSelect.toString());
                $("#s2id_space_select .select2-chosen").text(spaceSelectText);
                redactor.redactor('set', oldContent.toString());
            }
        }

        return ret;
    }



    $(".redactor").each(function () {
        var $this = $(this),
            type = $this.attr("data-type"),
            config = pageContext.editor.configs.standard;
        if (type && pageContext.editor.configs[type]) {
            config = pageContext.editor.configs[type];
        }

        var showSaveDraft = undefined;

        function waitUntilNextMessage(time) {

            if (time == undefined){
                time = 18000;
            }

            window.setTimeout(function() {
                showSaveDraft = true;
            }, time);
        }

        function saveDraft() {
            if (showSaveDraft) {

                var $message = $('<div class="redactor-draft-save"><p>' + pageContext.i18n.draftSaveMessage +'</p></div>');

                $this.parent('.redactor_box').append($message);

                $message.fadeIn(300,function(){
                    $message.fadeOut(8000, function() {
                        $message.remove();
                    });
                });

                showSaveDraft = false;
                waitUntilNextMessage();
            } else if (showSaveDraft === undefined) {
                showSaveDraft = false;
                waitUntilNextMessage(2000);
            }
        }


        var $form = $this.parents('form');

        var formAction = $form.attr('data-draftKey');

        var keys = [];

        var showOverlay = false;

        if (formAction && readDraftValues($form, $this, keys, false, false)) {
            showOverlay = true;
        }

        var draftsSetup = false;

        var redactor = $this.redactor({
            plugins: config.plugins,
            buttons: config.buttons,
            convertDivs: false,
            linkSize: 1000,
            callback: function (redactor) {
                redactor.fixBlocks();
            },
            changeCallback: function(html) {
                if (draftsSetup) {
                    storage.set('space_select', $("#space_select").val());
                    storage.set('space_select_text', $("#space_select option:selected").text());
                    storage.set(formAction, html);
                    saveDraft();
                }
            },
            focusCallback: function(e) {
                if($(this.$element).parent().popover != undefined) {
                    $(this.$element).parent().popover("show");
                }
            }
            ,
            blurCallback: function(e) {
                if($(this.$element).parent().popover != undefined) {
                    $(this.$element).parent().popover("hide");
                }
            },
            convertUrlLinks: false,
            convertLinks: false
        });

        if (showOverlay) {
            var $overlay = $('<div class="redactor-draft-overlay"></div>');

            redactor.redactor('set', '');

            $form.find("input[name=topics]").val('');

            $form.css('position', 'relative');

            $form.append($overlay);

            var $message = $('<div class="alert alert-info redactor-draft-message"><p>' +
                pageContext.i18n.draftMessage.replace('TYPO',$form.attr('data-draftType')) +
                '</p><div class="buttons">' +
                '<input class="btn btn-primary pull-right load-draft" type="submit" value=\"' +
                pageContext.i18n.draftLoadButton + '\">' +
                '<input class="btn btn-delete pull-right cancel-draft" type="submit" value=\"' +
                pageContext.i18n.draftDeleteButton + '\">' +
                '</div></div>');

            $form.before($message);

            $overlay.click(function() {
                $message.animate({
                    'background-color': '#BDDFFF'
                }, 500, 'swing', function() {
                    $message.animate({
                        'background-color': '#D9EDF7'
                    }, 500);
                })
            });

            $message.find('.cancel-draft').click(function() {
                $overlay.remove();
                $message.slideUp('fast');

                storage.remove(keys);

                redactor.redactor('set', '');
                $form.find("input.select2-offscreen").select2("data", []);

                readDraftValues($form, $this, [], false, true, saveDraft);
                draftsSetup = true;

                return false;
            });

            $message.find('.load-draft').click(function() {
                $overlay.remove();
                $message.slideUp('fast');


                readDraftValues($form, $this, [], true, true, saveDraft);
                draftsSetup = true;

                return false;
            });
        } else if (formAction) {
            readDraftValues($form, $this, [], false, true, saveDraft);
            draftsSetup = true;
        }

        if (formAction) {
            $form.submit(function() {
                storage.remove(keys);
            });
        }
    });
});