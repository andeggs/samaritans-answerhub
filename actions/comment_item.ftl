<div id="comment-${comment.id}">
    <div class="activity-item activity-comment"><h3><a href="<@url obj=comment.originalParent />">${comment.originalParent.title?html}</a></h3>
        <p class="details"><a href="<@url name="users:profile" user=action.user plug=action.user.username />">${userUtils.displayName(action.user)?html}</a> <#if action.verb != 'commented'>${action.verb}<#else><@trans key="osqa.actions.comment_item.added" default="added"/></#if> <@trans key="osqa.actions.comment_item.a-comment" default="a comment"/> &bull; <a href="<@url obj=comment.parent  />">${comment.parent.comments?size} <@trans key="osqa.actions.comment_item.comments" default="comments,"/></a> ${comment.score} <@trans key="osqa.actions.comment_item.points" default="points"/> &bull; ${action.actionDate?string.short}</p>
        <div class="summary">
            <#assign comment_html = comment.asHTML() />
            <#if (comment_html?length > 172) >${comment_html?substring(0, 172)}...<#else>${comment.asHTML()}</#if>
        </div>
    </div>
</div>