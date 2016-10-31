<div class="control-bar" nodeid="${node.id}">
    <div class="post-controls" nodeid="${node.id}">
    <#if node.status.locked??>
        <a class="reply-link-locked"><@trans key="label.comment.locked.verb" /></a>
    <#else>
        <#if currentUser?? && currentUser.canComment(node)>
            <a class="reply-link" href="#"><@trans key="label.comment.verb" /></a>
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
            <a id="reply-link-${node.id}" href="#"><@trans key="label.comment.verb" /></a>

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
    </div>
</div>