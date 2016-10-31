<#import "/macros/security.ftl" as security />
<#if !currentUser?? || currentUser.id != profileUser.id>
    <h3><@trans key="thub.users.profile.tabs.social.personalized" params=[profileUser.username?html]/></h3>
<#else>
    <h3><@trans key="thub.users.profile.tabs.social.curUser" /></h3>
</#if>
<br/>
<#if networkPager?? >
    <#if networkPager.listCount != 0>
    <p>
        <#if !currentUser?? || currentUser.id != profileUser.id>
            <@trans key="thub.users.profile.tabs.social.following" params=[profileUser.username?html,profileUser.follows?size,profileUser.followers?size] />
        <#else>
            <@trans key="thub.users.profile.tabs.social.following.curUser" params=[profileUser.follows?size,profileUser.followers?size] />
        </#if>
    </p>
    <table border="0" cellpadding="10">
    <#assign count = 0 />
    <#list networkPager.list as following>
    <#--<#if following.type == 'UserFollowRelation'>-->
        <#if count == 0 || count % 6 == 0>
            <tr valign="top">
        </#if>
        <#assign count = count + 1 />
        <td style="text-align:center">
            <#if following.type == 'UserFollowRelation'>
                <@teamhub.avatar following.userToFollow 48 true "clickable"/>
                <@security.access allowIf='ROLE_FOLLOW'>
                    <br />
                    <#--<div class="follow-button">-->
                        <#if teamHubManager.socialManager.isUserFollowing(following.userToFollow, currentUser)??>
                            <a href="<@url name="unfollow" objId=following.userToFollow type="user" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-red btn-small"><@trans key="label.follow.stop"/></button></a>
                        <#else>
                            <a href="<@url name="follow" objId=following.userToFollow type="user" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-blue btn-small"><@trans key="label.follow.start"/></button></a>
                        </#if>
                    <#--</div>-->
                </@security.access>
            <#elseif following.type == 'NodeFollowRelation'>
                <a href="<@url obj=following.nodeToFollow/>" title="${following.nodeToFollow.title}"><img src="<@url path="/images/social/question-icon.png"/>" class="icon-border" width="48" height="48" alt="" class="clickable"/></a>
                <@security.access allowIf='ROLE_FOLLOW'>
                    <br/>
                    <#--<div class="follow-button">-->
                        <#if teamHubManager.socialManager.isUserFollowing(following.nodeToFollow, currentUser)??>
                            <a href="<@url name="unfollow" objId=following.nodeToFollow type="question" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-red btn-small"><@trans key="label.follow.stop"/></button></a>
                        <#else>
                            <a href="<@url name="follow" objId=following.nodeToFollow type="question" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-blue btn-small"><@trans key="label.follow.start"/></button></a>
                        </#if>
                    <#--</div>-->
                </@security.access>
            <#elseif following.type == 'SpaceFollowRelation'>
                <a href="<@url obj=following.spaceToFollow/>" title="${following.spaceToFollow.name}"><img src="<@url path="/images/social/spaces-icon.png"/>" class="icon-border" width="48" height="48" alt="" class="clickable"/></a>
                <@security.access allowIf='ROLE_FOLLOW'>
                    <br/>
                    <#--<div class="follow-button">-->
                        <#if teamHubManager.socialManager.isUserFollowing(following.spaceToFollow, currentUser)??>
                            <a href="<@url name="unfollow" objId=following.spaceToFollow type="space" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-red btn-small"><@trans key="label.follow.stop"/></button></a>
                        <#else>
                            <a href="<@url name="follow" objId=following.spaceToFollow type="space" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-blue btn-small"><@trans key="label.follow.start"/></button></a>
                        </#if>
                    <#--</div>-->
                </@security.access>
            <#elseif following.type == 'TopicFollowRelation'>
                <a href="<@url obj=following.topicToFollow/>" title="${following.topicToFollow.name}"><img src="<@url path="/images/social/topics-icon.png"/>" class="icon-border" width="48" height="48" alt="" class="clickable"/></a>
                <br/>
                <@security.access allowIf='ROLE_FOLLOW'>
                    <#if teamHubManager.socialManager.isUserFollowing(following.topicToFollow, currentUser)??>
                        <a href="<@url name="unfollow" objId=following.topicToFollow.name type="topic" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-red btn-left"><@trans key="label.follow.stop"/></button></a>
                    <#else>
                        <a href="<@url name="follow" objId=following.topicToFollow.name type="topic" />?returnUrl=<@url obj=profileUser/>#/userNetworkTab"><button class="btn btn-blue btn-left"><@trans key="label.follow.start.topic"/></button></a>
                    </#if>
                </@security.access>
            </#if>
        <#--</#if>-->
        </td>
        <#if count % 5 == 0 || !following_has_next>
            </tr>
        </#if>
    </#list>
    </table>
    <#else>
    <p><@trans key="thub.users.profile.tabs.social.following.noFollows" params=[profileUser.username?html] /></p>
    </#if>
</#if>
