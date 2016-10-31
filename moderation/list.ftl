<#import "/macros/teamhub.ftl" as teamhub />
<#import "../macros/security.ftl" as security />
<html>
<head>
<title><#if tab?? && tab =="reported"><@trans key="moderation.reported.list.title"/><#else><@trans key="moderation.list.title"/></#if></title>
<style type="text/css">
    .ask-to-answer-tools {
        padding-top: 12px;
    }

    .ask-to-answer-input {
        width: 75%;
    }

    .ask-to-answer-switch.on {
        background-color: #777777;
        color: white;
        text-decoration: none;
    }

    .asked-to-answer-users {
        /*width: 55%;*/
        margin-bottom: 5px;
    }

    .asked-to-answer-users span.asked-user {
        background: none repeat scroll 0 0 #E5EBF8;
        border: 1px solid #BDCCED;
        border-radius: 2px 2px 2px 2px;
        color: #3060A8;
        display: block;
        float: left;
        font-family: helvetica;
        font-size: 11px;
        margin: 3px 5px 10px 0;
        padding: 0 2px;
        text-decoration: none;
    }

    .asked-to-answer-users span.asked-user a {
        color: #3060A8;
        font-size: 11px;
        font-weight: bold;
        margin-left: 4px;
        text-decoration: none;
    }

</style>
<content tag="packJS">
    <src>/scripts/ahub.viewquestion.js</src>
<#--<src>/scripts/wmd/showdown.js</src>-->
<#--<src>/scripts/wmd/wmd.js</src>-->
</content>
<script type="text/javascript" src="<@url path="/moderation/jquery.expander.min.js"/>"></script>
<#include "/scripts/cmd_includes/user.commands.ftl"/>
<#include "/scripts/cmd_includes/node.commands.ftl"/>
<script type="text/javascript">

$('document').ready(function () {
    $('a[command="reportPost"]').on('click', function (evt) {
        var reporter = $(this).data('reporter');
        var node = $(this).data('node')
        var url = "<@url name="commands:cancelOthersReport.json" node="%NODE%" user="%REPORTER%" safe=true/>".replace("%REPORTER%", reporter).replace("%NODE%", node);
        commands.reportPost.setUrl('click.on', url);
        if (this.element.attr('reportCount') == 0) {
            $(this).closest('div').remove();
        }
        evt.preventDefault();
    });
});

$(function () {
    $('.short-summary .summary-wrapper .node-body').expander({slicePoint: 400});

    /* $('.expand-link').live('click', function() {
         $(this).parents('.summary-wrapper').find('.node-body').css('height', 'auto');
         $(this).removeClass('expand-link');
         $(this).addClass('collapse-link');
         $(this).html('[-]');
         return false;
     });

     $('.collapse-link').live('click', function() {
         $(this).parents('.summary-wrapper').find('.node-body').css('height', $(this).parents('.summary-wrapper').find('.node-body').css('min-height'));
         $(this).removeClass('collapse-link');
         $(this).addClass('expand-link');
         $(this).html('[+]');
         return false;
     });*/

    register_command('deleteNode', {
        onSuccess: function (data) {
            if (data.result.rejectAction.canceled) {
                this.nodeElement.find('.user-info').removeClass('deleted');
            } else {
                this.nodeElement.find('.user-info').addClass('deleted');
                thisNodeElement = this.nodeElement;
                thisNodeElement.slideUp(500, function () {
                    thisNodeElement.remove();
                });
            }
        }
    });

    register_command('publishNode', {
        onSuccess: function (data) {
            if (!data.result.publishAction.canceled) {
                thisNodeElement = this.nodeElement;
                thisNodeElement.slideUp(500, function () {
                    thisNodeElement.remove();
                });
//                        this.nodeElement.find('.user-info').addClass('published');
            }
        }
    });

    commands.suspendUser.onSuccess = function (data) {
        if (data.result.suspended) {

        } else {

        }
    };

    commands.deleteNode.setUrl('click.off', "<@url name="commands:reject.json" node="%ID%" />");
    commands.deleteNode.setUrl('click.on', "<@url name="commands:cancelReject.json" node="%ID%" />");

    commands.deleteNode.setMsg('linkText.off', "<@trans key="commands.reject" default="reject" />");
    commands.deleteNode.setMsg('linkText.on', "<@trans key="commands.cancelReject" default="cancel reject" />");

    commands.publishNode.setUrl('click', "<@url name="commands:publish.json" node="%ID%" />");
    commands.publishNode.setMsg('linkText', "<@trans key="commands.publish" default="publish" />");

<#include "/questions/includes/question-tools-init.ftl" />
<#include "../nodes/comments-js-vars.ftl" />

    $('.mod-filter-field').change(function () {
        $(this).parents('form').submit();
    });

    $('#mod-filter-space-reset').click(function () {
        $('.mod-filter-space-field').attr('checked', '');
        return false;
    });

    function checkChildren(value, check) {
        var checked = check ? 'checked' : '';
        $('.child-of-' + value).each(function () {
            $(this).attr('checked', checked);
            checkChildren($(this).val(), check);
        });
    }

    $('.mod-filter-space-field').change(function () {
        checkChildren($(this).val(), $(this).attr('checked'));
    });

    $('.ask-to-answer-switch').click(function () {
        $(this).parents('.summary-wrapper').find('.ask-to-answer-tools').slideToggle('fast');
        $(this).toggleClass('btn-inverse');
        return false;
    });

    $('.ask-to-answer-help').click(function (e) {
        commandUtils.showMessage(e, "<@trans key="thub.label.askToAnswer.help" default="Start typing a username to ask them to answer this question.<br /> Asking someone to answer this question will remove it from moderation,<br/>but it will still be invisible to other users except the asked users." />");
        return false;
    });

    $('.ask-to-answer-tools').each(function () {
        var $this = $(this);

        var $input = $this.find('.expert-search');
        var $askedContainer = $this.find('.asked-to-answer-users');

        var questionId = $this.parents('.moderation-node').attr('nodeId');

        function addAskedUser(id, username) {
            var $askedUser = $('<span class="asked-user" name="' + id + '">' + username + '' + '</span> ');
            $askedUser.append($('<a href="#">x</a>').click(function () {
                $.ajax({
                    url: '<@url name="questions:removeAskToAnswer.json" question="{question}" askedToAnswer="{user}" safe=true />'
                            .replace('{question}', questionId).replace('{user}', id),
                    dataType: 'json',
                    type: 'POST',
                    success: function () {
                        $askedUser.remove();
                    }

                });
                return false;
            }));

            $askedContainer.append($askedUser);
        }

        function reloadList() {
            $.getJSON('<@url name="questions:askedToAnswerList.json" question="{question}" safe=true />'.replace('{question}', questionId), function (data) {
                $askedContainer.empty();
                $.each(data.result.users, function (index, user) {
                    addAskedUser(user.id, user.username);
                });
            });
        }

        reloadList();

        $input.select2({
            escapeMarkup: function (m) {
                return m;
            },
            placeholder: "<@trans key="thub.questions.askToAnswer.users" default="Add user names..."/>",
            minimumInputLength: 3,
            ajax: {
                url: "<@url name="questions:possibleAnswerers.json" />",
                dataType: 'json',
                data: function (term, page) {
                    return {
                        q: term,
                        question: "" + questionId + ""
//                                includeGroups: true
                    };
                },
                results: function (data, page) {
                    return {results: data.result.users};
                }
            },
            multiple: true,
            tokenSeparators: [","],
            dropdownCssClass: "askToAnswerSearchDropdown",
            formatResult: function (item, container, query) {
                var context = {};
                if (item.name) {
                    context.name = item.name;
                } else {
                    context.name = pageContext.userRealName && item.realname ? item.realname : item.username;
                }
                context.user = item;
                return commandUtils.renderTemplate("user-search-template", context).html();
            },
            formatSelection: function (item, container) {
                var context = {};
                if (item.name) {
                    context.name = item.name;
                } else {
                    context.name = pageContext.userRealName && item.realname ? item.realname : item.username;
                }
                context.user = item;
                return commandUtils.renderTemplate("user-search-template", context).html();
            },
            initSelection: function (element, callback) {
                var data = [];
                $(element.val().split(",")).each(function () {
                    data.push({id: this, text: this});
                });
                callback(data);
            }
        });

        $(this).find(".submit").click(function (e) {
            e.preventDefault();
            $.ajax({
                url: '<@url name="questions:advancedAskToAnswer.json" question="{question}" safe=true />'.replace('{question}', questionId),
                data: {
                    askedToAnswer: $input.val().split(",")
                },
                dataType: "json",
                success: function (data) {
                    $input.select2("val", "");
                    reloadList();
                },
                type: "POST"
            });
        });
    });
});
</script>
<#include "../nodes/comment-skeleton.ftl" />
<#include "../nodes/flag-or-close-dialog.ftl" />
<#include "../nodes/wiki-skeleton.ftl" />
<#include "../nodes/user-list-item-skeleton.ftl" />
</head>
<body>
<content tag="sidebarTwoTop">
<#include "sidebar.ftl" />
</content>
<div class="widget">
    <ul class="nav nav-tabs" role="tablist" id="moderationTabs">
        <li <#if !tab?? || (tab?? && tab=="moderation")>class='active'</#if>><a href="<@url name='moderation:list'/>">Moderation</a>
        </li>
        <li <#if tab?? && tab=="reported">class='active'</#if>><a href="<@url name='moderation:list'/>?tab=reported">Reported</a>
        </li>
    </ul>
    <div class="widget-header">
        <h3><#if tab?? && tab == "reported"><@trans key="moderation.reported.list.title" default="Reported content waiting moderation"/><#else><@trans key="moderation.list.title" default="Moderation queue"/></#if></h3>
    </div>

    <div class="widget-content">
    <#if nodesPager.list?size != 0>
        <#list nodesPager.list as node>
            <#include "list_item.ftl">
        </#list>

        <@teamhub.paginate nodesPager />
    <#else>
        <div class="alert alert-info">
            <#if tab?? && tab == "reported">
                    <@trans key="moderation.reported.list.none"/>
                 <#else>
                <#if !queueType?? || queueType == "moderation">
                    <@trans key="moderation.list.none"/>
                <#elseif queueType == "wait-reply">
                    <@trans key="moderation.list.none.waiting-reply" default="No moderated questions waiting for a reply." />
                <#elseif queueType == "replied">
                    <@trans key="moderation.list.none.replied" default="No moderated questions already replied waiting for review." />
                <#else>
                    <@trans key="moderation.list.none.rejected" default="No moderated content was yet rejected." />
                </#if>
            </#if>
        </div>
    </#if>
    </div>
</div>
<script type="text/x-jquery-tmpl" id="user-search-template">
<#--div is there so we can use .html and get what we need from the template-->
<#noparse>
    <div>
        {{if user.avatar}}<img class="gravatar" src="${user.avatar}">{{else}}<i class="icon-group"></i>{{/if}} ${name}
    </div>
</#noparse>
</script>
<div class="hidden" id="ask-to-answer-success">
    <div class="alert alert-success">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <strong><@trans key="thub.label.success" default="Success!"/></strong> <@trans key="thub.questions.askToAnswer.success" />
    </div>
</div>
</body>
</html>