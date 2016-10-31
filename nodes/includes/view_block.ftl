<#import "/macros/thub.ftl" as teamhub />
<#assign node = content />
<head>
    <#include "../../scripts/cmd_includes/node.commands.ftl" />
    <script type="text/javascript">
        $(function () {
            <#include "../comments-js-vars.ftl" />
            <#include "../answers-js-vars.ftl" />
            <#include "../../questions/includes/question-tools-init.ftl" />
            <@security.isAuthenticated>
                initCommandOverrides();
            </@security.isAuthenticated>
        });
    </script>
    <content tag="packJS">
        <src>/scripts/ahub.viewquestion.js</src>
        <src>/scripts/ahub.form.attachments.js</src>
    </content>
</head>

<script>

    <@security.access allowIf='MAKE_STICKY'>
    $(function () {
        register_command('makeSticky', {
            onSuccess: function (data) {
                commandUtils.reloadPage();
            }
        });
        commands.makeSticky.setMsg('linkText.on', "Undo sticky");
        commands.makeSticky.setMsg('linkText.off', "Make sticky");

        commands.makeSticky.setUrl('click.off', "<@url name="commands:cMetadata:apply.json" node="%ID%" mdType="sticky" />");
        commands.makeSticky.setUrl('click.on', "<@url name="commands:cMetadata:cancel.json" node="%ID%" mdType="sticky" />");
    });
    </@security.access>

    <@security.access allowIf='MAKE_SITE_STICKY'>
    $(function () {
        register_command('makeSiteSticky', {
            onSuccess: function (data) {
                commandUtils.reloadPage();
            }
        });
        commands.makeSiteSticky.setMsg('linkText.on', "Undo site sticky");
        commands.makeSiteSticky.setMsg('linkText.off', "Make site sticky");

        commands.makeSiteSticky.setUrl('click.off', "<@url name="commands:cMetadata:apply.json" node="%ID%" mdType="site_sticky" />");
        commands.makeSiteSticky.setUrl('click.on', "<@url name="commands:cMetadata:cancel.json" node="%ID%" mdType="site_sticky" />");
    });
    </@security.access>

    var jsonTopicSearch = '<@url name="topicsSearch.json" />';

    var retagUrl = '<@url name="commands:editQuestionTopics" question=content />';


    function submit_retag() {
        $.post(retagUrl, $("#topics_retag_container").serializeArray(), function (data) {
            document.location.reload();
        });
    }
    function setup_retag() {
        $("#topics_retag_container").css("display", "inline");
//        $("#topics_retag_container").show();

        $("#id_tags_container").hide();
        $("#topics_retag").select2({
            placeholder: '<@trans key="thub.ask.topics.placeholder" default="Enter topics..." />',
            minimumInputLength: 1,
            width: "250px",
            ajax: {
                url: jsonTopicSearch,
                dataType: 'json',
                data: function (term, page) {
                    return {
                        q: term
                    };
                },
                results: function (data, page) {
                    for (var i = 0; i < data.topics.length; i++) {
                        data.topics[i].text = data.topics[i].name;
                        data.topics[i].id = data.topics[i].name;
                    }
                    return {results: data.topics};
                }
            },
            tokenSeparators: [","],
            tags: true,
            createSearchChoice: function (term) {
                return {id: term, text: term};
            },
            formatResult: function (item, container, query, escapeMarkup){
                return escapeMarkup(item.text);
            },
            formatSelection: function(item,container, escapeMarkup) {
                return escapeMarkup(item.text);
            },
            initSelection: function (element, callback) {
                var data = [];
                $(element.val().split(",")).each(function () {
                    data.push({id: this, text: this});
                });
                callback(data);
            }
        });


    }
    $(document).ready(function () {
        $("#id_do_retag").click(function () {
            setup_retag();
            return false;
        });

        $("#topics_retag_cancel").click(function () {

            $("#topics_retag_container").hide();
            $("#id_tags_container").show();
        });
    });
</script>

<div class="widget widget-nopad smallmargin" xmlns="http://www.w3.org/1999/html">
    <div class="widget-content">
    <#if redirectedFrom??>
        <div class="alert alert-warning">
            <@trans key="thub.node.alert.redirected" params=[redirectedFrom.title] />
        </div>
    </#if>
    <#if content.status.closed??>
        <div class="alert alert-info node-status">
            <#assign userLink>
                <@teamhub.objectLink content.status.closed.trigger.user userUtils.displayName(content.status.closed.trigger.user)/>
            </#assign>
                <#assign timeAgo><@dateSince date=content.status.closed.trigger.actionDate /></#assign>
                <#assign extraMessage>${content.status.closed.trigger.extra!""}</#assign>
                <@trans key="thub.questionClosed.status" params=[timeAgo, userLink] />
            ${extraMessage}
        </div>
    </#if>

    <#if content.status.inReview??>
        <div class="alert alert-warning node-status">
            <@trans key="thub.moderation.alert" default="This post is currently awaiting moderation.  If you believe this to be in error, contact a system administrator."/>
        </div>
    </#if>


        <div nodeid="${content.id}" id="${contentType}-container-${content.id}" class="post-container ${contentType}-container <#if rel.deleted()> deleted</#if>">
            <div id="${contentType}-${content.id}" class="${contentType} post">
            <#include "node_left.ftl" />

            <#assign authorLink>
                <@teamhub.objectLink content.author userUtils.displayName(content.author)/>
                <#if content.author.tagline?? && content.author.tagline != "">, ${content.author.tagline}</#if>
            </#assign>

            <p class="muted author-info">
            <@trans key=".${contentType}.label.posted" params=[authorLink] /> &middot;
            <#--<#if (currentUser?? && answerhub.get_node_real_author(content) =  currentUser) || (security.hasRole('ROLE_USE_ANY_ALTEREGO')) >-->
            <#if (currentUser?? && content.author ==  currentUser) || (security.hasRole('ROLE_USE_ANY_ALTEREGO')) >
            <#--<#if !answerhub.is_node_real_author(content)>-->
                <#if false>
                    (
                <#--<#assign realUser=answerhub.get_node_real_author(content) />-->
                    <#assign realUser=content.author />
                    <@teamhub.avatar realUser 18 true/>
                    <@teamhub.objectLink realUser userUtils.displayName(realUser)/>
                    )
                </#if>
            </#if>
            <@dateSince date=content.creationDate /> &middot;
                <span class="tags" id="id_tags_container">
                    <#list content.topics as topic>
                        <@teamhub.objectLink object=topic content=topic.name class="tag" />
                    </#list>
                    <#if rel.canEdit() >
                        <a href="#" title="<@trans key="thub.questions.includes.retag" default="Retag"/>" class="btn-mini" id="id_do_retag"><i class="icon-edit"></i></a>
                    </#if>
                    </span>
            <#if rel.canEdit() >
                <form id="topics_retag_container" style="display:none" method="post">
                    <input type="hidden" name="node" value="${content.id}"/>

                    <input type="text" id="topics_retag" name="topics"
                           value="<#list content.topics as topic>${topic.name}<#if topic_has_next>,</#if></#list>"
                            />
                    <a href="#" class="btn-mini" onclick="submit_retag(); return false;"><i
                            class=" icon-ok"><@trans key="thub.nodes.includes.saveIcon" default="Save"/></i></a>

                    <a href="#" class="btn-mini" id="topics_retag_cancel"><i class=" icon-remove"></i></a>
                </form>
            </#if>
                </p>
            <#assign controlNode = content />
            <@content.include path="/nodes/includes/controls_block.ftl" />
                <h1 class="${contentType}-title node-title"><#if controlNode.visibility == 'mod'><i class="icon icon-lock"></i>&nbsp;</#if><@teamhub.clean content.title /></h1>

                <div class="${contentType}-body node-body">
                ${content.asHTML()}
                </div>
            <#if content.attachments?? && content.attachments?size != 0>
                <#assign attachments = content.attachments />
                <#include "../../questions/attachments.ftl" />
            </#if>
                <div class="comment-tools hidden"><span class="add-comment-link "><a
                        href="#"><@trans key="thub.nodes.view.add-new-comment"/></a></span></div>

            <@teamhub.controlBar content rel />
            <#assign parent = content />
            <#include "../comment_add.ftl" />
                <div class="comments-container" id="comments-container-${content.id}" nodeid="${content.id}">
                <@commentMacros.listComments content />
                </div>
                <script type="text/javascript">$(function () {
                    setupComments($('#${contentType}-container-${content.id}'), true, <#if content.status.locked??>true<#else>false</#if>, croles)
                });
                </script>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var $question = $("#${contentType}-container-${content.id}");
        var $replyLink = $question.find(".reply-link");
        $replyLink.click(function (e) {
            e.preventDefault();
            $question.find(".add-comment-link").click();
        });

    <#if !teamhub.getSetting("attachments.comment.enable")>
        removePluginFromConfig("upload", "comment");
    </#if>
        commandUtils.initializeLabels();
    })
</script>

<#include "../comment-skeleton.ftl" />
<#include "../flag-or-close-dialog.ftl" />
<#include "../wiki-skeleton.ftl" />
<#include "../user-list-item-skeleton.ftl" />
