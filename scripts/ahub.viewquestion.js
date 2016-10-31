$(document).ready(function () {
    $(".post-votes-modal").on("show", function (e) {
        var $cur = $(this);
        var $curBody = $cur.find(".modal-body");
        var $curUl = $curBody.find("ul");
        var spinner = "<li class='spinner'><i class='icon-spinner icon-spin icon-2x'></i></li>";
        if ($cur.siblings(".post-score-wrapper").hasClass("positive")) {
            var page = 0;
            var pageSize = 25;
            var updateList = function (follows) {
                $.ajax({
                    url: getVotesJsonUrl.replace("%7Bnode%7D", $cur.parent().attr("nodeId")),
                    beforeSend: function () {
                        if ($curUl.find(".spinner").length == 0) {
                            $curUl.append("<li class='spinner'><i class='icon-spinner icon-spin icon-2x'></i></li>");
                        }
                    },
                    data: {
                        page: page,
                        pageSize: pageSize
                    },
                    success: function (data) {
                        page++;
                        if (data.votes.length < pageSize) {
                            $curBody.unbind("scroll");
                        }
                        $curUl.find(".spinner").remove();
                        $.each(data.votes, function (i, vote) {
                            var context = {user: vote.user};
                            context.user.profileUrl = pageContext.url.profile.replace("{id}", vote.user.id).replace("{plug}", vote.user.username);
                            context.user.displayName = (pageContext.userRealName && vote.user.realname) ? vote.user.realname : vote.user.username;
                            context.follows = follows;
                            $curUl.append(commandUtils.renderTemplate('user-with-follow', context));
                        });
                        commandUtils.initializeLabels();
                    }
                });
            };
            if ($cur.find("ul").children().length < 1) {
                var follows;
                $.ajax({
                    url: pageContext.url.getUserFollows.replace("%7Buser%7D", pageContext.currentUser.id),
                    beforeSend: function () {
                        $cur.find("ul").append(spinner);
                    },
                    success: function (data) {
                        follows = data.follows;
                        updateList(follows);
                        $curBody.scroll(function () {
                            if ($curBody.scrollTop() >= $curUl.height() - $curBody.height() - 10) {
                                updateList(follows);
                            }
                        });
                    }
                });
            }
        } else {
            e.preventDefault();
            e.stopPropagation();
        }
    });
});

function initCommandOverrides() {
    function showWikiMark($el) {
        var context = {canEdit: false, isAnswer: false};

        var $editlink = $el.find('.node-tools-edit-link');
        if ($editlink.length > 0) {
            if ($el.parents("[nodeid]:first").is('.answer')) {
                context.isAnswer = true;
            }

            context.canEdit = true;
            context.editUrl = $editlink.attr('href');
        }

        $el.append(commandUtils.renderTemplate('post-wiki-mark', context));
    }

    function removeWikiMark($el) {
        $el.find('.community-wiki').remove();
    }

    commands.wikifyPost.showWikiMark = showWikiMark;
    commands.wikifyPost.removeWikiMark = removeWikiMark;

    commands.wikifyPost.updateLinkText = function () {
        var text = this.getLinkText();

        if (text != null) {
            this.element.html(text);
        }

        if (this.getStatus() == 'on') {
            showWikiMark(this.element.parents('.post-controls'));
        } else {
            removeWikiMark(this.element.parents('.post-controls'));
        }
    };
}

var tools = {
    roles: null,
    settings: null,
    questionAuthor: null,
    init: function (roles, settings) {
        this.roles = roles;
        this.settings = settings;
    },
    roleOrAuthor: function (r1, isAuthor, r2) {
        return r1 || (isAuthor && r2);
    },
    rel: function (rel) {
        var userId = pageContext.currentUser.id;

        var ar = this.roles.a;
        var qr = this.roles.q;
        var cr = this.roles.c;
        var nr = this.roles.n;
        var mr = this.roles.m;


        for (var id in rel) {
            var nodeRel = rel[id];
            var authorId = $("[nodeid=" + id + "]").attr("authorId");
            var isAuthor = userId == authorId;
            var $topContainer;

            if (nodeRel.type == "answer") {
                $topContainer = $('#answer-' + id);
            } else {
                $topContainer = $('#question-container');
            }
//            setupComments($topContainer, true, false, {u:true,op:true,m:true,og:true,as:true,ag:true});
            setupComments($topContainer, (!nodeRel.locked && this.roleOrAuthor(nr.c, isAuthor, nr.co)), nodeRel.locked, this.roles.pc);

        }
    }

}

var setupComments = function ($topContainer, canUseComments, commentsLocked, pcPermissions, defaultVisibility, autoExpandComments) {
    if ($topContainer.find('.comment-form-container').find('form').length == 0) {
        return;
    }

    if (!defaultVisibility) {
        defaultVisibility = 'full';
    }
    if(autoExpandComments)
    {
    var commentsContainer = $topContainer.find('.comments-container');
    var showCommentsContainerLink=  $topContainer.find('.show-comments-container');
    commentsContainer.slideToggle(400, function(){
        updateShowComments(showCommentsContainerLink, parseInt(showCommentsContainerLink.attr('commentcount')), commentsContainer)
    });
    }
    create_object(CommentsBox).initialize($topContainer, canUseComments, commentsLocked, pcPermissions, defaultVisibility);
}

function updateShowComments($link, count, commentsContainer) {
    if (count === 1) {
        commentsContainer.css("display") === "none" ? $link.html(pageContext.i18n.showOneComment) : $link.html(pageContext.i18n.hideOneComment);
    } else {
        commentsContainer.css("display") === "none" ? $link.html(pageContext.i18n.showNComments.replace("$n",count)) : $link.html(pageContext.i18n.hideNComments.replace("$n",count));
    }
}

var CommentsBox = {

    initialize: function ($topContainer, canUseComments, commentsLocked, pcPermissions, defaultVisibility) {

        var $container = $topContainer.find('.comment-form-container');
        var $comment_tools = $topContainer.find('.comment-tools');

        this.elements = {
            topContainer: $topContainer,
            formContainer: $container,
            postControls: $topContainer.find('.post-controls'),
            commentTools: $topContainer.find('.comment-tools'),
            commentsContainer: $topContainer.find('.comments-container'),
            showCommentsContainerLink: $topContainer.find('.show-comments-container'),

            form: $container.find('form'),
            textarea: $container.find('textarea'),
            extraInputs: $container.find('.comment-form-extra-inputs'),

            submitButton: $container.find('.comment-submit'),
            cancelButton: $container.find('.comment-cancel'),

            charsLeftMessage: $container.find('.comments-chars-left-msg'),
            charsToGoMessage: $container.find('.comments-chars-togo-msg'),
            charsExceededMessage: $container.find('.comments-chars-exceeded-msg'),
            charsCounter: $container.find('.comments-char-left-count'),

            showAllCommentsLink: $comment_tools.find('.show-all-comments-link'),
            addCommentLink: $comment_tools.find('.add-comment-link'),

            commentsLockedLabel: $container.parent().find('.comments-locked'),

            recipientsMenu: $container.find('.comment-recipient-container'),
            recipientsLabel: $container.find('.comment-recipients-label'),
            recipientsType: $container.find('input[name="visibility"]')
        };

        var chars_limits = this.elements.charsCounter.html().split('|');

        this.options = {
            'commentsLocked': commentsLocked,
            'canUseComments': canUseComments,
            'pcPermissions': pcPermissions,
            'defaultVisibility': defaultVisibility,
            minLength: parseInt(chars_limits[0]),
            maxLength: parseInt(chars_limits[1]),
            commentsEditor: pageContext.options && pageContext.options.commentsEditor ? pageContext.options.commentsEditor : null
        };

        this.options.warnLength = this.options.maxLength - 30;


        this.state = {
            currentLength: 0,
            inputCheckInterval: null,
            editing: null,
            replying: null,
            formContext: null,

            inPanelsTransition: false,
            currentPanel: 'comments',

            panelsContent: {}
        };

        this.setupUiMods();
        this.setupCallbacks();
    },

    listenToFormChanges: function () {
        if (this.state.inputCheckInterval) {
            window.clearInterval(this.state.inputCheckInterval);
        }

        var self = this;
        var options = self.options;
        var elements = self.elements;
        var state = self.state;

        this.state.inputCheckInterval = window.setInterval(function () {

            var tmpobj = $("<p>" + elements.textarea.val().replace(/[ ]{2,}/g, " ") + "</p>");


            var length = tmpobj.text().length;

            if (state.currentLength == length)
                return;
            if (length < options.warnLength) {
                elements.charsCounter.removeClass('warn');
            } else if (length >= options.warnLength) {
                elements.charsCounter.addClass('warn');
            }

            if (length < options.minLength) {
                elements.charsLeftMessage.hide();
                elements.charsExceededMessage.hide();
                elements.charsToGoMessage.show();
                elements.charsCounter.html(options.minLength - length);
                elements.charsCounter.addClass('warn');
            } else if (length > options.maxLength) {
                elements.charsLeftMessage.hide();
                elements.charsToGoMessage.hide();
                elements.charsCounter.html(options.maxLength);
                elements.charsExceededMessage.show();
                elements.charsCounter.addClass('warn');
            } else {
                elements.charsToGoMessage.hide();
                elements.charsExceededMessage.hide();
                elements.charsLeftMessage.show();
                elements.charsCounter.html(options.maxLength - length);
                elements.charsCounter.removeClass('warn');
            }

            if (length > options.maxLength || length < options.minLength) {
                elements.submitButton.attr("disabled", "disabled");

            } else {
                elements.submitButton.removeAttr("disabled");
            }
            state.currentLength = length;
        }, 200);
    },

    cleanupForm: function () {
        if (this.state.inputCheckInterval) {
            window.clearInterval(this.state.inputCheckInterval);
            this.state.inputCheckInterval = null;
        }
        $(this.elements.textarea).redactor('set', '<p><br></p>');
        this.elements.extraInputs.html('');
        this.elements.textarea.css('height', 200);
        this.elements.charsCounter.html(this.options.maxLength);
        this.elements.charsLeftMessage.removeClass('warn');

        this.state.currentLength = 0;
        this.state.editing = null;
        this.state.replying = null;
        this.state.formContext = null;

        this.elements.charsLeftMessage.hide();
        this.elements.charsExceededMessage.hide();
        this.elements.charsToGoMessage.show();

        this.elements.charsCounter.removeClass('warn');
        this.elements.charsCounter.html(this.options.minLength);
        this.elements.submitButton.attr("disabled", "disabled");

        if (this.elements.attachments) {
            this.elements.attachments.img.html('');
            this.elements.attachments.node.html('');
        }
    },

    showForm: function ($location) {

        if ($location) {
            var cur = this;
            this.elements.formContainer.slideUp(400, function () {
                $location.after(cur.elements.formContainer);
            });
        }

        this.elements.formContainer.slideDown('slow');
        this.elements.addCommentLink.find("a").attr('disabled', "true");
        this.elements.showAllCommentsLink.fadeOut('slow');
        this.elements.commentsContainer.find('.comment-reply').attr('disabled', "true");
        $(this.elements.textarea).focus();
        this.elements.extraInputs.html('');
        this.elements.recipientsLabel.text(pageContext.i18n.commentVisibility[this.options.defaultVisibility]);
        this.elements.recipientsType.val(this.options.defaultVisibility);

        if (this.options.pcPermissions.u) {
            if (this.state.editing) {
                this.elements.recipientsMenu.hide();
            } else {
                this.elements.recipientsMenu.show();
            }
        }

        this.listenToFormChanges();
    },

    hideForm: function (fun) {

        var self = this;

        this.elements.formContainer.slideUp('slow', function () {
            self.cleanupForm();
            if (typeof fun !== "undefined") {
                fun();
            }
        });

        this.elements.addCommentLink.find("a").removeAttr('disabled');
        this.elements.showAllCommentsLink.fadeIn('slow');
        this.elements.commentsContainer.find('.comment-reply').removeAttr('disabled');
    },

    setupUiMods: function () {
        var self = this;

//        if (this.options.canUseComments) {
//            this.elements.addCommentLink.show();
//        }

        if (this.options.commentsLocked) {
            this.elements.commentsLockedLabel.show();
        }

//        var attachments = null;

        if (pageContext.options.commentsAttachmentsEnabled) {

            var $mainAttachmentsContainer = $('<div class="comments-form-attachments"></div>');
            var $attachmentsContainer = $('<div></div>');
            var $imgAttachmentsContainer = $('<div></div>');

            $mainAttachmentsContainer.append($attachmentsContainer);
            $mainAttachmentsContainer.append($imgAttachmentsContainer);

            this.elements.form.append($mainAttachmentsContainer);

            this.elements.attachments = {
                main: $mainAttachmentsContainer,
                node: $attachmentsContainer,
                img: $imgAttachmentsContainer
            };

            self.addAttachmentToForm = function(attachment) {
                var $el = null;

                function createDeleteButton() {
                    return $('<a class="node-attachment-delete" href="#">x</a>');
                }

                if (attachment.isImage) {
                    $el = $('<div class="img-node-attachment"></div>');
                    var $link = $('<a href="' + attachment.url + '" target="_blank"></a>');

                    $link.append($('<img src="' + attachment.url + '" width="100" />'));
                    $link.append($('<span>' + attachment.fileName + '(' + attachment.size + ')' + '</span>'));
                    $el.append($link);
                    $el.append($('<input type="hidden" name="attachments" value="' + attachment.fileId + '" />'));

                    $el.append(createDeleteButton());

                    $imgAttachmentsContainer.append($el);

                } else {
                    $el = $('<div class="node-attachment"></div>');
                    $el.append('<span class="attachment-icon"></span>');
                    $el.append($('<a href="' + attachment.url + '" target="_blank">' + attachment.fileName + '</a>'));
                    $el.append($('<span> (' + attachment.size + ')</span>'));
                    $el.append($('<input type="hidden" name="attachments" value="' + attachment.fileId + '" />'));

                    $el.append(createDeleteButton());

                    $attachmentsContainer.append($el);
                }
            };

            var attachments = {
                authorize: function(image) {
                    var current = [];

                    $mainAttachmentsContainer.find('input[name=attachments]').each(function() {
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
                },
                toForm: self.addAttachmentToForm
            };

            this.elements.textarea.redactor({
                plugins: pageContext.editor.configs.standard.plugins,
                buttons: pageContext.editor.configs.standard.buttons,
                convertDivs: false,
                linkSize: 1000,
                callback: function (redactor) {
                    redactor.fixBlocks();
                },
                convertUrlLinks: false,
                convertLinks: false,
                attachments: attachments
            });
        }

        if (this.elements.attachments) {
            self.attachmentsToComment = function ($comment, attachments) {
                if ($comment.find('.comment-text:first').next().is('.node-attachments')) {
                    $comment.find('.comment-text:first').next().remove();
                }

                var $attachments = $('<div class="node-attachments"></div>');
                $comment.find('.comment-text:first').after($attachments);

                $.each(attachments, function (i, attachment) {
                    var $attachment = $('<div class="node-attachment" ><span></span></div>');
                    $attachment.find('span').addClass(attachment.isImage ? 'img-attachment-icon' : 'attachment-icon');

                    $attachment.append($('<a href="' + attachment.url + '">' + attachment.fileName + '</a>'));
                    $attachment.append($('<span>' + ' (' + attachment.size + ')' + '</span>'));

                    $attachments.append($attachment);
                });
            };
        }

        this.setupRecipientsMenu();
    },

    setupRecipientsMenu: function () {
        var self = this;
        var perm = this.options.pcPermissions;

        if (perm.u && (perm.op || perm.m || perm.og || perm.as || perm.ag)) {

            if (!perm.op) {
                this.elements.recipientsMenu.find('.comment-recipients-selector[value=op]').parent().remove();
            }

            if (!perm.m) {
                this.elements.recipientsMenu.find('.comment-recipients-selector[value=mod]').parent().remove();
            }

            if (!(perm.op && perm.m)) {
                this.elements.recipientsMenu.find('.comment-recipients-selector[value=opAndMod]').parent().remove();
            }

            if (!(perm.og || perm.ag || perm.as)) {
                this.elements.recipientsMenu.find('.comment-recipients-selector[value=recipient]').parent().remove();
            }

            this.elements.recipientsMenu.find('.comment-recipients-selector').click(function (e) {
                var value = $(this).attr('value');

                if (value != 'recipient') {
                    self.elements.recipientsLabel.text(pageContext.i18n.commentVisibility[value]);
                    self.elements.recipientsType.val(value);
                } else {
                    $.getJSON(pageContext.url.possibleCommentRecipients.replace("%ID%", self.elements.formContainer.parents("[nodeid]").attr("nodeid")), function (data) {
                        var context = data.result;
                        context.groupsCheck = data.result.groups.length <= 5;

                        context.msg = pageContext.i18n.commentVisibility;
                        context.perm = perm;

                        commandUtils.showPrompt(e, "advanced-visibility-dialog", context, {
                            title: pageContext.i18n.commentVisibility.dialogTitle,
                            onOk: function (data) {
                                if (data.recipients || data.specialRecipients) {
                                    self.elements.extraInputs.html('');

                                    if (data.recipients) {
                                        if (data.recipients.constructor != Array) {
                                            data.recipients = [data.recipients];
                                        }

                                        $.each(data.recipients, function (i, recipient) {
                                            self.elements.extraInputs.append('<input type="hidden" name="recipients" value="' + recipient + '" />');
                                        });
                                    }

                                    if (data.specialRecipients) {
                                        if (data.specialRecipients.constructor != Array) {
                                            data.specialRecipients = [data.specialRecipients];
                                        }

                                        $.each(data.specialRecipients, function (i, recipient) {
                                            self.elements.extraInputs.append('<input type="hidden" name="specialRecipients" value="' + recipient + '" />');
                                        });
                                    }

                                    self.elements.recipientsLabel.text(pageContext.i18n.commentVisibility['other']);
                                    self.elements.recipientsType.val('recipient');
                                }
                            }, beforeShow: function ($dialog) {
                                if (!context.groupsCheck) {
                                    var groupsSource = [];

                                    $.each(context.groups, function (i, group) {
                                        groupsSource.push({
                                            label: group.name,
                                            value: group.id
                                        })
                                    });

                                    var $autocomplete = $dialog.find('.comment-recipients-groups-autocomplete');
                                    var $selectedContainer = $dialog.find('.comment-recipients-groups-container');

                                    $autocomplete.autocomplete({
                                        source: groupsSource,
                                        select: function (e, ui) {

                                            if ($selectedContainer.find('span.group[name=' + ui.item.value + ']').length == 0) {
                                                var $newEl = $('<span class="group" style="margin-right: 5px;" name="' + ui.item.value + '">' + ui.item.label +
                                                    ' <a href="#" title="Removing tag">(x)</a>' +
                                                    '<input type="hidden" name="recipients" value="' + ui.item.value + '" />' +
                                                    '</span>');

                                                $selectedContainer.append($newEl);

                                                $newEl.find('a').click(function () {
                                                    $newEl.remove();
                                                    return false;
                                                });
                                            }

                                            $autocomplete.val('');
                                            return false;
                                        }
                                    });
                                }
                            }

                        });
                    });
                }

                self.elements.recipientsMenu.removeClass("open");
                return false;
            });
        } else {
            this.elements.recipientsMenu.remove();
            self.elements.recipientsType.val("full");
        }
    },

    setupCallbacks: function () {
        var self = this;

        self.elements.showAllCommentsLink.click(function () {
            if ($(this).is('.loading')) {
                return false;
            }

            $(this).addClass('loading');

            self.loadComments(pageContext.url.getComments.replace("%25ID%25", self.elements.formContainer.parents("[nodeid]").attr("nodeid")),
                self.elements.commentsContainer, '', null);

            $(this).fadeOut('fast', function () {
                $(this).remove();
            });
            return false;
        });

        self.elements.showCommentsContainerLink.click(function () {
            self.elements.commentsContainer.slideToggle(400, function(){
                updateShowCommentsLink(self.elements.showCommentsContainerLink, parseInt(self.elements.showCommentsContainerLink.attr('commentcount')))
            });
        });

        self.elements.addCommentLink.click(function () {
            self.cleanupForm();
            if (self.elements.topContainer.attr("class") == "question-container") {
                self.showForm(self.elements.postControls);
            } else {
                self.showForm(self.elements.commentTools);
            }
            return false;
        });

        self.elements.cancelButton.click(function (event) {
            if (self.state.editing) {
                $('#comment-' + self.state.editing).slideDown('slow');
            }
            self.hideForm();
            return false;
        });

        self.elements.submitButton.click(function (evt) {
            if (evt.handled !== true) {
                evt.handled = true;
                self.elements.submitButton.attr('disabled', 'disabled');

                var post_data = commandUtils.extractFormData(self.elements.form);

                if (self.state.editing) {
                    post_data['edit'] = 'true';
                } else {
                    post_data['edit'] = 'false';
                }

                if (self.state.formContext) {
                    $.extend(post_data, self.state.formContext);
                }

                $.ajax({
                    'type': 'POST',
                    'url': self.elements.form.attr('action'),
                    'data': post_data,
                    'dataType': 'json',
                    'traditional': true,
                    'success': function (data) {
                        if (data.comment != undefined) {

                            var post_id = data['comment']['parentId'];
                            var comment_id = data['comment']['id'];

                            var now = Date.today().setTimeToNow();
                            data.commentDate = now.toString("MMM dd") + ", " + now.toString("h:mm tt") + new Date().getUTCOffset();
                            data.commentDateFriendly = "(" + pageContext.i18n.justNow + ")";
                            data.author = pageContext.currentUser;
                            data.parentAuthor = {
                                username: $('#comment-' + post_id + ' .comment-user').html(),
                                url: $('#comment-' + post_id + ' .comment-user').attr('href'),
                                avatar: $('#comment-' + post_id + ' .comment-user-gravatar img').attr('src')
                            };
                            data.revisionUrl = pageContext.url.revisionView.replace('{nodeId}', data.comment.id);

                            if ($('#comment-' + post_id + ' .comment-user').html() == null) {
                                data.parentAuthor = {
                                    username: $('#answer-' + post_id + ' .answer_author').html(),
                                    url: $('#answer-' + post_id + ' .answer_author').attr('href'),
                                    avatar: $('#answer-' + post_id + ' .answer-gravatar img').attr('src')
                                };
                            }

                            //data.showTools = true;

                            self.elements.commentsContainer.find('.comments-empty').remove();

                            if (post_data['edit'] == 'true') {
                                $('#comment-' + comment_id).find('.comment-text:first').html(data['comment']['bodyAsHTML']);

                                if (self.elements.attachments) {
                                    self.attachmentsToComment($('#comment-' + comment_id), data.comment.attachments ? data.comment.attachments : []);
                                }
                            } else {
                                var $new_comment = commandUtils.renderTemplate('new-comment-skeleton', data);
                                $("[rel=user]", $new_comment).each(function () {
                                    createUserPopOver($(this));
                                });
                                commandUtils.initializeLabelsOnElement($new_comment);

                                if (!window.croles.doc && !window.croles.dc) {
                                    $(".comment-delete", $new_comment).hide();
                                }

                                if (!window.croles.eo && !window.croles.ea) {
                                    $(".comment-edit", $new_comment).hide();
                                }

                                if (self.state.replying) {
                                    var $container = $('#comment-' + self.state.replying);

                                    $container.append($new_comment);
                                } else {
                                    $new_comment.addClass('even');
                                    self.elements.commentsContainer.append($new_comment);
                                }

                                if (self.elements.attachments && data.comment.attachments) {
                                    self.attachmentsToComment($('#comment-' + comment_id), data.comment.attachments);
                                }
                            }
                            self.hideForm(function () {

                                self.elements.commentsContainer.slideDown("400", function () {
                                    $('#comment-' + comment_id).slideDown('slow', function () {
                                        $('html, body').animate({
                                            scrollTop: $('#comment-' + comment_id).offset().top
                                        }, 1000);
                                        if (data.comment.depth === 0) {
                                            var $showCommentsLink = $("#" + post_id + "-show-comments-container");
                                            var $commentCount = parseInt($showCommentsLink.attr("commentCount")) + 1;
                                            $showCommentsLink.attr("commentCount", $commentCount);
                                            updateShowCommentsLink($showCommentsLink, $commentCount);
                                        }
                                    });
                                });
                            });


                            if (data.comment.activeRevisionId) {
                                $('#comment-' + comment_id).attr('activerev', data.comment.activeRevisionId);
                            }

                        } else {
                            //will show a message later
                        }

                        self.elements.submitButton.removeAttr("disabled");
                        self.state.submitting = false;
                    }
                });
            }

            return false;
        });

        $(document).on('click', '#' + self.elements.commentsContainer.attr('id') + ' .comment-edit', function () {
            if (self.state.editing) {
                $('#comment-' + self.state.editing).slideDown('fast');
            }
            self.cleanupForm();

            var $link = $(this);
            var $parent = $link.parents('.comment:first');

            var comment_id = $parent.attr('nodeid');
            var activerev_id = $parent.attr('activerev');

            var $comment = $('#comment-' + comment_id);

            self.state.editing = comment_id;

            self.state.formContext = {
                node: comment_id,
                revisionId: activerev_id
            };

            $.post(pageContext.url.getRevision, {revision: activerev_id}, function (revision) {
                if (revision.body != undefined) {
                    $(self.elements.textarea).redactor('set', revision.body);
                } else {
                    //todo: some error message
                }
            }, "json");

            if (self.elements.attachments) {
                $comment.find('.node-attachments:first').find('.node-attachment').each(function () {
                    var $attachment = $(this);
                    var attachment = {};
                    attachment.isImage = $attachment.find('.img-attachment-icon').length > 0;
                    attachment.url = $attachment.find('a').attr('href');
                    attachment.fileName = $attachment.find('a').text();
                    attachment.size = $attachment.find('span:last').text();
                    attachment.size = /\(([^\)]*)\)/.exec(attachment.size)[1];
                    attachment.fileId = /\/(\d+)\-/.exec(attachment.url)[1];

                    self.addAttachmentToForm(attachment);
                });
            }

            $comment.slideUp('slow');
            self.showForm($comment);
            return false;
        });

        function updateShowCommentsLink($link, count) {
            if (count === 1) {
                self.elements.commentsContainer.css("display") === "none" ? $link.html(pageContext.i18n.showOneComment) : $link.html(pageContext.i18n.hideOneComment);
            } else {
                self.elements.commentsContainer.css("display") === "none" ? $link.html(pageContext.i18n.showNComments.replace("$n",count)) : $link.html(pageContext.i18n.hideNComments.replace("$n",count));
            }
        }

        $(document).on('click', '#' + self.elements.commentsContainer.attr('id') + ' .comment-replies-show', function () {
            var $link = $(this);
            var $parent = $($link.parents('.comment')[0]);
            var comment_id = $parent.attr('nodeid');

            $link.remove();

            self.loadComments(pageContext.url.getComments.replace("%25ID%25", comment_id), $parent, '', null);
            return false;
        });

        $(document).on('click', '#' + self.elements.commentsContainer.attr('id') + ' .comments-expand', function () {
            var $link = $(this);
            var $parent = $link.parent("[nodeid]:first");

            if(!$parent[0]) {
                $parent = $link.parent().parent().parents("[nodeid]:first");
            }

            var comment_id = $parent.attr('nodeid');

            $link.remove();
            
            var slideDownDeferred = $.Deferred();
            if (self.state.editing) {
                self.hideForm(function() {
                    slideDownDeferred.resolve()
                });
            } else {
                slideDownDeferred.resolve();
            }
            
            slideDownDeferred.then(function() {
                var $container = $parent.is('.comment') ? $parent : self.elements.commentsContainer;
                $container.before(self.elements.formContainer);
                self.loadComments(pageContext.url.getComments.replace("%25ID%25", comment_id), 
                        $container, '', null);
            })
            
            return false;
        });

        if (self.options.commentsLocked) {
            $('head').append('<style type="text/css">#' + self.elements.commentsContainer.attr('id') + ' .comment-reply{visibility: hidden;}</style>');
        } else {
            $(document).on('click', '#' + self.elements.commentsContainer.attr('id') + ' .comment-reply', function () {
                self.cleanupForm();

                var $parentContainer = $(this).parents("#" + $(this).attr("id").replace("-reply", ""));

                var in_reply_id = $parentContainer.attr('nodeid');


                self.state.replying = in_reply_id;

                self.state.formContext = {
                    inReply: in_reply_id
                };

                self.showForm($parentContainer);
                return false;
            });
        }
    },

    renderLoadedComments: function ($container, comments, jsonRelation) {
        var self = this;
        for (var i = 0; i < comments.length; i++) {
            var comment = comments[i];

            var tplData = {showTools: false};
            tplData.comment = comment;
            tplData.author = {
                id: comment.author.id,
                username: comment.author.username,
                url: pageContext.url.profile.replace("{id}", comment.author.id).replace("{plug}", comment.author.username),
                avatar: comment.author.avatar
            };

            tplData.parentAuthor = {
                username: $('#comment-' + comment.parentId + ' .comment-user').html(),
                url: $('#comment-' + comment.parentId + ' .comment-user').attr('href'),
                avatar: $('#comment-' + comment.parentId + ' .comment-user-gravatar img').attr('src')
            }

            tplData.commentDate = comment.creationDate;
            tplData.commentDateFriendly = commandUtils.friendlyDate(new Date(comment.creationDate));
            tplData.crel = jsonRelation[comment.id];
            tplData.revisionUrl = pageContext.url.revisionView.replace('{nodeId}', comment.id);

            var $el = commandUtils.renderTemplate('new-comment-skeleton', tplData);
            commandUtils.initializeLabelsOnElement($el);
            if (i > 0) {
                $container.find('#comment-' + comments[i - 1].id).after($el);
            } else {
                $container.append($el);
            }

            if (self.elements.attachments && comment.attachments) {
                self.attachmentsToComment($el, comment.attachments);
            }
            if (comment.replies && comment.replies.comments) {
                self.renderLoadedComments($el, comment.replies.comments, comment.replies.jsonRelation ? comment.replies.jsonRelation : null);
            }
        }

        if (jsonRelation) {
            tools.rel(jsonRelation);
        }
    },

    loadComments: function (url, $container, no_comments_text, callback) {
        var self = this;

        $.getJSON(url, function (data) {
            if (data.success) {
                if ($container.is('.comment')) {
                    $container.find('.comment').remove();
                } else {
                    $container.html('');
                }

                if (data.result.comments && data.result.comments.length == 0) {
                    self.elements.commentsContainer.html('<span class="comments-empty">' + no_comments_text + '</span>');
                } else {
                    if (data.result.replies) {
                        self.renderLoadedComments($container, data.result.replies.comments, data.result.replies.jsonRelation);
                    } else {
                        self.renderLoadedComments($container, data.result.comments, data.result.jsonRelation);
                    }
                }

                //$container.find('.not_top_scorer').slideDown('slow');
                self.elements.commentTools.find('.comments-showing').fadeOut('slow');

                if (callback) {
                    callback();
                }
            }
        });
    }
}