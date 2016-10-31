<#import "/macros/thub.ftl" as teamhub />

<#macro listComments node>
    <@commentsThread node=node; loopInfo>
        <@relate node=loopInfo.comment; crel>
        <span name="${loopInfo.comment.id}"></span>
        <div class="comment nsc " id="comment-${loopInfo.comment.id}" activerev="${loopInfo.comment.activeRevision.id}"
             nodeId="${loopInfo.comment.id}" authorid="${loopInfo.comment.author.id}">
            <div class="comment-content" nodeId="${loopInfo.comment.id}">
                <div class="comment-header" nodeId="${loopInfo.comment.id}">
                    <#if loopInfo.comment.visibility != 'full'>
                            <#assign recipients><#compress>
                                    <#list loopInfo.comment.recipients as recip>${recip.name}<#if recip_has_next>, </#if></#list>
                            </#compress></#assign>
                            <i class="icon-lock" title="Visible to: ${recipients?html}"></i>&nbsp;
                    </#if>
                    <@teamhub.avatar user=loopInfo.comment.author size=24 link=true cssClass="comment-user-gravatar"/>
                    <#assign content>
                        <@teamhub.decorateUserName loopInfo.comment.author />
                    </#assign>
                    <@teamhub.objectLink object=loopInfo.comment.author content=content class="comment-user userinfo"/>
                    <#if (currentUser?? && teamhub.get_node_real_author(loopInfo.comment) =  currentUser ) || (security.hasRole('ROLE_USE_ANY_ALTEREGO')) >

                        <#if !teamhub.is_node_real_author(loopInfo.comment)>
                            (
                            <#assign realUser=teamhub.get_node_real_author(loopInfo.comment) />
                            <@teamhub.avatar realUser 12 true/>
                            <@teamhub.objectLink realUser userUtils.displayName(realUser)/>
                            )
                        </#if>
                    </#if>
                    <#if loopInfo.comment.parent.type == "comment"> <span class="comment-parent"><i
                            class="icon-share-alt"></i> <@teamhub.decorateUserName loopInfo.comment.parent.author /></span></#if>
                    <span class="comment-age friendly-date"
                          title="${loopInfo.comment.creationDate?string("yyyy, MMM dd 'at' HH:mm:ssZ")}">
                        &middot;
                        <a href="<@url obj=loopInfo.comment />"><@dateSince date=loopInfo.comment.creationDate /></a>
                    </span>
                    <span id="post-${loopInfo.comment.id}-score" class="comment-score">${loopInfo.comment.score}</span>
                    <div class="comment-info" id="comment-${loopInfo.comment.id}-info">

                        <a id="vote-up-button-${loopInfo.comment.id}" command="voteUp" href="#" class="make-tooltip vote-up <#if crel.votedUp()>on</#if>"
                           title="<@trans key="thub.comments.upvote" />"><i class=" icon-chevron-up"></i></a>

                        <a id="vote-down-button-${loopInfo.comment.id}" command="voteDown" href="#" class="make-tooltip vote-down <#if crel.votedDown()>on</#if>"
                           title="<@trans key="thub.comments.downvote" />"><i class=" icon-chevron-down"></i></a>


                        <#if crel.canComment()>
                            <#if enableThreadedComments?? && enableThreadedComments == true>
                                        <a id="comment-${loopInfo.comment.id}-reply" href="#" class="comment-reply"><i
                                                class="icon-reply"></i> <@trans key="thub.questions.view.comment.reply" /></a>
                            </#if>
                        </#if>

                        <a href="#" class="ajax-command"
                           command="share"><@trans key="commands.share" /></a>

                        <#if (crel.canReport() || crel.canCancelReport()) || crel.canEdit() || crel.canDelete() || crel.canConvertToAnswer()>

                        <div class="dropdown" style="display:inline">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                <i class=" icon-cog"></i> <@trans key="thub.comments.more" /></a>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <#if crel.canReport() || crel.canCancelReport()>
                                    <li><a rel="nofollow" class="ajax-coxmmand <#if crel.reported()> on</#if>" href="#"
                                           command="reportPost">


                                        <#if !crel.reported()><@trans key="label.report" default="Flag" /><#else><@trans key="label.report.cancel" /></#if>
                                        <#if crel.canViewReports()>(${loopInfo.comment.reportCount})</#if>
                                    </a></li>
                                </#if>
                                <#if crel.canViewRevisions()>
                                    <li class="item">
                                        <a rel="nofollow" class="node-tools-revisions-link"
                                           href="<@url name="revisions:view" node=loopInfo.comment/>"><@trans key="thub.nodes.post_controls.see.revisions" default="see revisions" /></a>
                                    </li>

                                </#if>
                                <#if crel.canEdit()>
                                    <li><a id="comment-${loopInfo.comment.id}-edit" href="#"
                                           class="comment-edit"><@trans key="thub.questions.view.comment.edit" /></a>
                                    </li></#if>
                                <#if crel.canDelete()>
                                    <li><a id="comment-${loopInfo.comment.id}-delete" href="#" class="comment-delete"
                                           command="deleteComment"><@trans key="thub.questions.view.comment.delete" /> </a>
                                    </li></#if>
                                <#if crel.canConvertToAnswer()>
                                    <li><a href="#" class="convert-to-answer"
                                           command="convertToAnswer"><@trans key="thub.questions.view.convert-to-answer" /></a>
                                    </li></#if>
                            </ul>
                        </div>
                        </#if>


                    </div>
                </div>
                <div id="comment-${loopInfo.comment.id}-left" class="comment-left">
                    <div id="post-${loopInfo.comment.id}-score" class="comment-score"></div>
                </div>
                <div class="comment-text">${loopInfo.comment.asHTML()}</div>

                <#if loopInfo.comment.attachments?? && loopInfo.comment.attachments?size != 0>
                    <#assign attachments = loopInfo.comment.attachments />
                    <#include "/questions/attachments.ftl" />
                </#if>
            </div>
            <@listReplies />
            <#if !loopInfo.displayChildren && loopInfo.comment.commentCount &gt; 0>
            <a href="#" class="comments-expand"><@trans key="thub.comment.showMore.noCount" /></a>
            </#if>
        </div>
        <#if loopInfo.needsExpansion >
        <a href="#" class="comments-expand"><@trans key="thub.comment.showMore.noCount" /></a>
        </#if>
        </@relate>
    </@commentsThread>
</#macro>

