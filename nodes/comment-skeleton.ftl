<#noparse>
<script type="text/x-jquery-tmpl" id="new-comment-skeleton">
<div class="comment nsc" id="comment-${comment.id}" activerev="${comment.activeRevisionId}" nodeid="${comment.id}"
     authorid="${comment.author.id}">
<div class="comment-content" nodeid="${comment.id}">
<div class="comment-header">
    <a class="comment-user-gravatar" nodeId="${author.id}" rel="user" href="${author.url}"><img class="gravatar"
                                                                                                src="${author.avatar}"
                                                                                                style="width:${comment.depth > 0 ? 24 : 36};"></a>
    <a class="comment-user userinfo" nodeId="${author.id}" rel="user" href="${author.url}">${(pageContext.userRealName && comment.author.realname)? comment.author.realname : comment.author.username}</a>
    {{if comment.parentId != comment.originalParentId}}<span class="comment-parent"><i class="icon-share-alt"></i> ${(pageContext.userRealName && comment.parentAuthor.realname)?comment.parentAuthor.realname : comment.parentAuthor.username}</span>
    {{/if}}
    <span class="comment-age friendly-date" title="${creationDateFormatted}">
                &middot; ${commentDateFriendly}
            </span>
<div class="comment-info btn-broup" id="comment-${comment.id}-info">
    <span id="post-${comment.id}-score" class="comment-score">${comment.score}</span>
        <a id="vote-up-button-${comment.id}" command="voteUp" </#noparse> href="#" class="make-tooltip"
           title="<@trans key="thub.comments.upvote" />"><@trans key="thub.node.vote.default" /> </a>
        <#noparse><a id="vote-down-button-${comment.id}" command="voteDown" href="#" class="make-tooltip"
        </#noparse> title="<@trans key="thub.comments.upvote" />"><i class=" icon-chevron-down"></i><#noparse></a>

        </#noparse>
        {{if crel.canComment }}
        <#if enableThreadedComments?? && enableThreadedComments == true>
            <#noparse><a id="comment-${comment.id}-reply" href="#" class="comment-reply"><i
                class="icon-reply"></i> </#noparse><@trans key="thub.questions.view.comment.reply" /><#noparse></a></#noparse>
        </#if>
        {{/if}}

        <a href="#" class="ajax-command"
                           command="share"><@trans key="commands.share" /></a>

        {{if (crel.canReport || crel.canCancelReport) || crel.canEdit || crel.canDelete || crel.canConvertToAnswer }}

        <div class="dropdown" style="display:inline">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                <i class=" icon-cog"></i> <@trans key="thub.comments.more" /></a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                {{if crel.canReport || crel.canCancelReport }}
                    <li><a rel="nofollow" class="ajax-coxmmand {{if crel.reported }} on{{/if}}" href="#"
                           command="reportPost">


                        {{if !crel.reported }}123<@trans key="label.report" default="Flag" />{{else}}<@trans key="label.report.cancel" />{{/if}}
                        {{if crel.canViewReports }}(${r"${comment.reportCount}"}){{/if}}
                    </a></li>
                {{/if}}
                {{if crel.canViewRevisions }}
                    <li class="item">
                        <a rel="nofollow" class="node-tools-revisions-link"
                           href="${r"${revisionUrl}"}"><@trans key="thub.nodes.post_controls.see.revisions" default="see revisions" /></a>
                    </li>

                {{/if}}
                {{if crel.canEdit }}
                    <li><a id="comment-${r"${comment.id}"}-edit" href="#"
                           class="comment-edit"><@trans key="thub.questions.view.comment.edit" /></a>
                    </li>
                {{/if}}
                {{if crel.canDelete }}
                    <li><a id="comment-${r"${comment.id}"}-delete" href="#" class="comment-delete"
                           command="deleteComment"><@trans key="thub.questions.view.comment.delete" /> </a>
                    </li>
                {{/if}}
                {{if crel.canConvertToAnswer }}
                    <li><a href="#" class="convert-to-answer"
                           command="convertToAnswer"><@trans key="thub.questions.view.convert-to-answer" /></a>
                    </li>
                {{/if}}
            </ul>
        </div>

        {{/if}}

<#noparse>
</div>
</div>
    <div id="comment-${comment.id}-left" class="comment-left">
        <div id="post-${comment.id}-score" class="comment-score"></div>
    </div>
    <div class="comment-text">{{html comment.bodyAsHTML}}</div>
</div>
</div>
</script>
</#noparse>
