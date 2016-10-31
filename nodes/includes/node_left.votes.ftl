<#if !extraStylesIncluded??>
<style type="text/css">
    .question-body, .node-body {
        min-height: 50px;
    }

    .answer-body, .reply-body {
        min-height: 115px;
    }
</style>
</#if>

<#assign extraStylesIncluded = true />
<#if arel??>
    <#assign localrel = arel/>
<#else>
    <#assign localrel = rel/>
</#if>

<div class="post-gravatar ${node.type}-gravatar" nodeId="${node.id}">
    <@teamhub.avatar node.author 48 true/>
    <div class="vote-widget">
        <a id="vote-up-button-${node.id}" class="vote-up votes<#if localrel.votedUp()> on</#if>" href="#" command="voteUp"><i class="icon-chevron-up icon-2x"></i></i></a>
        <span id="post-${node.id}-score-wrapper" class="post-score-wrapper count votes<#if node.score &gt; 0> positive</#if>" <#if currentUser??>data-toggle="modal" data-target="#post-${node.id}-votes-modal" <#else>style="cursor:default"</#if>>
            <span id="post-${node.id}-score" class="score<#if node.score &gt; 0> positive</#if>">${node.score}</span>
        </span>
        <a id="vote-down-button-${node.id}" class="vote-down votes<#if localrel.votedDown()> on</#if>" href="#" command="voteDown"><i class="icon-chevron-down icon-2x"></i></a>
        <#if node.originalParent.id == node.id>
            <a id="favorite-mark-${node.id}" class="ajax-command action-favorite ajax-command favorite-mark <#if rel.favorite()>on</#if>" href="#" command="markFavorite">
                <#if rel.favorite()><i class="icon-star"></i><#else><i class="icon-star-empty"></i></#if>
            </a>
        </#if>
    </div>
</div>