<#import "/macros/thub.ftl" as teamhub />

<div class="comment nsc " id="comment-${comment.id}" activerev="${comment.activeRevision.id}" nodeid="${comment.id}"
     authorid="${comment.author.id}">
    <div class="comment-content" nodeid="${comment.id}">
        <div class="comment-header">
        <@teamhub.avatar user=comment.author size=24 cssClass="comment-user-gravatar"/>

            <span class="comment-age friendly-date"
                  title="${comment.creationDate?string("yyyy, MMM dd 'at' HH:mm:ssZ")}">
                       <a href="<@url obj=comment />"><@dateSince date=comment.creationDate />   </a>
                    </span>


        </div>
        <div id="comment-${comment.id}-left" class="comment-left">
            <div id="post-${comment.id}-score" class="comment-score"></div>
        </div>
        <div class="comment-text">${comment.asHTML()}</div>
    <#if comment.attachments?? && comment.attachments?size != 0>
        <#assign attachments = comment.attachments />
        <#include "/questions/attachments.ftl" />
    </#if>
    </div>
</div>