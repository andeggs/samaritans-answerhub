<#import "/macros/thub.ftl" as teamhub />

<#macro renderSubHit subHit highlight labelKey extraClass="">
    <#assign author><@teamhub.showUserInfo subHit.author /></#assign>
    <#assign date><@dateSince date=subHit.creationDate /></#assign>
    <#if highlight(subHit)??>
    <div class="sub-result-wrapper ${extraClass}">
    ${highlight(subHit)}
        <div>
            <small>
                <@trans key=labelKey params=[author, date] /> /
                <@trans key="thub.searchHit.score" params=[question.score] />
            </small>
        </div>
    </div>
    </#if>
</#macro>

<#macro attachmentResults attachments highlight node>
    <#assign resultAttachments = attachments(node) />

    <#if resultAttachments?size != 0>
        <#list resultAttachments as attachment>
            <div class="attachment-hit">
                <p class="muted author-info"><a href="<@url obj=attachment />">${attachment.name}</a></p>
                <div class="expandable">
                    ${highlight(attachment)}
                </div>
            </div>
        </#list>
    </#if>
</#macro>

<#assign question = hit.result />

<div class="short-summary search-hit">
<#include "../../actions/question_item.ftl" />

<#if hit.resultInSubResults>
    <#if highlight(question)??>
        <div class="question-body expandable">${highlight(question)}</div>
    </#if>
</#if>


<@attachmentResults attachments highlight question />

<#-- todo: make this a setting -->
<#assign subHitsToShow = 3 />

<#list hit.subResultsByType("answer") as answer>
    <div id="answer-container-${answer.id}" class="post-container answer-container clearfix" nodeid="${answer.id}">
        <div id="answer-${answer.id}" class="answer clearfix post">
            <div class="post-gravatar answer-gravatar">
                <@teamhub.avatar answer.author 24 true />
            </div>
            <#assign authorLink><a
                    href="<@url obj=answer.author />">${userUtils.displayName(answer.author)}</a><#if answer.author.tagline?? && answer.author.tagline != "">
                , ${answer.author.tagline}</#if></#assign>
            <p class="muted author-info">
                <@trans key="thub.question.userAnswered" params=[authorLink] /> <span class="post-info muted">&middot;
                <a href="<@url obj=answer />"><@dateSince date=answer.creationDate /></a>
                </span><#if answer.marked><span
                    class="label label-success"><@trans key="thub.question.answer.bestAnswer" /></span></#if></p>

            <div class="expandable answer-body">
                ${highlight(answer)}
            </div>

            <@attachmentResults attachments highlight answer />
        </div>
    </div>

    <#assign subHitsToShow = subHitsToShow - 1 />
    <#if subHitsToShow == 0>
        <#break>
    </#if>
</#list>

<#if subHitsToShow != 0>
    <#list hit.subResultsByType("comment") as comment>
        <div class="comment nsc " id="comment-${comment.id}" activerev="${comment.activeRevision.id}"
             nodeid="${comment.id}" authorid="${comment.author.id}">
            <div class="comment-content" nodeid="${comment.id}">
                <div class="comment-header" nodeid="${comment.id}">
                    <a class="comment-user-gravatar"
                       href="<@url obj=comment.author/>"><@teamhub.avatar user=comment.author size=24 /></a>
                    <a class="comment-user userinfo"
                       href="<@url obj=comment.author/>"><@teamhub.decorateUserName comment.author /></a><#if comment.parent.type == "comment">
                    <span class="comment-parent"><i
                            class="icon-share-alt"></i> ${comment.parent.author.username}</span></#if>
                    <span class="comment-age friendly-date"
                          title="${comment.creationDate?string("yyyy, MMM dd 'at' HH:mm:ssZ")}">
                    &middot;
                        <a href="<@url obj=comment />"><@dateSince date=comment.creationDate /></a>
                </span>
                    <span id="post-${comment.id}-score" class="comment-score">${comment.score}</span>
                </div>
                <div id="comment-${comment.id}-left" class="comment-left">
                    <div id="post-${comment.id}-score" class="comment-score"></div>
                </div>
                <div class="comment-text expandable">${highlight(comment)}</div>

                <@attachmentResults attachments highlight comment />

            </div>
        </div>
        <#assign subHitsToShow = subHitsToShow - 1 />
        <#if subHitsToShow == 0>
            <#break>
        </#if>
    </#list>
</#if>
</div>
