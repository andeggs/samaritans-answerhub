var response_commands = {};

var commands = {};

var parser_prototype = {

    _initializeOn: 'mouseover',

    command: null,
    nodeElement: null,
    element: null,
    nodeId: null,

    _initBase: function () {
        this.messages = {};
        this.urls = {};
    },

    setMsg: function (key, msg) {
        this.messages[key] = msg;
    },

    setUrl: function (key, url) {
        this.urls[key] = url;
    },

    init: function () {
        return;
    },

    isAttrBased: function () {
        var attr = this.element.attr('data-status');
        return typeof attr !== 'undefined' && attr !== false;
    },

    getStatus: function () {
        if (this.isAttrBased()) {
            return this.element.attr("data-status");
        }

        return this.element.hasClass('on') ? 'on' : 'off';
    },

    setStatus: function (status) {
        if (this.isAttrBased()) {
            this.element.attr("data-status", status);
            return;
        }

        status == 'on' ? this.element.addClass('on') : this.element.removeClass('on');
    },

    switchStatus: function () {
        this.setStatus(this.getStatus() == "on" ? 'off' : 'on');
    },

    getUrlSkeleton: function (name) {
        return this.urls[name] != undefined ? this.urls[name] : false;
    },

    getParsedUrl: function (name) {
        var urlSkeleton = this.getUrlSkeleton(name);

        if (urlSkeleton) {
            return urlSkeleton.replace(new RegExp('%25ID%25', 'g'), this.nodeId);
        }

        return null;
    },

    getUrl: function () {
        var url = this.getParsedUrl('click.' + this.getStatus());

        if (!url) {
            url = this.getParsedUrl('click');
        }

        if (!url) {
            url = this.getParsedUrl('click.off');
        }

        if (url) {
            return url;
        }

        url = this.element.attr('href');
        return url ? url : false;
    },


    getMessage: function (name) {
        return this.messages[name] != undefined ? this.messages[name] : null;
    },

    getTitle: function () {
        var title = this.getMessage('title.' + this.getStatus());

        if (title == null) {
            title = this.getMessage('title');
        }


        return title;

    },

    getLinkText: function () {
        var text = this.getMessage('linkText.' + this.getStatus());

        if (text == null) {
            text = this.getMessage('linkText');
        }

        return text;
    },

    updateTitle: function () {
        var title = this.getTitle();

        if (title != null) {
            this.element.attr('title', title);
        }
    },

    updateLinkText: function () {
        var text = this.getLinkText();

        if (text != null) {
            this.element.html(text);
        }
    },

    executeRequest: function (data, evt) {
        var thiz = this;
        try {
            var rUrl = this.getUrl();
            if (thiz.element.attr('data-process') == 'process') return;
            if (rUrl) {
                var parser = this;
                var response_type = this.getResponseType().toLowerCase();
                var opts = {
                    url: rUrl,
                    cache: false,
                    beforeSend: function() {
                        thiz.element.attr('data-process', 'process');
                    },
                    success: function (data) {
                        thiz.element.attr('data-process', 'no');
                        parser.onSuccess(data, evt);
                        parser.onCompleted(true, evt);
                    },
                    error: function (request, status, error) {
                        thiz.element.attr('data-process', 'no');
                        var data = request.responseText;

                        if (response_type == 'json') {
                            try {
                                data = $.parseJSON(data);
                            } catch (e) {
                                console.log(e);
                            }
                        }

                        parser.onFailure(data, request.status, status, evt);
                        parser.onCompleted(false, evt);
                    },
                    type: this.getRequestMethod().toUpperCase(),
                    dataType: response_type,
                    traditional: true
                };

                if (data) {
                    opts.data = data;
                }

                $.ajax(opts);
            }
        } catch (e) {
            console.error(e);
        }
    },

    execute: function (evt) {
        this.executeRequest(this.getRequestData(), evt);
    },

    onSuccess: function (data, evt) {
        return;
    },

    onCompleted: function (success, evt) {
        if (success) {
            this.switchStatus();
            this.updateTitle();
            this.updateLinkText();
        }
    },

    onFailure: function (data, status, error, evt) {
        if (data.errors != undefined && data.errors.message != undefined) {
            this.alert(evt, data.errors.message);
        }
    },

    getRequestMethod: function () {
        return 'POST';
    },

    getResponseType: function () {
        return 'json';
    },

    getRequestData: function () {
        return this.element.dataAttributes();
    },

    confirm: function (evt, title, msg) {
        var parser = this;

        commandUtils.showConfirmation(evt, title, msg, function () {
            parser.executeRequest(parser.getRequestData(), evt);
        })
    },

    alert: function (evt, msg) {
        var parser = this;

        commandUtils.showMessage(evt, msg);
    },

    dialog: function (evt, dialogId, context, title) {
        var parser = this;

        commandUtils.showPrompt(evt, dialogId, context ? context : this.messages, {
            title: title,
            onOk: function (data) {
                parser.executeRequest(data);
            }
        });
    }

};

function create_object(o) {
    function F() {
    }

    F.prototype = o;
    return new F();
}

function register_command(command, parser) {
    var base = create_object(parser_prototype);
    base.command = command;
    if (parser) {
        $.extend(base, parser);
    }
    base._initBase();
    commands[command] = base;
}

var commandUtils = {

    getInputFile: function (input) {
        var file;
        if (!window.FileReader) {
            return null;
        }
        if (!input.files) {
            return null;
        }
        if (!input.files[0]) {
            return null;
        }

        file = input.files[0];
        return file;
    },

    /**
     *
     * @param size the maximum size permitted
     * @param decimal true if decimal, false (or undefined) if binary
     * @returns {string} the formatted, human-readable size
     */
    getHumanReadableSize: function (size, decimal) {
        // go with binary if there's no second argument
        if (typeof decimal === "undefined" || decimal !== true) {
            var bytes = 1024;
        } else {
            var bytes = 1000;
        }
        var SizePrefixes = ' KMGT';
        if (size <= 0) return '0';
        var t2 = Math.min(Math.floor(Math.log(size) / Math.log(bytes)), 12);
        return (Math.round(size * 10 / Math.pow(bytes, t2)) / 10) +
            SizePrefixes.charAt(t2).replace(' ', '') + 'B';
    },

    reloadPage: function () {
        window.location.href = window.location.href.replace(/#[^#]*$/, '');
    },

    getScript: function (url, success) {

        if (url.constructor == Array) {
            function run(i) {
                if (i < url.length) {
                    commandUtils.getScript(url[i], function () {
                        run(++i);
                    });
                } else {
                    if (success) {
                        success();
                    }
                }
            }

            run(0);
        }

        var script = document.createElement('script');
        script.src = url;

        var head = document.getElementsByTagName('head')[0],
            done = false;

        script.onload = script.onreadystatechange = function () {

            if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {

                done = true;

                if (success) {
                    success();
                }

                script.onload = script.onreadystatechange = null;
                head.removeChild(script);
            }

        };

        head.appendChild(script);
    },

    getStyle: function (url) {
        if (url.constructor == Array) {
            for (var i = 0; i < url.length; i++) {
                commandUtils.getStyle(url[i]);
            }
        }

        var style = document.createElement('link');

        style.type = 'text/css';
        style.rel = 'stylesheet';
        style.href = url;
        style.media = 'screen';

        document.getElementsByTagName('head')[0].appendChild(style);
    },

    loadExtraScript: function (extra, callback) {

        if (extra.css) {
            commandUtils.getStyle(extra.css);
        }

        if (extra.js) {
            commandUtils.getScript(extra.js, callback);
        }
    },

    preloadImage: function (src, success) {
        var img = document.createElement('img');
        img.src = src;
        $(img).hide();

        var body = document.getElementsByTagName('body')[0],
            done = false;

        img.onload = img.onreadystatechange = function () {

            if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {

                done = true;

                if (success) {
                    success();
                }

                img.onload = img.onreadystatechange = null;
                body.removeChild(img);
            }

        };

        body.appendChild(img);
    },

    findNodeElement: function ($el) {
        var nodeId = $($el.parents("*[nodeId]").get(0)).attr("nodeId");
        var $with_nodeId = $el.parents("*[nodeId=" + nodeId + "]");
        if ($with_nodeId.length > 0) {
            return $($with_nodeId.get($with_nodeId.length - 1));
        }
        return null;
    },

    findCommand: function (nodeId, commandName) {
        return $('*[nodeId=' + nodeId + '] *[command=' + commandName + ']');
    },

    extractCommand: function ($el) {
        var parser = $el.data('command_parser');

        if (!parser) {
            var command = $el.attr('command');

            if (commands[command] != undefined) {
                parser = create_object(commands[command]);
                parser.element = $el;

                var $node_el = this.findNodeElement($el);
                if ($node_el != null) {
                    parser.nodeElement = $node_el;
                    parser.nodeId = $node_el.attr('nodeId');

                }

                parser.init();
                $el.data('command_parser', parser);
            }
        }

        return parser;
    },

    findAndExtractCommand: function (nodeId, commandName) {
        return this.extractCommand(this.findCommand(nodeId, commandName));
    },

    _initializeLablesOnCommands: function($commnads) {
        $commnads.each(function () {
            var parser = commandUtils.extractCommand($(this));
            if (parser) {
                parser.updateTitle();
                parser.updateLinkText();
            }
        });
    },
    
    initializeLabels: function () {
        this._initializeLablesOnCommands($("*[command]"));
    },
    
    initializeLabelsOnElement: function($element) {
        this._initializeLablesOnCommands($element.find("*[command]"));
    },

    updatePostScore: function (id, newScore, hideOnZero) {
        var $score_box = $('#post-' + id + '-score');
        var $score_box_wrapper = $('#post-' + id + '-score-wrapper');

        $score_box.html(newScore);
        if ($score_box_wrapper.length === 1) {
            if (newScore === 1 && !$score_box_wrapper.hasClass("votes")) {
                $score_box.parent().html($score_box).prepend("<i class='icon-thumbs-up'></i> ");
            }
            if (newScore === 0) {
                $score_box.removeClass("positive");
                $score_box.removeClass("negative");
                $score_box_wrapper.removeClass("positive");
                $score_box_wrapper.removeClass("negative");
            } else if (newScore > 0) {
                $score_box.removeClass("negative");
                $score_box.addClass("positive");
                $score_box_wrapper.removeClass("negative");
                $score_box_wrapper.addClass("positive");
            } else {
                $score_box.removeClass("positive");
                $score_box.addClass("negative");
                $score_box_wrapper.removeClass("positive");
                $score_box_wrapper.addClass("negative");
            }
        }

    },

    startCommand: function () {
        $('body').append($('<div id="command-loader"></div>'));
        running = true;
    },

    endCommand: function (success) {
        if (success) {
            $('#command-loader').addClass('success');
            $('#command-loader').fadeOut("slow", function () {
                $('#command-loader').remove();
                running = false;
            });
        } else {
            $('#command-loader').remove();
            running = false;
        }
    },

    renderTemplate: function (id, context) {
        $.extend(context, pageContext);
        return $('#' + id).tmpl(context);
    },

    renderTemplateSource: function (src, context) {
        $.extend(context, pageContext);
        return $.tmpl(src, context);
    },

    closeDialogFunction: function ($diag) {
        return function () {
            $diag.dialog("close");
        }
    },

    dialogSkeleton: function (options) {
        return {
            type: 'src',
            value: '<div class="${extraClass}" style="display: none;"><div>${content}</div></div>'
        }
    },

    renderDialog: function ($dialog, options) {
        var ui_options = {
            draggable: false,
            modal: true,
            width: options.dim.w > 200 ? 'auto' : 200,
            height: 'auto',
            position: 'center'
        };

        if (options.ui_options) {
            $.extend(true, ui_options, options.ui_options);
        }

        if (!ui_options.buttons) {
            ui_options.buttons = {};
        }

        if (options.title != undefined) {
            ui_options.title = options.title;
        }

        var closeFunction = this.closeDialogFunction($dialog);

        if (options.show_yes) {
            ui_options.buttons[options.yes_text] = function () {
                options.yes_callback($dialog, closeFunction);
            }
        }

        if (options.show_no) {
            ui_options.buttons[options.no_text] = closeFunction;
        }

        ui_options.closeText = "X";

        return {
            element: $dialog,
            display: function () {
                $dialog.css('visibility', 'visible');
                $dialog.dialog(ui_options);
            }
        };
    },

    closeDialogFunction: function ($diag) {
        return function () {
            $diag.modal("hide");
        };
    },

    getModalBody: function() {
        var $body = $(document.createElement('DIV'));
        $body.addClass('modal-body');
        return $body;
    },

    getModalNode: function(extra_class) {
        var $modal = $(document.createElement('DIV'));
        $modal.addClass('modal');
        if (extra_class) {
            $modal.addClass(extra_class);
        }
        return $modal;
    },

    getModalHeader: function(titleText) {
        var $header = $(document.createElement('DIV'));
        $header.addClass('modal-header');

        var $close = $(document.createElement('BUTTON'));
        $close.addClass('close');
        $close.attr({
            'type': 'button',
            'data-dismiss': 'modal',
            'aria-hidden': 'true'
        });
        $close.html('&times;');
        $header.append($close);

        $title = $(document.createElement('H3'));
        if (titleText) {
            $title.text(titleText);
        }
        $header.append($title);
        return $header;
    },

    getModalFooter: function(yesText, noText, yesCallback, $modal, noCallback) {
        var $footer = $(document.createElement('DIV'));
        $footer.addClass('modal-footer');

        if (noText) {
            var $noButton = $(document.createElement('A'));
            $noButton.attr('href', '#');
            $noButton.attr('data-dismiss', 'modal');
            $noButton.attr('aria-hidden', 'true');
            $noButton.addClass('btn');
            $noButton.text(noText);
            $footer.append($noButton);
            if (typeof noCallback === 'function') {
                $noButton.on('click', function(event) {
                    event.preventDefault();
                    noCallback($modal, commandUtils.closeDialogFunction($modal));
                });
                $modal.modal('hide');
            }
        }

        if (yesText) {
            var $yesButton = $(document.createElement('A'));
            $yesButton.attr('href', '#');
            $yesButton.addClass('btn btn-primary');
            $yesButton.text(yesText);

            if (typeof yesCallback === 'function') {
                $yesButton.on('click', function(event) {
                    event.preventDefault();
                    yesCallback($modal, commandUtils.closeDialogFunction($modal));
                });
                $modal.modal('hide');
            }

            $footer.append($yesButton);
        }

        return $footer;
    },

    showDialog: function(extern) {

        var options = {
            title: '',
            extra_class: '',
            yes_text: pageContext.i18n.ok,
            show_yes: true,
            yes_callback: function () {
            },
            no_text: pageContext.i18n.cancel,
            show_no: false
        };

        $.extend(true, options, extern);

        $.extend(options, pageContext);

        var $modal = this.getModalNode(options.extra_class);
        $modal.close = this.closeDialogFunction($modal);

        /* Append header */
        if (options.title) {
            $modal.append(this.getModalHeader(options.title));
        }

        /* Append body */
        var $dialog = this.getModalBody();
        $dialog.append(options.nodes);
        $modal.append($dialog);

        /* Append footer */
        if (options.show_no || options.show_yes) {
            if (!options.show_yes) options.yes_text = false;
            if (!options.show_no) options.no_text = false;
            $modal.append(this.getModalFooter(options.yes_text, options.no_text, options.yes_callback, $modal, options.no_callback));
        }

        if (options.beforeShow && typeof options.beforeShow === 'function' ) {
            options.beforeShow($modal);
        }

        $modal.modal('show');

        if (options.onAfterShow && typeof options.onAfterShow === 'function' ) {
            options.onAfterShow($modal);
        }

        return $modal;
    },

    getDialogNodes: function (options, defFunc, baseContext) {
        if (options.tpl) {
            var context = options.context ? options.context : (options.dialogContext ? options.dialogContext : {});
            if (options.context) {
                context = options.context;
            }

            $.extend(context, baseContext);
            return commandUtils.renderTemplate(options.tpl, context);
        } else if (options.nodes) {
            return options.nodes;
        } else {
            if (options.autorizeContext) {
                return defFunc(options.authorizeContext.image);
            } else {
                return defFunc(false);
            }
        }
    },

    uploadTrackers: 0,

    createUploadTracker: function (authorizeUrl, authorizeContext, callbacks) {
        this.uploadTrackers += 1;
        var tracker = $(document.createElement('div')),
            bar = $(document.createElement('div'));
        tracker.addClass('progress');
        bar.addClass('bar');
        tracker.append(bar);
        var trackerId = "uploadTracker" + this.uploadTrackers;
        bar.attr("id", trackerId);

        var errors = 0;

        function track(trackingId) {
            $.ajax({
                type: 'POST',
                url: pageContext.url.uploadProgress,
                data: {'trackingId': trackingId},
                success: function (data) {
                    if (data.success) {
                        var bar = $('#' + trackerId);
                        bar.html(data.result.progress + '%');
                        bar.css("width", data.result.progress + '%');

                        if (!data.result.complete) {
                            track(trackingId);
                        } else {
                            if (callbacks.onSuccess) {
                                callbacks.onSuccess(data);
                            }
                        }
                    } else {
                        errors++;
                        if (errors > 3 && callbacks.onError) {
                            callbacks.onError(data);
                        } else {
                            track(trackingId);
                        }
                    }
                },
                dataType: 'json',
                traditional: true
            });
        }

        $.ajax({
            type: 'POST',
            url: authorizeUrl,
            data: authorizeContext,
            success: function (data) {
                if (data.success) {
                    callbacks.onAuthorize(true, data.result.trackingId);
                    track(data.result.trackingId);
                } else {
                    callbacks.onAuthorize(false, (data.errors && data.errors.error) ? data.errors.error : "unauthorized");
                }
            },
            dataType: 'json',
            traditional: true
        });

        return tracker;
    },

    createUploadDialogNodes: function (isImage) {
        var NON_MATCHED_TYPES = [ "application/octet-stream", "text/plain" ];
        var getAcceptTypesForExtension = function(extension) {
            var mimeTypes = $.grep(jsmime.getMimesByExt(extension), function(value) {
                return NON_MATCHED_TYPES.indexOf(value) == -1;
            });
            if (mimeTypes.length != 0) {
                return mimeTypes;
            }
            return [ '.' + extension ];
        };

        var $nodes = $('<div></div>');
        var $urlInput = $('<span><h3></h3></span>');
        $nodes.append($urlInput);

        var $form = $('<form enctype="multipart/form-data" method="POST" target="uploaderFrame"></form>');

        var authorizedTypes = isImage ? authorizedImageTypes : authorizedFileTypes;
        var authorizedMimeTypes = [];
        for(var i = 0; i < authorizedTypes.length; i++) {
            var acceptTypes = getAcceptTypesForExtension(authorizedTypes[i]);
            authorizedMimeTypes = authorizedMimeTypes.concat(acceptTypes);
        }

        $form.append($('<input type="file" name="file"/>'));
        $nodes.append($form);

        var $progressContainer = $('<span id="uploadProgressContainer"></span>');
        $nodes.append($progressContainer);

        return $nodes;
    },

    showUploadDialog: function (evt, options) {
        var doptions = {
            nodes: commandUtils.getDialogNodes(options, commandUtils.createUploadDialogNodes, pageContext.i18n.uploadDialog),
            title: pageContext.i18n.uploadDialog.uploadFile,
            yes_text: pageContext.i18n.uploadDialog.doUpload,
            show_no: true
        };
        var $progressContainer = doptions.nodes.find(options.progressContainer ? options.progressContainer : "#uploadProgressContainer");
        var $form = doptions.nodes.find('form');
        var isUploading = false;
        var $input = $form.find("input[type=file]");
        var fileIsOk = false;
        var fileInProgress = false;

        var cancelUpload = function() {
            console.log("cancelable");
            if (isUploading) {
                try{
                    window.stop();
                } catch(e) {
                    document.execCommand('Stop');
                }
            }
        };

        $input.change(function () {
            var file = commandUtils.getInputFile($input[0]);
            if (file != null) {
                $uploadButton = $('.modal.in .modal-footer .btn-primary');
                $('.modal.in .modal-header .close').on('click', cancelUpload);

                $uploadButton.removeClass('disabled');
                fileIsOk = true;
                $form.find(".alert").remove();
                if (file.size > pageContext.attachments.maxSizeBytes) {
                    $uploadButton.addClass('disabled');
                    fileIsOk = false;
                    $input.after("<div class='alert alert-warning'>" + pageContext.i18n.uploadDialog.fileTooBig.replace("$size", commandUtils.getHumanReadableSize(pageContext.attachments.maxSizeBytes, true)) + "</div>");
                }
                var extension = file.name.toLowerCase().split('.').pop();
                if (extension == "gz") {
                    var fileParts = file.name.toLowerCase().split('.');
                    if (fileParts.length > 2 && fileParts[fileParts.length-2] == "tar") {
                        extension = "tar.gz";
                    }
                }
                if (((options.authorizeContext && options.authorizeContext.image) ? authorizedImageTypes : authorizedFileTypes).indexOf(extension) === -1) {
                     $uploadButton.addClass('disabled');
                     fileIsOk = false;
                    $input.after("<div class='alert alert-warning'>" + (options.authorizeContext.image ? pageContext.i18n.uploadDialog.invalidImageType : pageContext.i18n.uploadDialog.invalidAttachmentType) + "</div>");
                }
            }
        });
        var actions = {
            dialog: null,
            close: null,
            authorizeAndStart: function () {
                var trackingId = null;

                var $tracker = commandUtils.createUploadTracker(options.authorizeUrl, options.authorizeContext, {
                    onAuthorize: function (authorized, msg) {
                        if (authorized) {
                            trackingId = msg;
                            $form.attr('action', pageContext.url.uploadFile + '?trackingId=' + msg);
                            var $frame = $('<iframe name="uploaderFrame" style="display: none;"></iframe>');
                            $progressContainer.after($frame);
                            $form.submit();
                        } else {
                            actions.close();
                            commandUtils.showMessage(evt, msg);
                        }
                    },
                    onSuccess: function (data) {
                        function done() {
                            if (options.onSuccess) {
                                options.onSuccess(trackingId, data.result);
                                actions.close();
                            }
                        }

                        if (data.result.isImage && (options.disableCrop == undefined || !options.disableCrop)) {
                            var previewOptions = options.previewDialogOptions ? options.previewDialogOptions : {};
                            previewOptions.fileData = data.result;

                            if (previewOptions.beforeShow) {
                                var oldBeforeShow = options.beforeShow;

                                previewOptions.beforeShow = function ($dialog) {
                                    actions.close();
                                    oldBeforeShow($dialog);
                                }
                            } else {
                                previewOptions.beforeShow = function () {
                                    actions.close();
                                }
                            }

                            previewOptions.onSuccess = function () {
                                done();
                            }

                            commandUtils.showPreviewAndCropDialog(evt, previewOptions);

                        } else {
                            done();
                        }
                    },
                    onError: function (data) {
                        if (options.onError) {
                            options.onError();
                        }

                        if (data.errors && data.errors.error) {
                            actions.close();
                            commandUtils.showMessage(evt, data.errors.error);
                        }
                    }
                });

                if (!isUploading) {
                    $progressContainer.append($tracker);
                    isUploading = true;
                }
            }
        };

        doptions.yes_callback = function ($dialog, close) {
            if (!fileIsOk || isUploading) return;
            actions.close = close;
            actions.dialog = $dialog;

            $uploadButton = $('.modal.in .modal-footer .btn-primary');
            $uploadButton.addClass('disabled');

            if (options.yes_callback) {
                options.yes_callback($dialog, close, actions);
            } else {
                actions.authorizeAndStart();
            }
        };

        doptions.no_callback = function($dialog, close) {
            cancelUpload();
            actions.close = close;
            actions.dialog = $dialog;
        };

        if (options.dialogContext) {
            $.extend(doptions, options.dialogContext);
        }
        this.showDialog(doptions);
    },

    createPreviewAndCropDialogNodes: function () {
        var $nodes = $('<div></div>');

        var $table = $('<table>' +
            '<tr><td style="padding: 5px; border: 1px solid black;">' +
            '<img class="previewEditor" style="max-width: 500px; max-height: 500px;" src="" />' +
            '</td>' + /**<td>' +
         '<div style="width:100px;height:100px;overflow:hidden;">' +
         '<img class="finalPreview" width="100" height="100" style="width: 100px; height: 100px; border: 1px solid black;" src="" />' +
         '</div></td>' +*/
            '</tr></table>');

        $nodes.append($table);
        return $nodes;
    },

    jcropLoaded: false,

    showPreviewAndCropDialog: function (evt, options) {
        var doptions = {
            nodes: commandUtils.getDialogNodes(options, commandUtils.createPreviewAndCropDialogNodes, pageContext.i18n.previewAndCropDialog),
            title: pageContext.i18n.previewAndCropDialog.previewAndResize,
            yes_text: pageContext.i18n.previewAndCropDialog.accept,
            show_no: true
        };

        var $imageEditor = doptions.nodes.find(options.editor ? options.editor : '.previewEditor');
        var $imagePreview = doptions.nodes.find(options.preview ? options.preview : '.finalPreview');

        var data = {
            'file': options.fileData.fileId,
            x: 0,
            y: 0,
            w: 0,
            h: 0
        };

        function showPreview(coords) {
            var rx = 100 / coords.w;
            var ry = 100 / coords.h;

            $imagePreview.css({
                width: Math.round(rx * 500) + 'px',
                height: Math.round(ry * 500) + 'px',
                marginLeft: '-' + Math.round(rx * coords.x) + 'px',
                marginTop: '-' + Math.round(ry * coords.y) + 'px'
            });

            data.x = coords.x;
            data.y = coords.y;
            data.w = coords.w;
            data.h = coords.h;
        }

        doptions.yes_callback = function ($dialog, close) {
            data.refWidth = $imageEditor.width();
            data.refHeight = $imageEditor.height();

            $.ajax({
                type: 'POST',
                url: pageContext.url.cropUpload,
                data: data,
                success: function (data) {
                    if (data.success) {
                        close();

                        if (data.result.newSize) {
                            options.fileData.size = data.result.newSize;
                        }

                        if (options.onSuccess) {
                            options.onSuccess();
                        }
                    } else {
                        if (data.errors && data.errors.image) {
                            close();
                            commandUtils.showMessage(evt, data.errors.image);
                        }
                    }
                },
                dataType: 'json'
            });
        };

        //var uploadPreviewUrl =  pageContext.url.uploadPreview + '?file=' + options.file + '&size=' + (options.editorSize ? options.editorSize : 500);

        if (options) {
            $.extend(options, doptions);
            doptions = options;
        }

        var noCacheImageUrl = options.fileData.url + "?noCache=" + (new Date().getTime() + "" + Math.floor(Math.random() * 1001));

        commandUtils.preloadImage(noCacheImageUrl, function () {
            $imageEditor.attr('src', noCacheImageUrl);
            $imagePreview.attr('src', noCacheImageUrl);

            commandUtils.showDialog(doptions);

            function setupEditor() {
                commandUtils.jcropLoaded = true;

                var jcropOptions = {
                    onChange: showPreview,
                    onSelect: showPreview
                };

                if (options.forceSquare) {
                    jcropOptions.aspectRatio = 1;
                }

                $imageEditor.Jcrop(jcropOptions);
            }

            if (!commandUtils.jcropLoaded) {
                commandUtils.loadExtraScript(pageContext.extraScripts.jcrop, setupEditor);
            } else {
                setupEditor();
            }
        });
    },

    showMessage: function (evt, msg, callback, title) {
        msg = msg.replace("\n", "<br />");
        msg = msg.replace(new RegExp(pageContext.i18n.login, "ig"), '<a href="' + pageContext.url.login + '">' + pageContext.i18n.login + '</a>');
        msg = msg.replace(new RegExp(pageContext.i18n.register, "ig"), '<a href="' + pageContext.url.register + '">' + pageContext.i18n.register + '</a>');

        return this.showDialog({
            nodes: $('<span>' + msg + '</span>'),
            extra_class: 'warning',
            event: evt,
            title: title,
            yes_callback: function ($dialog, close) {
                close();
                if (callback) {
                    callback();
                }
            },
            close_on_clickoutside: true
        });
    },

    showConfirmation: function (evt, title, msg, callback) {
        return this.showDialog({
            event: evt,
            title: title ? title : '',
            nodes: $('<center>' + (msg ? msg : pageContext.i18n.confirm) + '</center>'),
            extra_class: 'prompt',
            show_no: true,
            no_test: pageContext.i18n.no,
            yes_text: pageContext.i18n.yes,
            yes_callback: function ($dialog, close) {
                if (callback) {
                    callback();
                }

                close();
            }
        });
    },

    showPrompt: function (evt, tpl, context, options) {
        var doptions = {
            nodes: commandUtils.renderTemplate(tpl, context),
            extra_class: 'prompt',
            yes_callback: function ($dialog, close) {
                var data = commandUtils.extractFormData($dialog);
                var result = true;
                if (options.onOk != undefined) {
                    result = options.onOk(data);
                }
                if (result !== false) {
                    close();
                }
            },
            show_no: true
        };

        if (options) {
            $.extend(options, doptions);
        } else {
            options = doptions;
        }

        if (options.centered == undefined || !options.centered) {
            options.event = evt;
        }

        return this.showDialog(options);
    },

    extractFormData: function ($el) {
        var ret = {};
        var data = null;
        if ($el.is('form')) {
            data = $el.serializeArray();
        } else {
            data = $el.find('form').serializeArray();
        }

        for (var i = 0; i < data.length; i++) {
            if (ret[data[i].name]) {
                var old = ret[data[i].name];
                if (old.constructor == Array) {
                    old.push(data[i].value);
                } else {
                    var a = new Array();
                    a.push(old);
                    a.push(data[i].value);
                    ret[data[i].name] = a;
                }
            } else {
                ret[data[i].name] = data[i].value;
            }
        }

        return ret;
    },

    fillFormData: function ($form, values) {
        $form.find(':text, :password, :file, textarea').each(function () {
            var $input = $(this);
            $input.val(values[$input.attr('name') ? $input.attr('name') : '']);
        });

        $form.find('input[type=radio], input[type=checkbox], option').each(function () {
            var $input = $(this);
            var name = this.tagName.toUpperCase() == 'OPTION' ? $input.parents('select').attr('name') : $input.attr('name');
            var value = values[name];

            if (value && (
                (value.constructor == Array && $.inArray($input.val(), value) >= 0) ||
                    (value == $input.val())) || (value === true)) {

                $input.attr('checked', 'checked').attr('selected', 'selected');
            } else {
                $input.removeAttr('checked').removeAttr('selected');
            }
        });
    },

    friendlyDate: function (toParse, def) {
        var dif = null;
        var date = null;
        var parsed = null;

        var now = Date.today().setTimeToNow();

        if (toParse.constructor == Date) {
            date = toParse;
        } else {
            var negateServerOffset = false;
            var serverOffset = 0;

            var splitted = toParse.split("+");

            if (splitted.length != 2) {
                splitted = toParse.split("-");
                negateServerOffset = true;
            }

            if (splitted.length == 2) {
                serverOffset = parseInt(splitted[1], 10) / 100;
                toParse = splitted[0];
            }

            var viewerOffset = parseInt(new Date().getUTCOffset(), 10) / 100;

            if (negateServerOffset) serverOffset = (0 - serverOffset);
            date = Date.parse(toParse).addHours(viewerOffset - serverOffset);
        }

        dif = new TimeSpan(now - date);

//        alert("pageContext.useRelativeTime" + pageContext.useRelativeTime)
        if (dif.getDays() > 10 || pageContext.useRelativeTime != true) {
            if (def) {
                parsed = def;
            } else {
                if (dif.getDays() >= 365) {
                    parsed = date.toString("MMM dd 'yy");
                } else {
                    parsed = date.toString("MMM dd")
                }
                parsed = parsed + " " + pageContext.i18n.timeAt + " " + date.toString("h:mm tt");
            }
        } else {
            if (dif.getDays() > 1) {
                parsed = dif.getDays() + ' ' + pageContext.i18n.days;
            } else if (dif.getDays() == 1) {
                parsed = '1 ' + pageContext.i18n.day;
            } else if (dif.getHours() > 1) {
                parsed = dif.getHours() + ' ' + pageContext.i18n.hours;
            } else if (dif.getHours() == 1) {
                parsed = '1 ' + pageContext.i18n.hour;
            } else if (dif.getMinutes() > 1) {
                parsed = dif.getMinutes() + ' ' + pageContext.i18n.minutes;
            } else if (dif.getMinutes() == 1) {
                parsed = '1 ' + pageContext.i18n.minute;
            } else if (dif.getSeconds() > 1) {
                parsed = dif.getSeconds() + ' ' + pageContext.i18n.seconds;
            } else if (dif.getSeconds() == 1) {
                parsed = '1 ' + pageContext.i18n.second;
            } else {
                parsed = '0 ' + pageContext.i18n.seconds;
            }

            parsed = pageContext.i18n.timeAgo.replace('{0}', parsed);
        }

        return parsed;
    },

    generateUploadTrackingCode: function () {
        return new Date().getTime() + "" + Math.floor(Math.random() * 1001)
    },

    decode: function(s) {
        return decodeURIComponent(s.replace( /\+/g, ' '));
    },

    decodeAndParse: function(s) {

        var pluses = /\+/g;

        if (s.indexOf('"') === 0) {
            // This is a quoted cookie as according to RFC2068, unescape...
            s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
        }

        s = this.decode(s);

        return s;
    },

    getCookie: function(key) {

        var cookies = document.cookie.split('; ');
        var result = key ? undefined : {};

        for (var i = 0, l = cookies.length; i < l; i++) {
            var parts = cookies[i].split('=');
            var name = this.decode(parts.shift());
            var cookie = parts.join('=');

            if (key && key === name) {
                result = this.decodeAndParse(cookie);
                break;
            }

            if (!key) {
                result[name] = this.decodeAndParse(cookie);
            }
        }

        return result;
    },
    setCookie: function(key, value, options) {

        if (!options) {
            options = {};
        }

        if (typeof options.expires === 'number') {
            var days = options.expires, t = options.expires = new Date();
            t.setDate(t.getDate() + days);
        }

        value = "" + value;

        return (document.cookie = [
            encodeURIComponent(key),
            '=',
            encodeURIComponent(value),
            options.expires ? '; expires=' + options.expires.toUTCString() : '; expires=-1',
            options.path ? '; path=' + options.path : ': path=/',
            options.domain ? '; domain=' + options.domain : '',
            options.secure ? '; secure' : ''
        ].join(''));
    }
};

$(function ($) {
    commandUtils.initializeLabels();

    $(document).on('click', "*[command]", function (evt) {
        var parser = commandUtils.extractCommand($(this));
        if (parser) {
            $('.context-menu-dropdown').slideUp('fast');
            parser.execute(evt);
        }
        return false;
    });

    //forms initialization anti csrf

    function checkFormsForCSRFToken() {
        $('form').each(function() {
            var $form = $(this);

            if ($form.attr('method') && $form.attr('method').toUpperCase() == 'POST' && $form.find('input[name=TH_CSRF]').length == 0) {
                $form.prepend('<input type="hidden" name="TH_CSRF" value="' + pageContext.additional.TH_CSRF +'" />');
            }
        });
    }

    //we create some dynamic forms, better check every once in a while if those have the token
    function startFormCheckTimeout() {
        window.setTimeout(function() {
            checkFormsForCSRFToken();
            startFormCheckTimeout();
        }, 1000);
    }

    checkFormsForCSRFToken();
    startFormCheckTimeout();

    //ajax anti csrf setup

    $(document).ajaxSend(function(elm, xhr, s){
        if (s.type && s.type.toUpperCase() == "POST") {
            xhr.setRequestHeader('X-TH-CSRF', pageContext.additional.TH_CSRF);
        }
    });

    //tell the server about js support

    try {
        var jsSupportCookie = commandUtils.getCookie("TH_JS_SUPPORT");

        if (!jsSupportCookie) {
            $.get(pageContext.url.trackJs);
        }
    } catch(e) {
        console.log(e);
        //support is flaky, maybe just ignore this
    }
});

(function ($) {
    $.fn.dataAttributes = function () {
        var attributes = {};

        if (!this.length)
            return this;

        $.each(this[0].attributes, function (index, attr) {
            if (/^data\-/.test(attr.nodeName)) {
                attributes[attr.nodeName.substr(5)] = attr.nodeValue;
            }
        });

        return attributes;
    }
})(jQuery);

if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    }
}

(function ($) {

    $(document).on('autocompleteopen', ".ui-autocomplete-input", function () {
        var autocomplete = $(this).data("uiAutocomplete"),
            menu = autocomplete.menu;

        if (!autocomplete.options.autoFocus) {
            return;
        }

        if (autocomplete.term != $(this).val()) {
            return;
        }

        menu.options.blur = function (event, ui) {
            return
        }
        menu.activate($.Event({ type: "mouseenter" }), menu.element.children().first());
    });


}(jQuery));

register_command('resendEmailValidation', {
    execute: function (evt) {
        this.confirm(evt, pageContext.i18n.emailValidationPrompt, pageContext.i18n.emailValidationPromptBody);
    },

    onSuccess: function (data) {
        commandUtils.showMessage(null, data.result.success);
    }
});

register_command('follow', {
    execute: function (evt) {
        var parser = this;
        $.ajax({
            url: (this.element.hasClass("on") ? pageContext.url.unfollow : pageContext.url.follow).replace("%7BobjId%7D", this.element.attr("nodeId")).replace("%7Btype%7D", this.element.attr("data-node-type")),
            cache: false,
            success: function (data) {
                parser.onSuccess(data,evt);
            },
            error: function(data){
                if(data.status == 401) {
                    window.location = pageContext.url.login;
                }
            }
        })
    },
    onSuccess: function (data,evt) {
        $this = $(evt.target);
        if ($this.hasClass("on")) {
            $this.removeClass("on");
        } else {
            $this.addClass("on");
        }
        this.updateLinkText();
    },
    updateLinkText: function () {
        $("[command='follow']").each(function () {
            var $btn = $(this);
            if ($btn.hasClass("on")) {
                if ($btn.hasClass("btn")) {
                    $btn.addClass("btn-info");
                    $btn.mouseenter(function () {
                        $btn.addClass("btn-danger");
                        $btn.removeClass("btn-info");
                        $btn.html(pageContext.i18n.unfollow);
                    }).mouseleave(function () {
                            $btn.removeClass("btn-danger");
                            $btn.addClass("btn-info");
                            $btn.html(pageContext.i18n.following);
                        });
                    $btn.html(pageContext.i18n.following);
                } else {
                    $btn.html(pageContext.i18n.unfollow);
                }
            } else {
                if ($btn.hasClass("btn")) {
                    $btn.removeClass("btn-info");
                    $btn.removeClass("btn-danger");
                    $btn.unbind("mouseenter");
                    $btn.unbind("mouseleave");
                }
                $btn.html("<i class='icon-plus'></i> " + pageContext.i18n.follow);
            }
        });
    }
});

register_command('deleteAllPosts', {
    execute: function(evt) {
        this.confirm(evt, null);
    },
    onSuccess: function(data) {
        commandUtils.showMessage(null, data.result.success);
    }
});
