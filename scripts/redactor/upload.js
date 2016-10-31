if (typeof RedactorPlugins === 'undefined') var RedactorPlugins = {};

RedactorPlugins.upload = {
    init: function () {
        var plugin = this;
        var timeout;

        var attachments = null;
        if (typeof window.getAuthorizeContext != 'undefined') {
            if (this.opts.attachments === undefined) {
                attachments = {
                    authorize: getAuthorizeContext,
                    toForm: addAttachmentToForm
                };
            } else {
                attachments = this.opts.attachments;
            }
        }

        this.opts.pasteAfterCallback = function(text) {
            clearTimeout(timeout);
            timeout = setTimeout(function() {
                plugin.parseImages(plugin, attachments);
            }, 500);
            return text;
        };

        this.doImageBtn(attachments);
        this.doFileBtn(attachments);

    },
    parseImages: function(plugin, attachments) {

        var uploadFileToTheServer = function(uploadFile, img) {
            var trackingId = null;

            var $tracker = commandUtils.createUploadTracker(pageContext.url.authorizeAttachmentsUrl, attachments.authorize(true), {
                onAuthorize: function (authorized, msg) {
                    if (authorized) {
                        trackingId = msg;
                        var formData = new FormData();
                        var request = new XMLHttpRequest();
                        formData.append("file", uploadFile, uploadFile.name);
                        request.open("POST", pageContext.url.uploadFile + '?trackingId=' + msg);
                        request.send(formData);
                    } else {
                        commandUtils.showMessage(evt, msg);
                    }
                },
                onSuccess: function(data) {
                    img.setAttribute('src', data.result.url);
                    addAttachmentToForm(data.result);
                    plugin.insertHtml('', true);
                },
                onError: function (data) {
                    // remove img on error
                    // img.parentNode.removeChild(img);
                    // console.log('data: ', data);
                }
            });
        };


        // Turn base64 data into a Blob
        function base64toBlob(b64Data, contentType, sliceSize) {
            contentType = contentType || '';
            sliceSize = sliceSize || 512;
            var byteCharacters = atob(b64Data);
            var byteArrays = [];
            for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                var slice = byteCharacters.slice(offset, offset + sliceSize);
                var byteNumbers = new Array(slice.length);
                for (var i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }
                byteArrays.push(new Uint8Array(byteNumbers));
            }
            return new Blob(byteArrays, {
                type : contentType
            });
        }

        function getMimeType(header) {
            var type = '';
            switch (header) {
                case "89504e47":
                    type = "image/png";
                    break;
                case "47494638":
                    type = "image/gif";
                    break;
                case "ffd8ffe0":
                case "ffd8ffe1":
                case "ffd8ffe2":
                    type = "image/jpeg";
                    break;
                default:
                    type = blob.type;
                    break;
            }
            return type;
        }

        function parseImgAttr(src) {
            var arr = src.split(",");
            var data = arr[1];
            var contentType = arr[0].split(";")[0].split(":")[1];
            if (contentType.indexOf('image') !== 0) return null;
            var extension = contentType.split('/')[1];
            var blob = base64toBlob(data, contentType, 512);
            blob.name = getName() + '.' + extension;
            return blob;
        }

        function getName() {
            var text = "";
            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            for( var i=0; i < 5; i++ ) {
                text += possible.charAt(Math.floor(Math.random() * possible.length));
            }
            return text;
        }

        function verifyBlobMimeType(blob, img) {
            var fileReader = new FileReader();
            fileReader.onloadend = function(e) {
                var arr = (new Uint8Array(e.target.result)).subarray(0, 4);
                var header = "";
                for(var i = 0; i < arr.length; i++) {
                   header += arr[i].toString(16);
                }
                var realMimeType = getMimeType(header);
                if (realMimeType !== blob.type) {
                    blob = blob.slice(0, blob.size, realMimeType);
                    var extension = realMimeType.split('/')[1];
                    blob.name = getName() + '.' + extension;
                }
                uploadFileToTheServer(blob, img);
            };
            fileReader.readAsArrayBuffer(blob);
        }

        var imgs = plugin.$editor.find('img');
        for (var i = 0, len = imgs.length; i < len; i += 1) {
            var img = imgs[i];
            var src = img.src;
            if (src.split(':')[0] !== 'data') continue;
            var blob = parseImgAttr(src);
            if (blob !== null) {
                verifyBlobMimeType(blob, img);
            }
        }
    },

    doImageBtn: function (attachments) {
        this.buttonRemove('image');
        var thiz = this;
        this.buttonAdd('image', pageContext.i18n.toolTipsInsertImage, function (event, button_key) {
            thiz.selectionSave();
            commandUtils.showUploadDialog(null, {
                authorizeUrl: pageContext.url.authorizeAttachmentsUrl,
                authorizeContext: attachments.authorize(true),
                onSuccess: function (tid, data) {
                    attachments.toForm(data);
                    thiz.selectionRestore();
                    thiz.imageInsert("<p><img id='" + data.fileId + "' src='" + data.url + "' /></p>", true);
                }
            });
        });
    },
    doFileBtn: function (attachments) {
        this.buttonRemove('file');
        var thiz = this;
        this.buttonAdd('file', pageContext.i18n.toolTipsInsertFile, function (event, button_key) {
            thiz.selectionSave();
            commandUtils.showUploadDialog(null, {
                authorizeUrl: pageContext.url.authorizeAttachmentsUrl,
                authorizeContext: attachments.authorize(false),
                onSuccess: function (tid, data) {
                    attachments.toForm(data);
                    thiz.selectionRestore();
                    thiz.insertHtml("<a id='" + data.fileId + "' href='" + data.url + "'>" + data.fileName + "</a>");
                }
            });
        });
    }
};

(function ($) {
    $.event.special.destroyed = {
        remove: function (o) {
            if (o.handler) {
                o.handler()
            }
        }
    }
})(jQuery);

RedactorPlugins.autotaguser = {

    init: function () {

        var redactor = this;
        window.rdt = redactor;
        var nodeId;
        var checkPre = true;
        var oldChangeCallback = null;

//        if (typeof this.opts.changeCallback === "function") {
        if ($.isFunction(this.opts.changeCallback)) {
            oldChangeCallback = this.opts.changeCallback;
        }

        this.opts.changeCallback = function (e) {
            if (checkPre) {
                var $parentNode = $(redactor.getParent());
                $('div.redactor_redactor').find('pre').each(function () {
                    var text = $(this).text();
                    $(this).text(text);
                });
            }

            checkPre = true;

            if ($.isFunction(oldChangeCallback)) {
                oldChangeCallback(e);
            }
        }

        if ($('.question-container').length) {
            nodeId = $('.question-container').find('.control-bar').attr('nodeid');
        } else if ($('#answer-form').length && $('#question').length) {
            nodeId = $('#question').val();
        }

        this.$editor.keypress(function (e) {
            checkPre = false;
            var $parentNode = $(redactor.getParent());

            var pre = $('div.redactor_redactor').find('pre');
            if('PRE' == redactor.getBlock().nodeName)
            {
                return true;
            }

            if (checkAutoComplete(e)) {
                e.preventDefault();
                return false;
            }

            return checkAutoCompleteTyping(e, true);
        });

        var oldKeyUpCallBack = function (e) {
        };

        if (typeof this.opts.keyupCallback === "function") {
            oldKeyUpCallBack = this.opts.keyupCallback;
        }

        this.opts.keyupCallback = function (e) {
            checkPre = false;

            var $parentNode = $(redactor.getParent());

            if($parentNode.context != null && $parentNode.context.parentNode && 'PRE' == $parentNode.context.parentNode.nodeName)
            {
                return false;
            }

            if (!$parentNode.hasClass('autotaguser-autocomplete-box')) {
                oldKeyUpCallBack(e);
                return;
            }

            oldKeyUpCallBack(e);
            return checkAutoCompleteTyping(e, false);
        }

        var oldKeyDownCallBack = function (e) {
        };

        if (typeof this.opts.keydownCallback === "function") {
            oldKeyDownCallBack = this.opts.keydownCallback;
        }

        this.opts.keydownCallback = function (e) {
            checkPre = false;
            var $parentNode = $(redactor.getParent());

            if($parentNode.context != null && $parentNode.context.parentNode && 'PRE' == $parentNode.context.parentNode.nodeName)
            {
                return true;
            }

            oldKeyDownCallBack(e);

            if (!$parentNode.hasClass('autotaguser-autocomplete-box')) {
                return;
            }

            oldKeyDownCallBack(e);

            var key = e.keyCode || e.which;

            if (key == 8) {
                return checkAutoCompleteTyping(e, false);
            }
        }

        function checkAutoComplete(e) {

            var $parentNode = $(redactor.getParent());

            if($parentNode.context != null && $parentNode.context.nodeName == 'PRE'){
                return false;
            }

            var key = e.keyCode || e.which;
            var char = e.charCode;

            if (key != 8 && char == 64 && !$.trim(getCharacterPrecedingCaret(redactor))) {
                createAutoComplete();
                return true;
            }

            return false;
        }

        function checkAutoCompleteTyping(e, keypress) {
            var $parentNode = $(redactor.getParent());

            if (!$parentNode.hasClass('autotaguser-autocomplete-box') &&
                !$parentNode.find('.autotaguser-autocomplete-box').length) {
                return;
            }

            var key = e.keyCode || e.which;

            var checkNavigation = redactor.browser('mozilla') ? keypress : !keypress;
            var checkText = redactor.browser('mozilla') ? !keypress || key == 8 : !keypress;

            if (checkNavigation && (key == 38 || key == 40 || key == 27 || key == 13 || key == 9)) {
                e.preventDefault();
                var e = jQuery.Event("keydown");
                e.which = key;
                e.keyCode = key;

                $parentNode.find('input').trigger(e);
                return false;
            } else if (checkText) {
                var text = $parentNode.text();

                if (text && key == 8) {
                    if($parentNode.context != null && $parentNode.context.nodeName == 'PRE'){
                        return false;
                    }
                    text = text.substring(0, text.length - 1);
                }

                if (!$.trim(text)) {
                    $parentNode.data('breakOut')();
                    return true;
                }

                text = $.trim(text).substring(1);

                var oldValue = $parentNode.data('oldValue');

                if (oldValue != text) {

                    var singleResult = $parentNode.data('single-result');

                    if (singleResult && text == singleResult.label) {
                        $parentNode.data('saveValue')(singleResult);
                    } else {

                        var noResultSearches = $parentNode.data('no-result-searches');

                        if (noResultSearches && noResultSearches > 2) {
                            $parentNode.data('breakOut')();
                        } else {
                            $parentNode.find('input').autocomplete('search', text);
                            $parentNode.data('oldValue', text);
                        }
                    }
                }
            }
            return true;
        }

        /**
         * functions to manipulate with the editor
         */

        function getCharacterPrecedingCaret(redactor) {
            var containerEl = redactor.$editor[0];

            var precedingChar = "", sel, range, precedingRange;

            var re = /[\0-\x1F\x7F-\x9F\xAD\u0378\u0379\u037F-\u0383\u038B\u038D\u03A2\u0528-\u0530\u0557\u0558\u0560\u0588\u058B-\u058E\u0590\u05C8-\u05CF\u05EB-\u05EF\u05F5-\u0605\u061C\u061D\u06DD\u070E\u070F\u074B\u074C\u07B2-\u07BF\u07FB-\u07FF\u082E\u082F\u083F\u085C\u085D\u085F-\u089F\u08A1\u08AD-\u08E3\u08FF\u0978\u0980\u0984\u098D\u098E\u0991\u0992\u09A9\u09B1\u09B3-\u09B5\u09BA\u09BB\u09C5\u09C6\u09C9\u09CA\u09CF-\u09D6\u09D8-\u09DB\u09DE\u09E4\u09E5\u09FC-\u0A00\u0A04\u0A0B-\u0A0E\u0A11\u0A12\u0A29\u0A31\u0A34\u0A37\u0A3A\u0A3B\u0A3D\u0A43-\u0A46\u0A49\u0A4A\u0A4E-\u0A50\u0A52-\u0A58\u0A5D\u0A5F-\u0A65\u0A76-\u0A80\u0A84\u0A8E\u0A92\u0AA9\u0AB1\u0AB4\u0ABA\u0ABB\u0AC6\u0ACA\u0ACE\u0ACF\u0AD1-\u0ADF\u0AE4\u0AE5\u0AF2-\u0B00\u0B04\u0B0D\u0B0E\u0B11\u0B12\u0B29\u0B31\u0B34\u0B3A\u0B3B\u0B45\u0B46\u0B49\u0B4A\u0B4E-\u0B55\u0B58-\u0B5B\u0B5E\u0B64\u0B65\u0B78-\u0B81\u0B84\u0B8B-\u0B8D\u0B91\u0B96-\u0B98\u0B9B\u0B9D\u0BA0-\u0BA2\u0BA5-\u0BA7\u0BAB-\u0BAD\u0BBA-\u0BBD\u0BC3-\u0BC5\u0BC9\u0BCE\u0BCF\u0BD1-\u0BD6\u0BD8-\u0BE5\u0BFB-\u0C00\u0C04\u0C0D\u0C11\u0C29\u0C34\u0C3A-\u0C3C\u0C45\u0C49\u0C4E-\u0C54\u0C57\u0C5A-\u0C5F\u0C64\u0C65\u0C70-\u0C77\u0C80\u0C81\u0C84\u0C8D\u0C91\u0CA9\u0CB4\u0CBA\u0CBB\u0CC5\u0CC9\u0CCE-\u0CD4\u0CD7-\u0CDD\u0CDF\u0CE4\u0CE5\u0CF0\u0CF3-\u0D01\u0D04\u0D0D\u0D11\u0D3B\u0D3C\u0D45\u0D49\u0D4F-\u0D56\u0D58-\u0D5F\u0D64\u0D65\u0D76-\u0D78\u0D80\u0D81\u0D84\u0D97-\u0D99\u0DB2\u0DBC\u0DBE\u0DBF\u0DC7-\u0DC9\u0DCB-\u0DCE\u0DD5\u0DD7\u0DE0-\u0DF1\u0DF5-\u0E00\u0E3B-\u0E3E\u0E5C-\u0E80\u0E83\u0E85\u0E86\u0E89\u0E8B\u0E8C\u0E8E-\u0E93\u0E98\u0EA0\u0EA4\u0EA6\u0EA8\u0EA9\u0EAC\u0EBA\u0EBE\u0EBF\u0EC5\u0EC7\u0ECE\u0ECF\u0EDA\u0EDB\u0EE0-\u0EFF\u0F48\u0F6D-\u0F70\u0F98\u0FBD\u0FCD\u0FDB-\u0FFF\u10C6\u10C8-\u10CC\u10CE\u10CF\u1249\u124E\u124F\u1257\u1259\u125E\u125F\u1289\u128E\u128F\u12B1\u12B6\u12B7\u12BF\u12C1\u12C6\u12C7\u12D7\u1311\u1316\u1317\u135B\u135C\u137D-\u137F\u139A-\u139F\u13F5-\u13FF\u169D-\u169F\u16F1-\u16FF\u170D\u1715-\u171F\u1737-\u173F\u1754-\u175F\u176D\u1771\u1774-\u177F\u17DE\u17DF\u17EA-\u17EF\u17FA-\u17FF\u180F\u181A-\u181F\u1878-\u187F\u18AB-\u18AF\u18F6-\u18FF\u191D-\u191F\u192C-\u192F\u193C-\u193F\u1941-\u1943\u196E\u196F\u1975-\u197F\u19AC-\u19AF\u19CA-\u19CF\u19DB-\u19DD\u1A1C\u1A1D\u1A5F\u1A7D\u1A7E\u1A8A-\u1A8F\u1A9A-\u1A9F\u1AAE-\u1AFF\u1B4C-\u1B4F\u1B7D-\u1B7F\u1BF4-\u1BFB\u1C38-\u1C3A\u1C4A-\u1C4C\u1C80-\u1CBF\u1CC8-\u1CCF\u1CF7-\u1CFF\u1DE7-\u1DFB\u1F16\u1F17\u1F1E\u1F1F\u1F46\u1F47\u1F4E\u1F4F\u1F58\u1F5A\u1F5C\u1F5E\u1F7E\u1F7F\u1FB5\u1FC5\u1FD4\u1FD5\u1FDC\u1FF0\u1FF1\u1FF5\u1FFF\u200B-\u200F\u202A-\u202E\u2060-\u206F\u2072\u2073\u208F\u209D-\u209F\u20BB-\u20CF\u20F1-\u20FF\u218A-\u218F\u23F4-\u23FF\u2427-\u243F\u244B-\u245F\u2700\u2B4D-\u2B4F\u2B5A-\u2BFF\u2C2F\u2C5F\u2CF4-\u2CF8\u2D26\u2D28-\u2D2C\u2D2E\u2D2F\u2D68-\u2D6E\u2D71-\u2D7E\u2D97-\u2D9F\u2DA7\u2DAF\u2DB7\u2DBF\u2DC7\u2DCF\u2DD7\u2DDF\u2E3C-\u2E7F\u2E9A\u2EF4-\u2EFF\u2FD6-\u2FEF\u2FFC-\u2FFF\u3040\u3097\u3098\u3100-\u3104\u312E-\u3130\u318F\u31BB-\u31BF\u31E4-\u31EF\u321F\u32FF\u4DB6-\u4DBF\u9FCD-\u9FFF\uA48D-\uA48F\uA4C7-\uA4CF\uA62C-\uA63F\uA698-\uA69E\uA6F8-\uA6FF\uA78F\uA794-\uA79F\uA7AB-\uA7F7\uA82C-\uA82F\uA83A-\uA83F\uA878-\uA87F\uA8C5-\uA8CD\uA8DA-\uA8DF\uA8FC-\uA8FF\uA954-\uA95E\uA97D-\uA97F\uA9CE\uA9DA-\uA9DD\uA9E0-\uA9FF\uAA37-\uAA3F\uAA4E\uAA4F\uAA5A\uAA5B\uAA7C-\uAA7F\uAAC3-\uAADA\uAAF7-\uAB00\uAB07\uAB08\uAB0F\uAB10\uAB17-\uAB1F\uAB27\uAB2F-\uABBF\uABEE\uABEF\uABFA-\uABFF\uD7A4-\uD7AF\uD7C7-\uD7CA\uD7FC-\uF8FF\uFA6E\uFA6F\uFADA-\uFAFF\uFB07-\uFB12\uFB18-\uFB1C\uFB37\uFB3D\uFB3F\uFB42\uFB45\uFBC2-\uFBD2\uFD40-\uFD4F\uFD90\uFD91\uFDC8-\uFDEF\uFDFE\uFDFF\uFE1A-\uFE1F\uFE27-\uFE2F\uFE53\uFE67\uFE6C-\uFE6F\uFE75\uFEFD-\uFF00\uFFBF-\uFFC1\uFFC8\uFFC9\uFFD0\uFFD1\uFFD8\uFFD9\uFFDD-\uFFDF\uFFE7\uFFEF-\uFFFB\uFFFE\uFFFF]/g;

            if (window.getSelection) {

                sel = window.getSelection();

                if (sel.rangeCount > 0) {
                    range = sel.getRangeAt(0).cloneRange();
                    range.collapse(true);
                    range.setStart(containerEl, 0);
                    precedingChar = range.toString().replace("\\p{C}","").slice(-1);
                }

            } else if ((sel = document.selection) && sel.type != "Control") {
                range = sel.createRange();
                precedingRange = range.duplicate();
                precedingRange.moveToElementText(containerEl);
                precedingRange.setEndPoint("EndToStart", range);
                precedingChar = precedingRange.text.replace("\\p{C}","").slice(-1);
            }

            return precedingChar;
        }

        function moveCaretToEndOfElement(element) {
            var range, selection;
            if (document.createRange) {
                range = document.createRange();
                range.selectNodeContents(element);
                range.collapse(false);
                selection = window.getSelection();
                selection.removeAllRanges();
                selection.addRange(range);
            } else if (document.selection) {
                range = document.body.createTextRange();
                range.moveToElementText(element);
                range.collapse(false);
                range.select();
            }
        }

        /**
         * autocomplete manipulation
         */

        function destroyAutoComplete($el) {
            //$el.find('input').autocomplete('close');
            //$el.find('input').autocomplete('destroy');
        }

        function createAutoComplete() {
            var $autocomplete = $('<inline class="autotaguser-autocomplete-box">@<input type="text" /></inline>');

            $autocomplete.bind('destroyed', function () {
                destroyAutoComplete($autocomplete);
            });

            function clearTopNode($node) {
                var $children = $node.children();

                if ($children.length &&
                    $children[$children.length - 1].tagName.toUpperCase() == 'BR') {

                    $($children[$children.length - 1]).remove();

                    $node.html($node.html() + ' ');
                }
            }

            function breakOut() {
                var value = $autocomplete.text();

                var $topNode = $autocomplete.parent();

                $autocomplete.after(value);

                destroyAutoComplete($autocomplete);

                $autocomplete.remove();

                clearTopNode($topNode);

                moveCaretToEndOfElement($topNode[0]);
            }

            $autocomplete.data('breakOut', breakOut);

            function saveValue(item) {

                var object = item.object;

                var $nodeToInsert = $('<a nodeid="' + object.id + '" rel="user" href="#">@' + item.label + '</a>');

                var $topNode = $autocomplete.parent();

                $autocomplete.after($nodeToInsert);

                destroyAutoComplete($autocomplete);

                $autocomplete.remove();
                clearTopNode($topNode);

                moveCaretToEndOfElement($topNode[0]);
            }

            $autocomplete.data('saveValue', saveValue);

            var autoCompleteCache = {};

            $autocomplete.find('input').autocomplete({
                source: function (request, response) {

                    var term = request.term;

                    if (autoCompleteCache[term] !== undefined) {
                        response(autoCompleteCache[term]);
                        return;
                    }

                    var url;
                    var data;

                    if (nodeId) {
                        url = pageContext.url.mentionsSearch;
                        data = {
                            'q': term,
                            'node': nodeId
                        }
                    } else {
                        url = pageContext.url.usersSearch;
                        data = {
                            'q': term,
                            'page': 1,
                            'pageSize': 10
                        }
                    }

                    $.ajax({
                        'url': url,
                        'dataType': 'json',
                        'data': data,
                        success: function (data) {

                            var results = $.map(data.result, function (item, index) {

                                var label;

                                if (pageContext.userRealName && item.realname) {
                                    label = item.realname;
                                } else {
                                    label = item.username;
                                }

                                return {
                                    'label': label,
                                    'value': item.id,
                                    'object': item
                                };
                            });

                            if (results.length == 1) {
                                $autocomplete.data('single-result', results[0]);
                            } else {
                                $autocomplete.data('single-result', null);

                                if (results.length == 0) {

                                    var noResultSearches = $autocomplete.data('no-result-searches');

                                    if (!noResultSearches) {
                                        noResultSearches = 0;
                                    }

                                    $autocomplete.data('no-result-searches', noResultSearches + 1);
                                } else {
                                    $autocomplete.data('no-result-searches', 0);
                                }
                            }

                            autoCompleteCache[term] = results;
                            response(results);
                        }
                    });
                },
                minLength: 1,
                select: function (event, ui) {
                    saveValue(ui.item);
                    if (event.pageX) {
                        redactor.sync();
                    }
                    return false;
                },
                messages: {
                    noResults: '',
                    results: function () {
                    }
                }
            });

            $autocomplete.find('input').data('uiAutocomplete')._renderItem = function (ul, item) {
                return $("<li class='autotaguser-item'></li>")
                    .data("item.autocomplete", item)
                    .append($('<a>' +
                        '<img class="gravatar" height="24" width="24" style="float: left; margin-right: 6px" src="' + item.object.avatar + '" />' +
                        '<span>' + item.label + '</span>' +
                        '</a>'))
                    .appendTo(ul);
            };

            redactor.insertNode($autocomplete);
            redactor.setCaret($autocomplete.get(0), 1);

            $autocomplete.focus();
        }
    }
};

RedactorPlugins.code = {
    init: function () {
        this.doCodeBtn();
    },

    doCodeBtn: function () {
        this.buttonRemove('code');
        var redactor_object = this;
        this.buttonAdd('code', pageContext.i18n.toolTipsInsertCode, function (event, button_key) {
            redactor_object.execCommand('formatblock', 'pre');
        });
    }
};

