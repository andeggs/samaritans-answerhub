<a name="${comment.id}"></a>
<div class="comment" id="comment-${comment.id}" activerev="${comment.activeRevision.id}" nodeid="${comment.id}" authorid="${comment.author.id}">
   <div class="comment-text">${comment.asHTML()}</div>
   <div class="comment-info" id="comment-${comment.id}-info">
       <#--<span class="comment-age friendly-date" title="${comment.creationDate?string("yyyy, MMM dd 'at' HH:mm:ssZ")}">
            <@dateSince date=comment.creationDate />
       </span>-->
       <a class="comment-user userinfo" href="<@url obj=comment.author/>">${userUtils.displayName(comment.author)} <#if comment.author.superUser>&#9830;&#9830;<#elseif comment.author.moderator>&#9830;</#if></a>
   </div>
</div>
