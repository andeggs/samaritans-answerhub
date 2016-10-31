<#import "/macros/thub.ftl" as teamhub />

<#if !userPager?? && searchPager?? >
    <#assign userPager = searchPager />
    <#assign isSearch = true />
</#if>
<head>
    <title><@trans key="thub.users.index.title" /></title>

</head>
<content tag="fullWidth"></content>
<content tag="tail"><@teamhub.paginate userPager false /></content>
<content tag="tab">users</content>

<div class="widget">


<#if searchDesc??>
    <p>
    ${searchDesc?html}
    </p>
</#if>
    <div class="widget-header">
        <i class="icon-user"></i>

        <h3><@trans key="thub.users.index.title" /></h3>

            <span class="btn-group sort-bar">
                <#if isSearch?? >
                    <#assign searchParamCount = 1 />
                    <a href="#" class="on"
                       title="<@trans key="thub.user.sort.relevance.title" />"><@trans key="thub.user.sort.relevance" /></a>
                </#if>

                <#list userSorts as sort>
                    <#if sort != "default" >
                        <a href="<@url name="users:list" />?sort=${sort}"
                           class="btn <#if userPager.sort == sort>active</#if>"
                           title="<@trans key="thub.user.sort." + sort+ ".title"/>"><@trans key="thub.user.sort."+ sort/></a>
                    </#if>

                </#list>
            </span>
    </div>
    <div class="widget-content">
        <ul class="userlist unstyled">
        <#list userPager.list as user><#-- comments are here because inline-blocks are sensitive to line breaks
             --><#assign stats = userUtils.stats(user) /><#--
             -->
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

            </li><#--
         --></#list>
        </ul>
    <@teamhub.paginate userPager />
    </div>
</div>
