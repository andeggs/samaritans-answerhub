<#import "/macros/thub.ftl" as teamhub />

<div>
<#assign action_index = (action_index % 2 == 0)?string("","odd")/>
<#if action.node??>
    <#if action??>
        <#assign verb = action.verb />
        <#assign author = action.user />
        <#assign actionDate = action.actionDate />
    </#if>
    <#if action.node.type == 'question'>
        <#assign question = action.nodeObject />
        <#assign author = question.author />
        <#assign verb = "asked" />
        <#assign actionDate = question.lastActiveDate />
        <#if action??>
            <#if action.verb != 'asked'>
                <#assign verb = action.verb />
            </#if>
            <#assign author = action.user />
            <#assign actionDate = action.actionDate />
        </#if>
        <#assign actionBody>
        <#assign authorUrl><@url obj=author /></#assign>
        <#assign questionUrl><@url name="questions:view" question=question.id plug=question.plug  /></#assign>
        <#assign questionTitle><#if question.title?length <= 70>${question.title?html}<#else>${(question.title?substring(0,65))?html}...</#if></#assign>
        <#assign questionTags><#list question.organizedTopics as tag><a class="tag" href="<@url name="topics:view" topics=tag.name/>">${tag.name}</a><#if tag_has_next> &middot; </#if></#list></#assign>


        <#assign transParams = [
        verb?replace(' ', '_'),
        authorUrl,
        userUtils.displayName(author),
        questionUrl,
        questionTitle,
        questionTags,
        question.primaryContainer.name
        ] />


        <@trans key="thub.profile.activity.action.question" params=transParams />

        </#assign>
    </#if>

    <#if action.node.type == 'topic'>
        <#assign actionBody>
            <#assign authorUrl><@url obj=author /></#assign>
            <#assign topicUrl><@url name="topics:view" topics=action.node.title  /></#assign>
            <#assign topicTitle>${action.node.title?html}</#assign>

            <#assign transParams = [
            verb?replace(' ', '_'),
            authorUrl,
            userUtils.displayName(author),
            topicUrl,
            topicTitle
            ] />

            <@trans key="thub.profile.activity.action.topic" params=transParams />

        </#assign>
    </#if>

    <#if action.type == 'giveRep'>
        <#assign author = action.user />
        <#assign userGotPoints = action.node.author.name/>
        <#if action.reputationChanges[0]??>
            <#assign points = action.reputationChanges[0].value />
        <#else>
            <#assign points = 0 />
        </#if>
        <#if points<0>
            <#assign points=-points>
        </#if>
        <#assign question = action.node.originalParent/>
        <#assign actionBody>
            <#assign questionUrl><@url name="questions:view" question=question.id plug=question.plug  /></#assign>
            <#assign questionTitle><#if question.title?length <= 70>${question.title?html}
            <#else>${(question.title?substring(0,65))?html}...</#if></#assign>
            <#assign authorUrl><@url obj=author/></#assign>
            <#assign userGotPointsUrl><@url obj=action.node.author/></#assign>

            <#assign transParams = [
            verb?replace(' ', '_'),
            authorUrl,
            userUtils.displayName(author),
            questionUrl,
            questionTitle,
            userGotPointsUrl,
            userGotPoints,
            points
            ] />

            <@trans key="thub.profile.activity.action.question"  params=transParams />

        </#assign>
    </#if>

    <#if action.node.type == 'comment' >
        <#assign comment = action.nodeObject />
        <#assign question = comment.originalParent />
        <#if action??>
            <#if action.verb != 'commented'>
                <#assign verb = action.verb />
            </#if>
            <#assign author = action.user />
            <#assign actionDate = action.actionDate />
        </#if>
        <#assign actionBody>

            <#assign authorUrl><@url obj=author /></#assign>
            <#assign commentUrl><@url name="comments:view" comment=comment.id /></#assign>
            <#assign questionTitle><#if question.title?length <= 70>${question.title?html}<#else>${(question.title?substring(0,65))?html}...</#if></#assign>
            <#assign questionTags><#list question.topics as tag><a href="<@url name="topics:view" topics=tag.name/>">${tag.name}</a><#if tag_has_next>, </#if></#list></#assign>

            <#assign transParams = [
            verb?replace(' ', '_'),
            authorUrl,
            userUtils.displayName(author),
            commentUrl,
            questionTitle
            ] />

            <@trans key="thub.profile.activity.action.comment"  params=transParams />

      </#assign>
    </#if>
    <#if action.node.type == 'answer'>
        <#assign answer = action.nodeObject />
        <#assign question = answer.parent />
        <#assign author = answer.author />
        <#assign verb = "added" />
        <#assign actionDate = answer.lastActiveDate />
        <#if action??>
            <#if action.verb != 'answered'>
                <#assign verb = action.verb />
                <#if action.canceled>
                    <#assign verb = "canceled " + action.verb />
                </#if>
            </#if>
            <#assign author = action.user />
            <#assign actionDate = action.actionDate />
            <#assign userGotPoints = action.node.author.name/>
            <#if action.verb == 'giveReputation'>
                <#assign points = action.reputationChanges[0].value />
            <#else>
                <#assign points = 0 />
            </#if>
        </#if>

        <#assign actionBody>

            <#assign authorUrl><@url obj=author /></#assign>
            <#assign userGotPointsUrl><@url obj=action.node.author/></#assign>
            <#assign answerUrl><@url name="answers:view" answer=answer.id /></#assign>
            <#assign questionTitle><#if question.title?length <= 70>${question.title?html}<#else>${(question.title?substring(0,65))?html}...</#if></#assign>
            <#if points<0>
                <#assign points=-points/>
            </#if>

            <#assign transParams = [
                verb?replace(' ', '_'),
                authorUrl,
                userUtils.displayName(author),
                answerUrl,
                questionTitle,
                userGotPointsUrl,
                userGotPoints,
                points
                ] />
                <@trans key="thub.profile.activity.action.answer"  params=transParams />

        </#assign>
    </#if>
    <#if action.node.type == 'idea'>
        <#assign idea = action.nodeObject />
        <#assign author = idea.author />
        <#assign verb = "suggested" />
        <#assign actionDate = idea.lastActiveDate />
        <#if action??>
            <#if action.verb != 'suggested'>
                <#assign verb = action.verb />
            </#if>
            <#assign author = action.user />
            <#assign actionDate = action.actionDate />
        </#if>
        <#assign actionBody>
            <#assign authorUrl><@url obj=author /></#assign>
            <#assign ideaUrl><@url name="content:view" type="idea" node=idea.id plug=idea.plug /></#assign>
            <#assign ideaTitle><#if idea.title?length <= 70>${idea.title?html}<#else>${(idea.title?substring(0,65))?html}...</#if></#assign>
            <#assign ideaTags>
                <#list idea.organizedTopics as tag>
                    <a class="tag" href="<@url name="content:topics_list" type="idea" topics=tag.name/>">${tag.name}</a>
                    <#if tag_has_next> &middot;</#if>
                </#list>
            </#assign>

            <#assign transParams = [
                verb?replace(' ', '_'),
                authorUrl,
                userUtils.displayName(author),
                ideaUrl,
                ideaTitle,
                ideaTags,
                idea.primaryContainer.name
                ] />

            <@trans key="thub.profile.activity.action.idea" params=transParams />

        </#assign>
    </#if>
    <#if action.node.type == 'ideacomment'>
        <#assign ideaComment = action.nodeObject />
        <#assign idea = ideaComment.originalParent />
        <#assign author = ideaComment.author />
        <#assign verb = "commented" />
        <#assign actionDate = ideaComment.lastActiveDate />
        <#if action??>
            <#if action.verb != 'commented'>
                <#assign verb = action.verb />
                <#if action.canceled>
                    <#assign verb = "canceled " + action.verb />
                </#if>
            </#if>
            <#assign author = action.user />
            <#assign actionDate = action.actionDate />
        </#if>
        <#assign actionBody>
            <#assign authorUrl><@url obj=author /></#assign>
            <#assign commentUrl><@url name="content:view" type="idea" node=idea.id plug=idea.plug /></#assign>
            <#assign ideaTitle><#if idea.title?length <= 70>${idea.title?html}<#else>${(idea.title?substring(0,65))?html}...</#if></#assign>
            <#assign ideaTags>
                <#list idea.topics as tag><a href="<@url name="content:topics_list" type="idea" topics=tag.name/>">${tag.name}</a><#if tag_has_next>, </#if></#list>
            </#assign>

            <#assign transParams = [
            verb?replace(' ', '_'),
            authorUrl,
            userUtils.displayName(author),
            commentUrl,
            ideaTitle
            ] />

            <@trans key="thub.profile.activity.action.commentIdea"  params=transParams />

        </#assign>
    </#if>
    <#if action.type == 'cnstate'>
        <#assign author = action.user />
        <#assign question = action.node.originalParent/>
        <#assign changeState = action.extra />
        <#assign actionBody>
            <#assign questionUrl><@url name="questions:view" question=question.id plug=question.plug  /></#assign>
            <#assign questionTitle><#if question.title?length <= 70>${question.title?html}<#else>${(question.title?substring(0,65))?html}...</#if></#assign>
            <#assign authorUrl><@url obj=author /></#assign>

            <#assign transParams = [
            "change_state",
            authorUrl,
            userUtils.displayName(author),
            questionUrl,
            questionTitle,
            changeState
            ] />

            <@trans key="thub.profile.activity.action.question"  params=transParams />

        </#assign>
    </#if>
    <div id="${action.nodeObject.type}-${action.nodeObject.id}" class="row-fluid">
        <div class="span10">
            ${actionBody!""} <#if action.triggeredAwards?size != 0 && action.user == profileUser>
                <@trans key="thub.actions.award.additionally" default="Additionally," />
                <#assign awardsList>
                    <#list action.triggeredAwards as award>
                        <#assign userLink><a href="<@url obj=award.user />">${userUtils.displayName(award.user)}</a></#assign>
                        <#assign awardPlug><@trans key=award.type.name/></#assign>
                        <#assign awardPlug = awardPlug?lower_case?replace(" ", "-") />
                        <a href="<@url name="award:list" awardType=award.type desc=awardPlug/>"><@trans key=award.type.name /></a><#if award_has_next>, </#if>
                    </#list>
                </#assign>

                <@trans key="thub.actions.action_item.was-awarded-the" default="{0} was awarded the {1} award"
                params=[userLink, awardsList, action.triggeredAwards?size] />
            </#if>
        </div>
        <div class="span2">
            <@dateSince date=actionDate />
        </div>
    </div>
<#elseif action.user?? && !action.node??>
<#-- user action things, awards, suspensions, etc -->
    <#assign user = action.user />
    <#assign userUrl><@url obj=user /></#assign>
    <#if action.reputationChanges?size != 0>
        <#if action.type == 'userjoins' || action.type == 'userjoinsite'>
            <div id="user-${user.id}" class="row-fluid">
                <div class="span10">
                    <div class="activity-item activity-user">
                        <#assign transParams = [
                            action.verb?replace(' ', '_'),
                            userUrl,
                            userUtils.displayName(user),
                            currentSite.name
                        ] />
                        <@trans key="thub.profile.activity.user.joins" params=transParams />
                    </div>
                </div>
                <div class="span2">
                    <@dateSince date=action.actionDate />
                </div>
            </div>
        <#elseif action.type == 'follow'>
            <#include "follow_item.ftl"/>
        <#else>
            <#assign affected = action.reputationChanges[0].user/>
            <#assign affectedUrl><@url obj=affected /></#assign>
            <#assign points = action.reputationChanges[0].value />
            <#assign userUrl><@url obj=user /></#assign>
            <div id="user-${user.id}" class="row-fluid">
                <div class="span10">
                    <#assign transParams = [
                        action.verb?replace(' ', '_'),
                        userUrl,
                        userUtils.displayName(user),
                        points,
                        affectedUrl,
                        userUtils.displayName(affected)
                    ] />
                    <@trans key="thub.profile.activity.user.reputation"  params=transParams />.

                    <#if action.triggeredAwards?size != 0 && action.user == profileUser>
                        <@trans key="thub.actions.award.additionally" default="Additionally," />
                        <#assign userLink><a href="<@url obj=action.user />">${userUtils.displayName(action.user)}</a></#assign>
                        <#assign awardsList>
                            <#list action.triggeredAwards as award>
                                <#assign awardPlug><@trans key=award.type.name/></#assign>
                                <#assign awardPlug = awardPlug?lower_case?replace(" ", "-") />
                                <a href="<@url name="award:list" awardType=award.type desc=awardPlug/>"><@trans key=award.type.name /></a><#if award_has_next>, </#if>
                            </#list>
                        </#assign>

                        <@trans key="thub.actions.action_item.was-awarded-the" default="{0} was awarded the {1} award"
                        params=[userLink, awardsList, action.triggeredAwards?size] />
                    </#if>
                </div>
                <div class="span2">
                    <@dateSince date=action.actionDate />
                </div>
            </div>
        </#if>
    </#if>
</#if>
</div>