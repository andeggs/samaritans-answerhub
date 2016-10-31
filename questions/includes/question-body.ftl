<#import "/macros/thub.ftl" as teamhub />

<script>
    <#assign node = question />
    <@security.access allowIf='MAKE_STICKY'>
    $(document).ready(function () {
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
    $(document).ready(function () {
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

    var retagUrl = '<@url name="commands:editQuestionTopics" question=question />';


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
        	<div nodeid="${redirectedFrom}">
            	<@trans key="thub.question.alert.redirected" params=[redirectedFrom.title] /> <a title="" class="ajax-command on" command="redirectQuestion" href="#"></a>
        	</div>
        </div>
    </#if>

    <#if question.status.inReview?? || (singleAnswer?? && answer.status.inReview??)>
        <div class="alert alert-warning">
            <@trans key="thub.moderation.alert" default="This post is currently awaiting moderation.  If you believe this to be in error, contact a system administrator."/>
        </div>
    </#if>

    <#if question.status.closed??>
        <div class="alert alert-info question-status">
            <#assign userLink>
                <@teamhub.objectLink question.status.closed.trigger.user userUtils.displayName(question.status.closed.trigger.user)/>
            </#assign>
                <#assign timeAgo><@dateSince date=question.status.closed.trigger.actionDate /></#assign>
               <#assign extraMessage>${teamHubManager.toHTML((question.status.closed.trigger.extra!""))}</#assign>
                <#if !extraMessage?has_content>
                    <@trans key="thub.questionClosed.status.noReason" params=[timeAgo, userLink] />
                <#else>
                    <@trans key="thub.questionClosed.status" params=[timeAgo, userLink] />
                    ${extraMessage}
                </#if>
        </div>
    </#if>
    <#if question.isWiki()>
        <div class="alert alert-info question-status">
            <@trans key="thub.question.wikified" />
        </div>
    </#if>
        <div id="question-container-${question.id}" class="post-container question-container<#if rel.deleted()> deleted</#if>" nodeid="${question.id}">
            <div id="question-${question.id}" class="question post">

            <#include "../../nodes/includes/node_left.ftl" />
            <#assign authorLink>
                <@teamhub.objectLink question.author userUtils.displayName(question.author)/>
                <#if question.author.tagline?? && question.author.tagline != "">, ${question.author.tagline}</#if>
            </#assign>

            <div class="muted author-info">
            <@trans key="thub.question.userAsked" params=[authorLink] /> &middot;
            <#if ((currentUser?? && teamhub.get_node_real_author(question)??) && teamhub.get_node_real_author(question) =  currentUser) || (security.hasRole('ROLE_USE_ANY_ALTEREGO')) >

                <#if !teamhub.is_node_real_author(question)>
                    (
                    <#assign realUser=teamhub.get_node_real_author(question) />
                    <@teamhub.avatar realUser 18 true/>
                    <@teamhub.objectLink realUser userUtils.displayName(realUser)/>
                    )
                </#if>
            </#if>
            <@dateSince date=question.creationDate /> &middot;
                <span class="tags" id="id_tags_container">
                    <#list question.getOrganizedTopics() as topic>
                        <@teamhub.objectLink object=topic content=topic.name class="tag" />
                    </#list>
                    <#if currentUser?? && currentUser.canRetag(question) >
                        <a href="#" title="<@trans key="thub.questions.includes.retag" default="Retag"/>" class="btn-mini" id="id_do_retag"><i class="icon-edit"></i></a>
                    </#if>
                </span>
            <#if currentUser?? && currentUser.canRetag(question) >
                <form id="topics_retag_container" style="display:none" method="post">
                    <input type="hidden" name="node" value="${question.id}"/>
                    <input type="text" id="topics_retag" name="topics" value="<#list question.getOrganizedTopics() as topic>${topic.name}<#if topic_has_next>,</#if></#list>" />
                    <a href="#" class="btn-mini" onclick="submit_retag(); return false;"><i class=" icon-ok"><@trans key="thub.nodes.includes.saveIcon" default="Save"/></i></a>
                    <a href="#" class="btn-mini" id="topics_retag_cancel"><i class=" icon-remove"></i></a>
                </form>
            </#if>
            </div>
            <#if rel.canEdit() || rel.canUseRedirect() || rel.canUseClose() || rel.canReport() || rel.canCancelReport() || rel.canUseDelete() || rel.canUseWiki() ||  rel.canViewRevisions()>
                <div class="post-tools" nodeid="${question.id}">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="icon-cog"></i></a>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                        <#if rel.canEdit() >
                            <li class="item">
                                <a rel="nofollow" class="node-tools-edit-link"
                                   href="<@url name="questions:edit" question=question/>"><i
                                        class="icon-edit"></i> <@trans key="label.edit"/></a>
                            </li></#if>

                        <#if rel.canViewRevisions()>
                            <li class="item">
                                <a rel="nofollow" class="node-tools-revisions-link"
                                   href="<@url name="revisions:view" node=question/>"><@trans key="thub.nodes.post_controls.see.revisions" default="see revisions" /></a>
                            </li>

                        </#if>
                        <#if rel.canUseRedirect()>
                            <li class="item">
                                <a title="" class="ajax-command<#if question.status.redirected??> on</#if>"
                                   command="redirectQuestion" href="#">
                                    <#if question.status.redirected??><@trans key="thub.nodes.post_controls.unredirect"  /><#else><@trans key="quoralike.nodes.post_controls.redirect"  /></#if>
                                </a>
                            </li></#if>

                        <#if rel.canUseClose()>
                            <li class="item">
                                <a class="ajax-command<#if rel.closed()> on</#if>" href="#"
                                   command="closeQuestion"><@trans key="label.close" /></a>
                            </li></#if>

                        <#if rel.canReport() || rel.canCancelReport()>
                            <li class="item">
                                <a rel="nofollow" class="ajax-command<#if rel.reported()> on</#if> " href="#"
                                   command="reportPost">
                                    <#if !rel.reported()><@trans key="label.report" /><#else><@trans key="label.report.cancel" /></#if>
                                    <#if rel.canViewReports()>(${question.reportCount})</#if>
                                </a>
                            </li></#if>

                        <#if rel.canUseDelete()>
                            <li class="item">
                                <a title="" class="ajax-command<#if rel.deleted()> on</#if>" command="deletePost"
                                   href="#"><@trans key="label.delete" /></a>
                            </li></#if>

                        <#if rel.canUseWiki()>
                            <li class="item">
                                <a class="ajax-command<#if question.status.wiki??> on</#if>" href="#"
                                   command="wikifyPost"><@trans key="label.wikify" /></a>
                            </li></#if>

                        <#if !(question.status.closed?? || question.status.inReview?? || question.status.deleted??) >
                            <li class="item">
                                <a class="ajax-command" href="#"
                                   command="sendToMod"><@trans key="commands.sendToMod" /></a>
                            </li>
                        </#if>

                        <#if security.hasPermission("movetospace" question)>
                            <li class="item">
                                <a class="ajax-command" href="#"
                                   command="moveToSpace"><@trans key="commands.moveToSpace" /></a>
                            </li>
                        </#if>

                        <#if rel.canUseLock() >
                            <li class="item">
                                <a class="ajax-command<#if question.status.locked??> on</#if>" href="#"
                                   command="lockPost"><@trans key="commands.lock.link" /></a>
                            </li>
                        </#if>

                        <@security.access allowIf='MAKE_STICKY'>
                            <li class="item">
                                <a class="ajax-command <#if (question.status.custom["sticky"])??> on</#if>" href="#" command="makeSticky"><#if !(question.status.custom["sticky"])??><@trans key="commands.makeSticky" /><#else><@trans key="commands.cancelMakeSticky" /></#if></a>
                            </li>
                        </@security.access>
                        <@security.access allowIf='MAKE_SITE_STICKY'>
                            <li class="item">
                                <a class="ajax-command <#if (question.status.custom["site_sticky"])??> on</#if>" href="#" command="makeSiteSticky"><#if !(question.status.custom["site_sticky"])??><@trans key="commands.makeSiteSticky" /><#else><@trans key="commands.cancelMakeSiteSticky" /></#if></a>
                            </li>
                        </@security.access>
                    </ul>
                </div>
            </#if>
                <h1 class="question-title"><#if question.visibility == 'mod'><i class="icon icon-lock"></i>&nbsp;</#if><@teamhub.clean question.title /></h1>

                <div class="question-body">
                ${question.asHTML()}
                </div>
            <#if question.attachments?? && question.attachments?size != 0>
                <#assign attachments = question.attachments />
                <#include "../attachments.ftl" />
            </#if>

            <div class="comment-tools hidden"><span class="add-comment-link "><a
                    href="#"><@trans key="thub.questions.view.add-new-comment"/></a></span></div>
            <@teamhub.controlBar question rel />
            <#assign parent = question />
            <#include "../../nodes/comment_add.ftl" />
                <div class="comments-container" id="comments-container-${question.id}" nodeid="${question.id}">
                <@commentMacros.listComments question />
                </div>
                <script type="text/javascript">$(function () {
                    setupComments($('#question-container-${question.id}'), true, <#if question.status.locked??>true<#else>false</#if>, croles, "full", <#if autoExpandComments??>true<#else>false</#if>)
                });</script>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var $question = $("#question-container-${question.id}");
        var $replyLink = $question.find(".reply-link");
        $replyLink.click(function (e) {
            e.preventDefault();
            $question.find(".add-comment-link").click();
        });

        $(".ajax-command").click(function () {
            $('.dropdown-toggle').dropdown('toggle');
        });
    })
</script>
