<script type="text/javascript">
    <@cache key="view_question_header_${requestInfo.locale?string}" subject=question>
    commands.likeComment.setMsg('title.on', "${trans("commands.comment.cancel.like")?js_string}");
    commands.likeComment.setMsg('title.off', "${trans("commands.comment.like")?js_string}");

    commands.likeComment.setUrl('click.on', "<@url name="commands:cancelVote.json" node="%ID%" />");
    commands.likeComment.setUrl('click.off', "<@url name="commands:voteUp.json" node="%ID%" />");

    commands.deleteComment.setUrl('click.off', "<@url name="commands:delete.json" node="%ID%" />");

    commands.voteUp.urls = commands.likeComment.urls;

    commands.voteUp.setMsg('title.on',  "${trans("commands.cancelVote")?js_string}");
    commands.voteUp.setMsg('title.off',  "${trans("commands.voteUp")?js_string}");

    commands.voteDown.setUrl('click.on', commands.voteUp.urls['click.on']);
    commands.voteDown.setUrl('click.off', "<@url name="commands:voteDown.json" node="%ID%" />");

    commands.voteDown.setMsg('title.on',  commands.voteUp.messages['title.on']);
    commands.voteDown.setMsg('title.off', "${trans("commands.voteDown")?js_string}");

    commands.acceptAnswer.setUrl('click.on', "<@url name="commands:unaccept.json" node="%ID%" />");
    commands.acceptAnswer.setUrl('click.off', "<@url name="commands:accept.json" node="%ID%" />");

    commands.markFavorite.setMsg('title.on', "${trans("commands.cancelFavorite")?js_string}");
    commands.markFavorite.setMsg('title.off', "${trans("commands.favorite")?js_string}");

    commands.markFavorite.setUrl('click.on', "<@url name="commands:unmarkFavorite.json" node="%ID%" />");
    commands.markFavorite.setUrl('click.off', "<@url name="commands:markFavorite.json" node="%ID%" />");

    commands.reportPost.setMsg('title.on', "${trans("commands.cancelReport")?js_string}");
    commands.reportPost.setMsg('title.off', "${trans("commands.report")?js_string}");
    commands.reportPost.setMsg('link.on', "${trans("commands.cancelReport.link")?js_string}");
    commands.reportPost.setMsg('link.off', "${trans("commands.report.link")?js_string}");
    commands.reportPost.setMsg('description', "${trans("commands.report.description")?js_string}");

    commands.reportPost.setMsg('reportHints', [
        "${trans("commands.report.hint.1")?js_string}",
        "${trans("commands.report.hint.2")?js_string}",
        "${trans("commands.report.hint.3")?js_string}",
        "${trans("commands.report.hint.4")?js_string}",
        "${trans("commands.report.hint.5")?js_string}",
        "${trans("commands.report.hint.6")?js_string}",
        "${trans("commands.report.hint.7")?js_string}",
        "${trans("commands.report.hint.8")?js_string}",
        "${trans("commands.report.hint.9")?js_string}"]);


    commands.reportPost.setUrl('click.on', "<@url name="commands:cancelReport.json" node="%ID%" />");
    commands.reportPost.setUrl('click.off', "<@url name="commands:report.json" node="%ID%" />");

    commands.publishPost.setUrl('click', "<@url name="commands:publish.json" node="%ID%" />");
    commands.publishPost.setMsg('linkText', "${trans("commands.publish")?js_string}");

    commands.sendToMod.setUrl('click', "<@url name="commands:sendToMod.json" node="%ID%" />");
    commands.sendToMod.setMsg('linkText', "${trans("commands.sendToMod")?js_string}");

    commands.redirectQuestion.setMsg('linkText.off', "${trans("commands.redirect.link")?js_string}");
    commands.redirectQuestion.setMsg('linkText.on', "${trans("commands.unredirect.link")?js_string}");
    commands.redirectQuestion.setMsg('header', "${trans("commands.redirect.header")?js_string}");
    commands.redirectQuestion.setMsg('search', "${trans("commands.redirect.search")?js_string}");
    commands.redirectQuestion.setMsg('related', "${trans("commands.redirect.related")?js_string}");

    commands.redirectQuestion.setUrl('click.off', "<@url name="commands:redirect.json" question="%ID%" />");
    commands.redirectQuestion.setUrl('click.on', "<@url name="commands:unredirect.json" question="%ID%" />");
    commands.redirectQuestion.setUrl('search', "<@url name="search.json" />");

    commands.deletePost.urls = commands.deleteComment.urls;
    commands.deletePost.setUrl('click.on', "<@url name="commands:undelete.json" node="%ID%" />");

    commands.deletePost.setMsg('linkText.off', "${trans("commands.delete")?js_string}");
    commands.deletePost.setMsg('linkText.on', "${trans("commands.undelete")?js_string}");

    commands.closeQuestion.setMsg('linkText.on', "${trans("commands.reopen.link")?js_string}");
    commands.closeQuestion.setMsg('linkText.off', "${trans("commands.close.link")?js_string}");
    commands.closeQuestion.setMsg('description', "${trans("commands.close.description")?js_string}");
    commands.closeQuestion.setMsg('lock', "${trans("commands.close.lock")?js_string}");

    commands.closeQuestion.setMsg('reportHints', [
        "${trans("commands.close.hint.1")?js_string}",
        "${trans("commands.close.hint.2")?js_string}",
        "${trans("commands.close.hint.3")?js_string}",
        "${trans("commands.close.hint.4")?js_string}",
        "${trans("commands.close.hint.5")?js_string}",
        "${trans("commands.close.hint.6")?js_string}"]);

    commands.closeQuestion.setUrl('click.on', "<@url name="commands:reopen.json" node="%ID%" />");
    commands.closeQuestion.setUrl('click.off', "<@url name="commands:close.json" node="%ID%" />");

    commands.lockPost.setMsg('linkText.on', "${trans("commands.unlock.link")?js_string}");
    commands.lockPost.setMsg('linkText.off', "${trans("commands.lock.link")?js_string}");
    commands.lockPost.setMsg('description', "${trans("commands.lock.description")?js_string}");

    commands.lockPost.setMsg('reportHints', [
        "${trans("commands.lock.hint.1")?js_string}",
        "${trans("commands.lock.hint.2")?js_string}",
        "${trans("commands.lock.hint.6")?js_string}"]);

    commands.lockPost.setUrl('click.on', "<@url name="commands:unlock.json" node="%ID%" />");
    commands.lockPost.setUrl('click.off', "<@url name="commands:lock.json" node="%ID%" />");

    commands.wikifyPost.setMsg('linkText.off', "${trans("commands.wikify.link")?js_string}");
    commands.wikifyPost.setMsg('linkText.on', "${trans("commands.cancelWiki.link")?js_string}");

    commands.wikifyPost.setUrl('click.on', "<@url name="commands:cancelWiki.json" node="%ID%" />");
    commands.wikifyPost.setUrl('click.off', "<@url name="commands:wikify.json" node="%ID%" />");

    commands.convertToComment.setUrl('click', "<@url name="commands:convertToComment.json" answer="%ID%" />");
    commands.convertToComment.setUrl('candidates', "<@url name="commands:convertToComment:possibleParents.json" answer="%ID%" />");
    commands.convertToComment.setMsg('linkText', "${trans("commands.convertToComment")?js_string}");
    commands.convertToComment.setMsg('description', "${trans("commands.convertToComment.prompt")?js_string}");
    commands.convertToComment.setMsg('question', "${trans("node.type.question")?js_string}");
    commands.convertToComment.setMsg('answer', "${trans("node.type.answer")?js_string}");

    commands.convertToAnswer.setUrl('click', "<@url name="commands:convertToAnswer.json" comment="%ID%" />");

    commands.moveToSpace.setUrl('click', "<@url name="commands:moveToSpace.json" node="%ID%" />");
    commands.moveToSpace.setUrl('candidates', "<@url name="spaces:moveToCandidates" node="%ID%" />");
    commands.moveToSpace.setMsg('linkText', "${trans("commands.moveToSpace")?js_string}");
    commands.moveToSpace.setMsg('description', "${trans("commands.moveToSpace.prompt")?js_string}");

	commands.switchPrivacy.setMsg('linkText.off', "<@trans key="commands.makePrivate.link" default="Make private" />");
    commands.switchPrivacy.setMsg('linkText.on', "<@trans key="commands.makePublic.link" default="Make public"  />");

    commands.switchPrivacy.setUrl('click.on', "<@url name="commands:makePublic.json" node="%ID%" />");
    commands.switchPrivacy.setUrl('click.off', "<@url name="commands:makePrivate.json" node="%ID%" />");

    commands.giveReputation.setUrl('click', "<@url name="commands:giveReputation.json" />");
    commands.giveReputation.setMsg('answerIntro', "${trans("commands.giveReputation.prompt")?js_string}");
    commands.giveReputation.setMsg('questionIntro', "${trans("commands.giveReputation.prompt3")?js_string}");
    commands.giveReputation.setMsg('description', "${trans("commands.giveReputation.prompt2")?js_string}");
    commands.giveReputation.setMsg('points', "${trans("commands.giveReputation.points")?js_string}");

    commands.share.setUrl("answer-url", "<@url name="answers:view" answer="%ID%" abs=true />");
    commands.share.setUrl("comment-url", "<@url name="comments:view" comment="%ID%" abs=true />");
    commands.share.setMsg("description", "${trans("commands.share.prompt")?js_string}");
    commands.share.setMsg("comment-description", "${trans("commands.share.prompt.comment")?js_string}");
    commands.share.setMsg("title", "${trans("commands.share.title")?js_string}");
    commands.share.setMsg("comment-title", "${trans("commands.share.title.comment")?js_string}");

    pageContext.i18n.seeRevisions = '${trans("commands.nodes.post_controls.see.revisions")?js_string}';
    pageContext.url.seeRevisions = '<@url name="revisions:view" node="%ID%" />';
    pageContext.url.questionEdit = '<@url name="questions:edit" question="%ID%"/>';
    pageContext.url.answerEdit = '<@url name="answers:edit" answer="%ID%"/>';
    pageContext.url.commentEdit = '<@url name="comments:edit" comment="%ID%"/>';
    </@cache>

    <#if currentUser??>
    commands.giveReputation.setMsg('currentPointsLabel', "${trans("commands.giveReputation.currentPoints", [currentUser.reputation])?js_string}");
    </#if>
</script>
<script type="text/x-jquery-tmpl" id="give-reputation-dialog">
<#noparse>
        <p style="font-size:14px;">{{if isAnswer }} ${answerIntro} {{/if}} {{if !isAnswer }} ${questionIntro} {{/if}}</p>
        <p style="font-size:14px;">${description}</p>
        <form >
            <div style="font-size:14px;">
                ${points} <input class="input-mini" style="margin-top: 10px;" type="text" name="points" /> (${currentUserPoints} ${currentPointsLabel})
            </div>
        </form>
        <p style="color:red" id="invaliderror"></p>
</#noparse>
</script>
<script type="text/x-jquery-tmpl" id="flag-or-close-post-dialog">

<#noparse>
    <p>${description}</p>

    <form style="with: 250px;margin-bottom:10px">
      <p>  <select name="sample" class="prompt-examples" style="width: 100%;">
            {{each(i, hint) reportHints }}
            <option value="${hint}">${hint}</option>
            {{/each}}
        </select>

          </p>
        <p><textarea name="prompt" style="width: 100%; padding: 0;"></textarea>
        {{if canLock }}
        <input type="checkbox" name="lock" value="true" /> ${lock}
        {{/if}}
        </p>
    </form>

</#noparse>
</script>
<script type="text/x-jquery-tmpl" id="convert-to-comment-dialog">
<#noparse>
    ${description}
    <form>
        <select name="targetParent" class="prompt-examples">
            {{each(p, target) parentCandidates }}
            <option value="${target.id}">${target.summary}</option>
            {{/each}}
        </select>
    </form>
</#noparse>
</script>
<script type="text/x-jquery-tmpl" id="move-to-space-dialog">
<#noparse>
    ${description}
    <form>
        <select name="targetSpace" class="prompt-examples">
            {{each(p, target) spaces }}
            <option value="${target.id}">${target.name}</option>
            {{/each}}
        </select>
    </form>
</#noparse>
</script>

<script type="text/x-jquery-tmpl" id="share-dialog">
<#noparse>
    <p>${description}</p>
    <input type="text" class="input-block-level" value="${shareURL}"/>
</#noparse>
</script>

<script type="text/x-jquery-tmpl" id="advanced-visibility-dialog">
<#noparse>
    <form>
        <div>
            {{if (perm.ag || perm.og) }}
                <h4>${msg.selectGroups}</h4>
                {{if groupsCheck }}
                    {{each(i, group) groups }}
                        <p><input type="checkbox" name="recipients" value="${group.id}" /> ${group.name}</p>
                    {{/each}}
                {{else}}
                    <input type="text" class="comment-recipients-groups-autocomplete" />
                    <div class="comment-recipients-groups-container" ></div>
                {{/if}}
            {{/if}}
            {{if (perm.op || perm.mod || perm.as) }}
                <h4>${msg.selectOther}</h4>
                {{if perm.op }}
                    <input type="checkbox" name="specialRecipients" value="op" /> ${msg.selectOriginalPoster}<br />
                {{/if}}
                {{if perm.m }}
                    <input type="checkbox" name="specialRecipients" value="mod" /> ${msg.selectModerators}<br />
                {{/if}}
                {{if perm.as }}
                    <input type="checkbox" name="specialRecipients" value="asg" /> ${msg.selectAssignees}<br />
                {{/if}}
            {{/if}}
        </div>
    </form>
</#noparse>
</script>