<#import "/macros/teamhub.ftl" as teamhub />
<#import "../macros/security.ftl" as security />
<#import "../nodes/comments.ftl" as commentMacros />

<@relate node=node; rel>

    <#assign isRejected = node.status.custom['rejected']?? />
    <#assign isPendingAction = node.visibility?string == "pendingAction" />
<div id="moderation-node-${node.id}" class="row-fluid short-summary moderation-node" nodeId="${node.id}">
    <div class="span3" style="margin-left: 5px;">
        <div class="well in-review user-info <#if isRejected>deleted</#if>" nodeId="${node.author.id}">
            <#assign postDate><@dateSince date=node.creationDate /></#assign>
            <strong><@trans key="moderation.list.item.details" params=[node.type, postDate]/></strong>

            <div class="gravatar-wrapper">
                <@teamhub.avatar node.author 32 true/>              <@teamhub.objectLink object=node.author content=userUtils.displayName(node.author)/>
            </div>
            <a href="#" command="suspendUser" <#if !node.author.isActive()>class="on"</#if>><#if node.author.isActive()><@trans key="user.suspendUser.command" default="suspend"/><#else><@trans key="user.suspendUser.command.withdraw" default="unsuspend"/></#if></a>
        </div>
    </div>
    <div class="span8 summary-wrapper">
        <h4>
            <#if node.type == "answer"><@trans key="moderation.list.item.inReplyTo" default="In reply to:"/></#if>
            <a title="<@teamhub.clean node.originalParent.title />" href="<@url obj=node />"
               target="_blank"><@teamhub.clean node.originalParent.title /></a>
        </h4>

        <div class="node-body">
        ${node.asHTML()}
        </div>
        <div class="moderation-tools">
            <#if !tab?? || tab != "reported">
                <#if isRejected>
                    <@security.access permission="cancelReject" object=node>
                        <a command="deleteNode" class="on btn btn-mini"
                           href="#"><@trans key="commands.cancelReject" default="cancel reject" /></a>
                    </@security.access>
                <#else>
                    <@security.access permission="reject" object=node>
                        <a command="deleteNode" class="btn btn-mini"
                           href="#"><@trans key="commands.reject" default="reject" /></a>
                    </@security.access>
                </#if>
                <#if rel.canPublish() && !isRejected>
                    <a command="publishNode" class="btn btn-mini"
                       href="#"><@trans key="commands.publish" default="publish" /></a>
                </#if>
                <#if node.type == "question">
                    <@security.access permission="askToAnswer" object=node>
                            <a href="#" class="ask-to-answer-switch btn btn-mini" <#if isPendingAction>on</#if>
                        "><@trans key="label.askToAnswer" default="Ask to Answer" /></a>
                    </@security.access>
                </#if>
            </#if>
            <div id="comment-tools-${node.id}" class="comment-tools">
            <#--<a href="#" class="expand-link">[+]</a>-->
                <a href="#"
                   class="add-comment-link btn btn-mini"><@trans key="moderation.add-mod-talk" default="send message"/></a>
            </div>
        </div>
        <#if node.type == "question">
            <div class="ask-to-answer-tools" <#if !isPendingAction>style="display: none;"</#if>>
                <div class="ask-to-answer-input">
                    <label><@trans key="moderation.askToAnswer.findUsers" default="find user(s)"/> (<a href="#"
                                                                                                       class="ask-to-answer-help"><@trans key="label.help" default="help"/></a>):</label>

                    <div class="asked-to-answer-users"></div>
                    <input class="expert-search" type="text" /> <input type="button" class="submit btn btn-primary"
                                                                      value="<@trans key="moderation.askToAnswer.sendRequest" default="Send"/>"/>
                </div>
            </div>
        </#if>
        <#if getReports??>
            <#assign reports = getReports(node) />
            <#if reports?? && reports?size != 0>
                <strong><@trans key="label.reportsDetails" default="REPORT(S) DETAILS"/></strong>
                <#list reports as report><#if reports?size != 1><hr style="margin-top:5px; margin-bottom:5px" size="1" width="100%" align="left"/></#if>
                    <div style="word-wrap: break-word;">
                        <@teamhub.showUserName user=report.user/> reported on ${report.actionDate?date?string}
                        <#if report.extra?? && report.extra?has_content> -- <i>${report.extra}</i></#if><br/>
                        <#if tab?? && tab=="reported">
                            <a data-reporter="${report.user}" data-node="${node}" command="reportPost" rel="nofollow"
                               class="btn btn-mini ajax-coxmmand on" href="#">
                            </a>
                            <#if rel.canDelete()>
                                <a data-node="${node}" title=""
                                   class="btn btn-mini ajax-command<#if rel.deleted()> on</#if>" command="deletePost"
                                   href="#"><@trans key="label.delete" /></a>
                            </#if>
                        </#if>
                    </div>
                </#list>
            </#if>
        </#if>
    </div>
    <div class="moderation-comment-container">
        <div class="comments-container" id="comments-container-${node.id}">
            <@commentMacros.listComments node />
        </div>
        <#assign parent = node />
        <#include "../nodes/comment_add.ftl" />
        <script type="text/javascript">
            $(function () {
                tools.rel(${rel.commentsJsonRelation});
                setupComments($('#moderation-node-${node.id}'), true, false, tools.roles.pc, 'opAndMod');
            });
        </script>
    </div>
    <hr style="margin-top:5px; margin-bottom:5px" size="1" width="100%" align="left"/>
</div>

</@relate>