<#assign showWelcome = isSameUser && userUtils.checkAndSetFirstProfileView(currentUser) />
<style>
.ui-front {
    z-index: 1001;
}
</style>

<div id="${profileUser.id?string.computer}-info-block" class="widget info-block" nodeid="${profileUser.id?string.computer}">
    <div class="widget-content" <#if showWelcome>style="position: relative;" </#if>>
        <h1 class="pull-left">
        <@teamhub.avatar profileUser 36 false/>

        <span <#if !profileUser.active>style="text-decoration: line-through;"</#if>>${userUtils.displayName(profileUser)}</span><#if !profileUser.active> <span class="badge badge-important"><i class="icon-lock"></i> <@trans key="user.suspended"/></span></#if></h1>

    <#if currentUser??>
        <div class="btn-group" style="float: right;">
        	<#if currentUser.id != profileUser.id>
                    <#if teamHubManager.socialManager.isUserFollowing(profileUser, currentUser)??>
                        <a class="btn btn-danger btn-nostyle btn-white-text" href="<@url name="unfollow" objId=profileUser type="user" />" class="btn btn-danger">
                            <i class=" icon-remove-circle"></i>
                            <@trans key="thub.widgets.follow.user.unfollow" /></a>
                    <#else>
                        <a class="btn"  href="<@url name="follow" objId=profileUser type="user" />" class="btn btn-success"><i class="icon-ok-sign"></i>
                            <@trans key="thub.widgets.follow.user.follow" /></a>
                    </#if>

            </#if>
	        <@security.access permission="edit" object=profileUser>
	        	<a href="<@url name="users:preferences" user=profileUser plug=profileUser.plug />" class="btn"><i class="icon-wrench"></i> <@trans key="thub.users.profile.blocks.about.editButton" default="Edit"/></a>
	        	<button class="btn dropdown-toggle" data-toggle="dropdown">
                    <span class="caret"></span>
                </button>
				<ul class="dropdown-menu pull-right" role="menu">
                    <@security.access permission="manageAuthSettings" object=profileUser>
                        <li class="item"><span class="user-auth"></span><a href="<@url name="users:preferences" user=profileUser plug=profileUser.plug />#/authmodesPanel" ><@trans key="thub.userPreferences.authenticationModes.menu" default="Authentication settings" /></a></li>
                    </@security.access>
                    <li class="item"><span class="user-subscriptions"></span><a href="<@url name="users:preferences" user=profileUser plug=profileUser.plug />#/notificationsPanel" ><@trans key="thub.userPreferences.notifications.menu" default="Email notification settings" /></a></li>
                    <li class="item"><span class="user-social-networking"></span><a href="<@url name="users:preferences" user=profileUser plug=profileUser.plug />#/expertisePanel" ><@trans key="thub.userPreferences.expertiseSettings.menu" default="Expertise settings" /></a></li>
                     <#assign moderatorHeaderShown = false/>
                    <@security.access permission="suspendUser" object=profileUser>
                    <#if !moderatorHeaderShown>
                        <li class="divider"></li>
                        <#assign moderatorHeaderShown = true />
                    </#if>
                        <li class="item">
                            <a href="#" id="suspendCommand" class="ajax-command<#if !profileUser.active> on</#if>" command="suspendUser"><@trans key="user.suspendUser.title" default="Suspend user" /></a>
                        </li>
                        <li class="item">
                            <a href="#" id="deleteAllPostsCommand" class="ajax-command<#if !profileUser.active> on</#if>" command="deleteAllPosts"><@trans key="user.deleteAllPosts.title" default="Delete all posts" /></a>
                        </li>
                    </@security.access>
                    <@security.access permission="awardRep" object=profileUser>
                    <#if !moderatorHeaderShown>
                        <li class="divider"></li>
                        <#assign moderatorHeaderShown = true />
                    </#if>
                        <li class="item"><span class="user-award_rep"></span><a href="#" command="awardRepBonus" id="award-rep-points" class="ajax-command withprompt"><@trans key="user.award.points" default="Give/Take karma" /></a></li>
                    </@security.access>
                    <@security.access permission="makeModerator" object=profileUser>
                    <#if !moderatorHeaderShown>
                        <li class="divider"></li>
                        <#assign moderatorHeaderShown = true />
                    </#if>
                        <li class="item"><span class="user-moderator"></span><a href="#" class="ajax-command confirm<#if profileUser.moderator> on</#if>" command="makeModerator"><@trans key="user.makeModerator.title" default="Make moderator" /></a></li>
                    </@security.access>
                    <@security.access permission="makeSuperUser" object=profileUser>
                    <#if !moderatorHeaderShown>
                        <li class="divider"></li>
                        <#assign moderatorHeaderShown = true />
                    </#if>
                        <li class="item"><span class="user-superuser"></span><a href="#" class="ajax-command confirm<#if profileUser.superUser> on</#if>" command="makeSuperUser"><@trans key="user.makeSuperUser.title" default="Make super user" /></a></li>
                    </@security.access>
                    <@security.access permission="registerApp" object=profileUser>
                        <li class="item"><span class="user-developapps"></span><a href="<@url name="develop:apps:list" account=profileUser/>"><@trans key="user.connect_app.label" default="connect app to TeamHub" /></a></li>
                    </@security.access>
				</ul>
	        </@security.access>
        
        </div>
    </#if>


        <div class="row-fluid">
            <div class="span2 avatar text-center">
                <#if profileUser.active>
                    <@teamhub.avatar profileUser 240 false "" "" "" "profile-user-avatar"/>
                    <@security.access permission="edit" object=profileUser>
                        <a id="editUserPhoto" command="editUserPhoto" href="#"><i class="icon-edit"></i> <@trans key="thub.profile.blocks.info.uploadProfilePicture" /></a>
                    </@security.access>
                <#else>
                    <img src="<@url path="/images/anonymous.png" />" width="240" height="240" />
                </#if>
            </div>
            <div class="span7 info">
            <#if !profileUser.active><span><i class="icon-lock"></i> <@trans key="thub.profile.blocks.info.suspended" /> <@dateSince date=profileUser.suspension.actionDate /></span><br></#if>
            <#if profileUser.realname?? && profileUser.realname != "" && userUtils.displayName(profileUser) == profileUser.username><span>${profileUser.realname}</span><br/></#if>
                <#if profileUser.location?? && profileUser.location != ""><span><i class="icon-globe"></i> ${profileUser.location}</span><br/></#if>
                <#if profileUser.company?? && profileUser.company != ""><span><i class="icon-briefcase"></i> ${profileUser.company}</span><br/></#if>
                <span><i class="icon-calendar"></i> <@trans key="thub.profile.blocks.info.joined" /> <@dateSince date=profileUser.creationDate /></span><br>
                <span><i class="icon-eye-open"></i> <@trans key="thub.profile.blocks.info.lastSeen" /> <@dateSince date=lastSeen /></span><br>
                <@security.access permission="edit" object=profileUser>
                    <#if profileUser.primaryEmail?? && profileUser.primaryEmail.email??><span><i class="icon-envelope"></i> <a href="mailto:${profileUser.primaryEmail.email}">${profileUser.primaryEmail.email}</a></span>
                        <#if profileUser.primaryEmail?? && !profileUser.primaryEmail.validated ><a class="ajax-command" href="#" command="resendEmailValidation"><span class="badge badge-inverse"> <i class="icon-remove"></i> <@trans key="thub.profile.blocks.info.emailNotValidated" default="Not validated" /></span></a>
                        <#elseif profileUser.primaryEmail?? && profileUser.primaryEmail.validated><span class="badge badge-success"><i class="icon-ok"></i> <@trans key="thub.profile.blocks.info.emailValidated" default="Validated" /></span>
                        </#if>
                    </#if>
                </@security.access>
            </div>
            <div class="span3 stats">
                <div class="counts pull-right">
                    <div class="karma">
                        <div class="count">${profileUser.reputation}</div>
                        <div class="count-label"><@trans key="thub.label.reputation"/></div>
                    </div>
                    <div class="followers">
                        <div class="count">${profileUser.followers?size}</div>
                        <div class="count-label"><@trans key="label.followers" /></div>
                    </div>
                    <div class="following">
                        <div class="count">${profileUser.userFollows?size}</div>
                        <div class="count-label"><@trans key="thub.label.following" /></div>
                    </div>
                    <div class="acceptRate">
                        <div class="count">${profileUser.acceptRate}%</div>
                        <div class="count-label"><@trans key="thub.label.acceptRate" /></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="activity-stats pull-left">
            <div class="questions pull-left">
                <i class="icon-question-sign"></i>
                <span>
                <a href="#${profileUser.id?string.computer}-activity-block" onclick="loadPage('questions');">${userUtils.postCount(profileUser, "question")} <@trans key="label.questions" />
                </a></span>
            </div>
            <div class="answers pull-left">
                <i class="icon-ok-sign"></i>
                <span><a href="#${profileUser.id?string.computer}-activity-block" onclick="loadPage('answers');">${userUtils.postCount(profileUser, "answer")} <@trans key="label.answers" /></a></span>
            </div>
            <div class="comments pull-left">
                <i class="icon-comments"></i>
                <span><a href="#${profileUser.id?string.computer}-activity-block" onclick="loadPage('comments');">${userUtils.postCount(profileUser, "comment")} <@trans key="label.comments" /></a></span>
            </div>
            <div class="favorite pull-left">
                <i class="icon-star"></i>
                <span><a href="#${profileUser.id?string.computer}-activity-block" onclick="loadPage('favorite');">${favoriteCount} <@trans key="label.favorites" /></a></span>
            </div>
            <#if subscriptionsPage??>
                <div class="questions pull-left">
                    <i class="icon-thumbs-up"></i>
                <span>
                <a href="<@url name="users:subscriptions" user=profileUser/>"><@trans key="thub.users.subscriptions.title" /></a></span>
                </div>
            </#if>
        </div>

    </div>

    <#if showWelcome>
        <#include "info_empty.ftl" />
    </#if>
</div>