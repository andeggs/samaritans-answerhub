<div class="control-bar" nodeid="${node.id}">
    <div id="post-${node.id}-stats" class="post-stats" nodeid="${node.id}">

        <div id="post-${node.id}-users-liked" class="hidden">
        <#list rel.visibleVotes as like>
            <#if like_index &lt; 15>
            ${userUtils.displayName(like.user)}<br>
            <#else>
                <@trans key="thub.node.likes.soManyMore" params=[rel.visibleVotes?size - 15] />
                <#break>
            </#if>
        </#list>
        </div>
        <div id="post-${node.id}-votes-modal" class="post-votes-modal modal hide fade" tabindex="-1" role="dialog"
             aria-hidden="true" data-backdrop="false">
            <div class="modal-header">
                <h3 id="myModalLabel"><@trans key="thub.node.likes.peopleWhoLike" /></h3>
            </div>
            <div class="modal-body">
                <ul class="clearfix unstyled">

                </ul>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><@trans key="label.close" /></button>
            </div>
        </div>
        <script type="text/javascript">
            if ($("#post-${node.id}-users-liked").children().length > 0) {
                $('#post-${node.id}-score-wrapper').tooltip({
                    html: true,
                    title: $("#post-${node.id}-users-liked").html(),
                    trigger: 'hover'
                })
            }
        </script>
    </div>

    <div class="post-controls" nodeid="${node.id}">
    <#--<a class="share"><i class="icon-share-alt"></i> Share</a>-->
        <#if security.hasRole("ROLE_VOTE_UP") >
        	<a id="vote-up-button-${node.id}" class="vote-up <#if rel.votedUp()> on</#if>" href="#" command="voteUp">Like</i></a>
        &middot;
        </#if>
        <span id="post-${node.id}-score-wrapper"
              class="post-score-wrapper count<#if node.score &gt; 0> positive</#if>"
              <#if currentUser??>data-toggle="modal" data-target="#post-${node.id}-votes-modal"
              <#else>style="cursor:default"</#if>>
            <span id="post-${node.id}-score" class="score<#if node.score &gt; 0> positive</#if>"><i class="icon-thumbs-up"></i> ${node.score}</span>
        </span>
        <#if security.hasRole("ROLE_FAVORITE") >
        <#if node.originalParent.id == node.id>
            &middot;
            <a id="favorite-mark-${node.id}" class="ajax-command action-favorite ajax-command favorite-mark <#if rel.favorite()>on</#if>" href="#" command="markFavorite">
                <#if rel.favorite()><i class="icon-star"></i><#else><i class="icon-star-empty"></i></#if>
            </a>
        </#if>
        </#if>
        <#if security.hasRole("ROLE_COMMENT") >
        &middot;
        <#if node.status.locked??>
            <a class="reply-link-locked"><@trans key="label.comment.locked.verb" /></a>
        <#else>
            <#if currentUser?? && currentUser.canComment(node)>
                <a class="reply-link" href="#"><@trans key="label.comment.verb.${node.typeName}" default=trans("label.comment.verb") /></a>
            <#elseif currentUser??>
                <a id="reply-link-${node.id}" href="#"><@trans key="label.comment.verb.${node.typeName}" default=trans("label.comment.verb") /></a>

                <script type="text/javascript">
                    $(function() {
                        $('#reply-link-${node.id}').click(function() {
                            commandUtils.showMessage('', "<@trans key="label.comment.popup" default ="We're sorry, but you do not have enough permissions to post a comment.</br>If you believe this to be in error, contact your system administrator."/>");
                            return false;
                        });
                    });
                </script>
            <#else>
                <a id="reply-link-${node.id}" href="#"><@trans key="label.comment.verb.${node.typeName}" default=trans("label.comment.verb") /></a>

                <script type="text/javascript">
                    $(function() {
                        $('#reply-link-${node.id}').click(function() {
                            commandUtils.showMessage('', "<@trans key="label.comment.popup2" default ="You must log on to comment."/>");
                            return false;
                        });
                    });
                </script>
            </#if>
        </#if>
     </#if>
    <#if security.hasRole("ROLE_GIVE_REPUTATION") && (currentUser.realReputation >= 0) && (node.type == 'question' || node.originalParent.type == 'question') && (node.author != currentUser)>
        &middot;
        <a href="#" command="giveReputation"><@trans key="label.giveReputation" default ="award points"/></a>
    </#if>
    <#if node.fullCommentCount &gt; 0>
        &middot;
        <a id="${node.id}-show-comments-container" class="show-comments-container" commentCount="${node.fullCommentCount}"><@trans key="thub.questions.view.show-n-comments" params=[node.fullCommentCount] /></a>
    </#if>
    <#if node.type == 'answer'>
        &middot;
        <a href="#" class="ajax-command"
           command="share"><@trans key="commands.share" /></a>
    </#if>
    <#if node.status.accepted??>
        <#if rel.canCancelAccepted()>
            &middot;
            <a href="#" command="acceptAnswer" id="post-${node.id}-accept" title="<@trans key="commands.cancelAccepted" />" class="accept-answer on"><i
               class="icon-ok on"></i> <@trans key="thub.label.unacceptAnswer" /></a></#if>
    <#else>
        <#if rel.canAccept()>
            &middot;
            <a href="#" command="acceptAnswer" id="post-${node.id}-accept" class="accept-answer off" title="<@trans key="commands.accept" />"><i
                    class="icon-ok"></i> <@trans key="thub.label.acceptAnswer" /></a></#if>
    </#if>
        <a id="vote-down-button-${node.id}" class="hidden<#if rel.votedDown()> on</#if>" href="#"
           command="voteDown"></a>
    </div>
</div>