<div class="node-list-item question-list-item guide-node-list-item">
    <div class="gravatar-wrapper" style="padding-left: 7px">
        <#if currentUser??>
            <@teamhub.avatar currentUser 32 true/>
            <#else>
                <a style="display: inline-block; max-width: 32px;" href="#">
                    <img width="32" src="https://secure.gravatar.com/avatar/bb6a2e10e6e7529c6a0235fb5124e9a6?d=identicon&amp;r=PG&amp;s=32" class="gravatar ">
                </a>
        </#if>

    </div>
    <div class="info">
        <p><@trans key="thub.guide.list.userAsk" default="You asked"/> </p>
        <h4 class="title"><a href="#"><@trans key="thub.guide.list.question" default="Your question goes here"/></a></h4>

        <p class="last-active-user muted">
            <span class="tags">
                <a class="tag">your</a>
·	            <a class="tag">tags</a>
·	            <a class="tag">here</a>
            </span>
        </p>
    </div>
    <div class="counts">
        <p class="answers muted  unanswered">
            <span>4</span><@trans key="thub.guide.list.replies" default="Replies"/></p>

        <p class="votes muted" id="post-354-score-wrapper">
            <span>12</span><@trans key="thub.guide.list.likes" default="Likes"/></p>
    </div>
    <div class="hidden" id="post-354-users-liked">
    </div>

    <div class="guide-shadow"></div>
    <a class="btn btn-success guide-action-button" href="<@url name="questions:ask"/><#if currentSpace??>?space=${space.id}</#if>"> <@trans key="thub.guide.list.ask" default="Ask Your Question Now"/></a>
</div>