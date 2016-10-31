<#import "/macros/thub.ftl" as teamhub />


<div class="btn-group btn-group-vertical" id="settings_sidebar">

    <a href="<@url obj=profileUser/>"><@teamhub.avatar user=profileUser size=128 /></a>


    <a class="btn" href="<@url obj=profileUser/>"><@trans key="thub.profile.sidebar.backToProfile" /></a><br/>
<#if currentUser?? && profileUser == currentUser>
    <a class="btn"
       href="<@url name="users:profile:edit" user=profileUser/>"><@trans key="thub.profile.sidebar.editProfile" /></a>
    <a class="btn"
       href="<@url name="users:preferences" user=profileUser plug=profileUser.username/>"><@trans key="thub.profile.sidebar.editPreferences" /></a>

</#if>
<#if currentUser?? && profileUser.id != currentUser.id>
    <div class="follow-butto n">
        <#if teamHubManager.socialManager.isUserFollowing(profileUser, currentUser)??>
            <a class="btn active"
               href="<@url name="unfollow" objId=profileUser type="user" />"><@trans key="label.follow.stop"/></a>
        <#else>
            <a class="btn"
               href="<@url name="follow" objId=profileUser type="user" />"><@trans key="label.follow.start"/></a>
        </#if>
    </div>
<#elseif !currentUser??>
    <a class="btn" href="<@url name="follow" objId=profileUser type="user" />">
        <button class="btn btn-blue btn-small"><@trans key="label.follow.start"/></button>
    </a>
</#if>

</div>
