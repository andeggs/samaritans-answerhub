<#import "/macros/thub.ftl" as teamhub />

<html>
<head>
    <title><@trans key=awardType.name/> - <@trans key="thub.badge.Badge.winners" default="Badge Winners" /></title>
</head>
<body>
<content tag="tab">badges</content>
<content tag="fullWidth"></content>
<div class="widget">
    <div class="widget-header">
        <h3><@trans key="thub.badge.Badge.winners" default="Badge Winners" />: <@trans key=awardType.name/>
            , <@trans key=awardType.description />. <#assign awardCount><span
                class="count">${awardPager.listCount}</span></#assign>
        <@trans key="thub.badge.awarded" default="users have been awarded this badge a total of {0} times" params=[awardPager.listCount] />
        </h3>
    </div>
    <div class="widget-content">
        <ul class="userlist unstyled">
        <#if awardPager.list?size != 0>
            <p>
            </p>

            <#list awardPager.list as award>

                <#assign user = teamHubManager.userManager.getUser(award.userid) />

                <#assign stats = userUtils.stats(user) /><#--
             -->
                <li class="user">
                    <div class="thumb">
                        <a href="<@url obj=user/>">
                            <@teamhub.avatar user=user size=48 />
                        </a>
                    </div>
                    <span>
                        <a <#if !user.active>class="suspended-user"</#if>
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

                </li><#--
                  -->

            </#list>
            <div style="clear:both;">
                <@teamhub.paginate pager=awardPager showPageSizer=false />
            </div>
        <#else>
            <@trans key="thub.badge.no.users" default="No users have been awarded this badge." />
        </#if>
    </div>

</div>

</body>
</html>

