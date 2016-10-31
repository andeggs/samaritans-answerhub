<#import "/macros/thub.ftl" as teamhub />
<div class="short-summary">
    <div class="counts">
        <div class="votes">
            <div class="item-count">${answer.score}</div>
        </div>
    </div>

    <div class="question-summary-wrapper">
        <h2><a title="${answer.parent.title?html}" href="<@url obj=answer />">${answer.parent.title?html}</a></h2>

        <div class="userinfo">
            <span class="relativetime">${answer.creationDate}</span>
        <@teamhub.objectLink answer.author userUtils.displayName(answer.author) />
        <span class="score" title="${answer.author.reputation} karma"><#if question??>
            span class="">${question.author.reputation}</span></#if></span>

        </div>
    </div>

</div>
