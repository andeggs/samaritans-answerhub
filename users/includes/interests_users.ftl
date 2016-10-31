<#import "/macros/teamhub.ftl" as teamhub />
<#macro usersPanel>
<div class="tab-pane active" id="users">
<#if RequestParameters["setPassword"]??>
    <div class="setPasswordPrompt"><@trans key="thub.users.edit.setPasswordPrompt" /></div><br>
</#if>
        <div class="widget-body-container" style="padding-top: 2px;">
            <ul class="userlist unstyled interestsUsers">
            <#if usersPager.list?size != 0>
                <#list usersPager.list as topic>
                <#assign stats = userUtils.stats(topic.userToFollow) />
                <#assign user=topic>
                    <li class="user">

                        <div class="thumb">
                            <@teamhub.avatar user=user size=48 link=true />
                        </div>
                    <span>
                        <a <#if !user.active>class="suspended-user"</#if> rel="user" nodeId="${user.id}"
                           href="<@url name="users:profile" user=user plug=user.username/>">
                            <#if userUtils.displayName(user)?length <= 19>
                            ${userUtils.displayName(user)}
                            <#else>
                            ${userUtils.displayName(user)?substring(0,15)}...
                            </#if>

                            <#if user.superUser>&#9830;&#9830;<#elseif user.moderator>&#9830;</#if>
                        </a>
                    </span>
                        <br>
                    <span>
                        <#if user.active>
                            <span class="score"
                                  title="${stats.reputation} karma"><@teamhub.number_as_thousands stats.reputation "" /></span>
                            <#if stats.gold != 0><span title="${stats.gold} badges">
                            <span class="badge1">&#9679;</span>
                            <span class="badgecount">${stats.gold}</span>
                        </span></#if>
                            <#if stats.silver != 0><span title="${stats.silver} badges">
                            <span class="silver">&#9679;</span>
                            <span class="badgecount">${stats.silver}</span>
                        </span></#if>
                            <#if stats.bronze != 0><span title="${stats.bronze} badges">
                            <span class="bronze">&#9679;</span>
                            <span class="badgecount">${stats.bronze}</span>
                        </span></#if>
                        <#else>
                            (<@trans key="user.suspended"/>)
                        </#if>
                    </span>
                        <span style="float:right">
                            <#if currentUser??><a
                                    class="btn btn-follow <#if teamHubManager.socialManager.isUserFollowing(topic, profileUser)??>on btn-info</#if>"
                                    command="follow" data-node-type="user" nodeId="${topic.id}"></a></#if>
                        </span>
                </li>
                </#list>
            <#else>
                <@trans key="thub.users.followed.empty" />
            </#if>
            </ul>
            <@teamhub.paginate usersPager />
        </div>
</div>
</#macro>

<div class="tab-pane" id="users">
<@usersPanel/>
</div>