register_command('likeComment', {
    onSuccess: function (data) {
        commandUtils.updatePostScore(this.nodeId, data.result.score, true);
    }
});

register_command('share', {
    execute: function (evt) {
        var $comment = $('#comment-' + this.nodeId);
        var ctx;
        if ($comment.length > 0) {
            ctx = $.extend({
                shareURL: this.getParsedUrl('comment-url')
            }, this.messages);

            ctx.description = this.getMessage("comment-description");
            ctx.title = this.getMessage("comment-title");
        } else {
            ctx = $.extend({
                shareURL: this.getParsedUrl('answer-url')
            }, this.messages);
        }


        var doptions = {
            nodes: commandUtils.renderTemplate("share-dialog", ctx),
            shareURL: ctx.shareURL,
            title: ctx.title,
            yes_callback: function ($dialog, close) {
                close();
            },
            show_no: false,
            close_on_clickoutside: true,
            centered: false,
            event: ctx
        };

        return commandUtils.showDialog(doptions);
    }
});

register_command('deleteComment', {
    onSuccess: function (data) {
        var $comment = $('#comment-' + this.nodeId);
        $comment.css('background', 'red');
        $comment.fadeOut('slow', function () {
            $comment.remove();
        });
        var post_id = data.result.parentNode.id;
        var $showCommentsLink = $("#" + post_id + "-show-comments-container");
        var $commentsContainer = $("#comments-container-" + post_id);
        var $commentCount = parseInt($showCommentsLink.attr("commentCount")) - 1;
        $showCommentsLink.attr("commentCount", $commentCount);
        if ($commentCount === 1) {
        	$commentsContainer.css("display") === "none" ? $showCommentsLink.html(pageContext.i18n.showOneComment) : $showCommentsLink.html(pageContext.i18n.hideOneComment);
        } else {
        	if ($commentCount === 0) {
        		$showCommentsLink.hide();
        	} else {
        		$commentsContainer.css("display") === "none" ? $showCommentsLink.html(pageContext.i18n.showNComments.replace("$n",$commentCount)) : $showCommentsLink.html(pageContext.i18n.hideNComments.replace("$n",$commentCount));
        	}
        }
    }
});

register_command('voteUp', {
    onSuccess: function (data) {


        if(data.result.cancelVoteAction != undefined) {
            commandUtils.updatePostScore(this.nodeId, data.result.score, false);
        }
        else {
            var oldScore = parseInt($("#post-"+this.nodeId+"-score").text());
            if(oldScore == -1 && data.result.score == 1) {
                oldScore = 0;
            }
            commandUtils.updatePostScore(this.nodeId, oldScore+1, false);
        }

        var voteDown = commandUtils.findAndExtractCommand(this.nodeId, 'voteDown');

        if (voteDown.getStatus() == 'on') {
            voteDown.onCompleted(true);
        }
    },
    updateLinkText: function (data) {
        if(!this.element.hasClass("votes")){
            if (this.element.hasClass("on")) {
                this.element.html(pageContext.i18n.unlike);
            } else {
                this.element.html(pageContext.i18n.like);
            }
        }
    }
});
register_command('voteDown', {
    onSuccess: function (data) {
        commandUtils.updatePostScore(this.nodeId, data.result.score, false);

        var voteUp = commandUtils.findAndExtractCommand(this.nodeId, 'voteUp');

        if (voteUp.getStatus() == 'on') {
            voteUp.onCompleted(true);
        }
    }
});

register_command('acceptAnswer', {
    onSuccess: function (data) {
        if (data.result.acceptAction.canceled) {
            this.nodeElement.find('.labels .label-success').remove();
            this.nodeElement.find('.post-controls .accept-answer').text(pageContext.i18n.answer.controlBar.accept);
            this.nodeElement.find('.post-controls .accept-answer').prepend('<i class="icon-ok"></i> ');
            this.nodeElement.find('.post-controls .accept-answer').attr('title', pageContext.i18n.answer.controlBar.acceptCommand);
            this.nodeElement.removeClass('accepted-answer');
        } else {

            this.nodeElement.find('.labels').prepend('<span class="label label-success">'.concat(pageContext.i18n.answer.bestAnswer).concat('</span>'));
            this.nodeElement.find('.post-controls .accept-answer').text(pageContext.i18n.answer.controlBar.unaccept);
            this.nodeElement.find('.post-controls .accept-answer').prepend('<i class="icon-ok"></i> ');
            this.nodeElement.find('.post-controls .accept-answer').attr('title', pageContext.i18n.answer.controlBar.cancelAcceptedCommand);
            this.nodeElement.addClass('accepted-answer');
        }
    }
});

register_command('markFavorite', {
    onSuccess: function (data) {
        var canceled;
        try{
            canceled = data.result.favoriteAction.canceled;
        }catch(e){
            console.log(e);
            return;
        }
        if (canceled) {
            $('#favorite-mark-'+this.nodeId+' i').removeClass('icon-star').addClass('icon-star-empty');
        } else {
            $('#favorite-mark-'+this.nodeId+' i').removeClass('icon-star-empty').addClass('icon-star');
        }
        if (data.result.favoriteCount == 0) {
            $('#favorite-count-' + this.nodeId).html('');
        } else {
            $('#favorite-count-' + this.nodeId).html(data.result.favoriteCount);
        }
    }
});

register_command('reportPost', {
    execute: function (evt) {
        if (this.getStatus() == "off") {
            var parser = this;

            commandUtils.showPrompt(evt, 'flag-or-close-post-dialog', this.messages, {
                title: pageContext.i18n.reportQuestionModalTitle,
                beforeShow: function ($dialog) {
                    $dialog.find('.prompt-examples').change(function () {
                        $('textarea[name=prompt]').val($(this).val());
                    });
                },
                onOk: function (data) {
                    parser.executeRequest(data);
                }

            });
        } else {
            this.confirm(evt, pageContext.i18n.confirmModalTitle, pageContext.i18n.cancelReportModalText);
        }
    },
    onSuccess: function (data) {
        if (data.result.reportCount != undefined) {
            this.element.attr('reportCount', data.result.reportCount);
        } else {
            this.element.removeAttr('reportCount');
        }

        this.updateLinkText();

        $(".alert").hide();
        if (this.getStatus() == "off") {
            $(".post-container[nodeid=" + this.nodeId + "]").before("<div class='alert'>" + pageContext.i18n.reportSuccessText + "</div>");
        } else {
            $(".post-container[nodeid=" + this.nodeId + "]").before("<div class='alert'>" + pageContext.i18n.reportCancelText + "</div>");
        }
    },
    updateLinkText: function () {
        var newLink = this.getMessage('link.' + (this.element.hasClass('on') ? 'on' : 'off'));

        if (this.element.attr('reportCount') != null) {
            newLink += ('(' + this.element.attr('reportCount') + ')');
        }
        this.element.html(newLink);
    }
});

register_command('publishPost', {
    onSuccess: function (data) {
        commandUtils.reloadPage();
    }
});

register_command('sendToMod', {
    onSuccess: function (data) {
        commandUtils.reloadPage();
    }
});

register_command('deletePost', {
    onSuccess: function (data) {

        var targetNode = this.nodeElement;

        if (!targetNode.is('.post-container')) {
            targetNode = targetNode.parents('.post-container');
        }

        if (data.result.deleteAction.canceled) {
            targetNode.removeClass("deleted")
        } else {
            targetNode.addClass('deleted');
        }
    }
});

register_command('closeQuestion', {
    execute: function (evt) {
        if (this.getStatus() == "off") {
            var parser = this;

            commandUtils.showPrompt(evt, 'flag-or-close-post-dialog', this.messages, {
                title: pageContext.i18n.closeQuestionTitle,
                beforeShow: function ($dialog) {
                    $dialog.find('.prompt-examples').change(function () {
                        $('textarea[name=prompt]').val($(this).val());
                    }).change();
                },
                onOk: function (data) {
                    parser.executeRequest(data);
                }

            });
        } else {
            this.confirm(evt, null, null);
        }
    },
    onSuccess: function (data) {
        commandUtils.reloadPage();
    }
});

register_command('lockPost', {
    execute: function (evt) {
        if (this.getStatus() == "off") {
            var parser = this;

            commandUtils.showPrompt(evt, 'flag-or-close-post-dialog', this.messages, {
                title: pageContext.i18n.lockPostModalTitle,
                beforeShow: function ($dialog) {
                    $dialog.find('.prompt-examples').change(function () {
                        $('textarea[name=prompt]').val($(this).val());
                    }).change();
                },
                onOk: function (data) {
                    parser.executeRequest(data);
                }

            });
        } else {
            this.confirm(evt, pageContext.i18n.confirmModalTitle, pageContext.i18n.unlockPostModalText);
        }
    },
    onSuccess: function (data) {
        commandUtils.reloadPage();
    }
});

register_command('wikifyPost', {
    onSuccess: function (data) {
        if (data.result.wikifyAction.canceled) {
            this.nodeElement.find('.labels .label-info.label-wiki').remove();
        } else {
            this.nodeElement.find('.labels').prepend('<span class="label label-info label-wiki">'.concat(pageContext.i18n.wiki).concat('</span>'));
        }
        commandUtils.reloadPage();
    }
});

register_command('convertToComment', {
    execute: function (evt) {
        var parser = this;

        $.getJSON(this.getParsedUrl('candidates'), function (data) {
            $.each(data.result.parentCandidates, function (i, post) {
                if (post.type == "question") {
                    post.summary = parser.getMessage('question');
                } else {

                    var postAuthor = (pageContext.userRealName && post.author.realname) ? post.author.realname : post.author.username;

                    post.summary = parser.getMessage('answer') + ' (' + pageContext.i18n.by + ' ' + postAuthor + ', ' +
                        commandUtils.friendlyDate(new Date(post.creationDate)) + ')';
                }
            });

            $.extend(data.result, parser.messages);
            parser.dialog(evt, 'convert-to-comment-dialog', data.result, pageContext.i18n.commandsConvertToCommentTitle);
        });
    },

    onSuccess: function (data) {
        commandUtils.reloadPage();
    }
});

register_command('convertToAnswer', {
    execute: function (evt) {
        this.confirm(evt, pageContext.i18n.confirmModalTitle, pageContext.i18n.convertToAnswerText);
    },

    onSuccess: function (data) {
        commandUtils.reloadPage();
    }
});

register_command('redirectQuestion', {
    execute: function (evt) {
        if (this.getStatus() == "off") {
            var parser = this;

            commandUtils.showPrompt(evt, 'redirect-question-dialog', this.messages, {
                extra_class: "redirectDialog",
                title: pageContext.i18n.postControlsRedirectTitle,
                beforeShow: function ($dialog) {
                    var $searchQuestion = $dialog.find('.textInput');
                    $searchQuestion.autocomplete({
                        minLength: 0,
                        appendTo: "#results",
                        highlight: function (match, keywords) {
                            keywords = keywords.split(' ').join('|');
                            return match.replace(new RegExp("(" + keywords + ")", "gi"), '<b>$1</b>');
                        },
                        source: function (request, response) {
                            $.ajax({
                                url: parser.getParsedUrl('search'),
                                dataType: 'json',
                                minLength: 0,
                                delay: 30,
                                data: {q: request.term, page: 1, pageSize: 5, type: "question"},
                                success: function (data) {
                                    response($.map(data.searchResults.results, function (item, index) {
                                        if (item != null) {
                                            return {
                                                desc: item.title,
                                                label: item.title.replace(
                                                    new RegExp(
                                                        "(?![^&;]+;)(?!<[^<>]*)(" +
                                                            $.ui.autocomplete.escapeRegex(request.term) +
                                                            ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                                    ), "<strong>$1</strong>"),
                                                value: item.id
                                            };
                                        }
                                    }));
                                }
                            });
                        },
                        change: function (event, ui) {
                        	var _autocomplete_value = $(this).val();
                        	if ($('.ui-autocomplete li a').filter(function() {
                        	    return $(this).text().trim() == _autocomplete_value;
                        	}).size() == 0) {
                        		$dialog.find('.textInput').val('');
                                $dialog.find("input[name=to]").val('');
                            }
                        },
                        select: function (event, ui) {
                            $dialog.find('.textInput').val(ui.item.desc);
                            $dialog.find("input[name=to]").val(ui.item.value);
                            return false;
                        }
                    });
                    if ($searchQuestion.length) {
                        $searchQuestion.data("ui-autocomplete")._renderItem = function (ul, item) {
                            ul.addClass("redirect-autocomplete-ul");
                            return $("<li></li>")
                                .data("ui-autocomplete-item", item)
                                .append("<a>" + item.label + "</a>")
                                .appendTo(ul);
                        };
                    }
                },

                onOk: function (data) {
                	//No nice way to show error message and not interested in saying "Bad Request" , just bailing...
                	if(data.to){
                		parser.executeRequest(data);
                	}
                }

            });
        } else {
            this.confirm(evt, null, null);
        }
    },
    onSuccess: function (data) {
        //commandUtils.reloadPageWithReplace("/\?redirectedFrom=\d+/g");
        if (this.getStatus() == "off") {
            commandUtils.reloadPage();
        } else {
            $(".alert").hide();
            if (window.history.replaceState) {
                var uri = window.location.toString();
                if (uri.indexOf("?") > 0) {
                    var clean_uri = uri.substring(0, uri.indexOf("?")).replace(/#[^#]*$/, '');
                    window.history.replaceState({}, document.title, clean_uri);
                }
            }
        }
    }
});

register_command('moveToSpace', {
    execute: function (evt) {
        var parser = this;

        $.getJSON(this.getParsedUrl('candidates'), function (data) {
            $.extend(data.result, parser.messages);
            parser.dialog(evt, 'move-to-space-dialog', data.result, pageContext.i18n.commandsMoveToSpace);
        });
    },

    onSuccess: function (data) {
        commandUtils.reloadPage();
    }
});

register_command('switchPrivacy', {
    execute: function(evt) {
        var parser = this;
        parser.dialog(evt, 'switch-privacy-dialog', null, pageContext.i18n.confirmModalTitle);
        // this.confirm(evt, null, null);
    },

    onSuccess: function(data) { commandUtils.reloadPage(); }
});

register_command('giveReputation', {
    execute: function(evt) {
        if (this.getStatus() == "off") {
            var parser = this;

            var ctx = $.extend({
                isAnswer: this.nodeElement.is('.answer-container') || this.nodeElement.parents('.answer-container').length,
                currentUserPoints: pageContext.currentUser.reputation
            }, this.messages);

            commandUtils.showPrompt(evt, 'give-reputation-dialog',ctx, {
                title: pageContext.i18n.commandsGiveReputation,
                onOk: function(data) {
                    data.node = parser.nodeId;

                    if (data.points.match(/^[1-9]\d*$/) == null){ //Invalid Input;
                        $("#invaliderror").text(pageContext.i18n.invalidReputation);
                        return false;
                    } else {
                        parser.executeRequest(data);
                    }
                }
            });
        }
    },
    onSuccess: function(data, evt) {
            if(data.success == false) {
                commandUtils.showMessage(evt,data.errors.status, function() {
                    commandUtils.reloadPage();});
            }
            else {
                commandUtils.showMessage(evt, pageContext.i18n.commandsGiveReputationSuccess, function() {
                    commandUtils.reloadPage();
                }, pageContext.i18n.commandsGiveReputationSuccess);
            }
    }

});
