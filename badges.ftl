<content tag="sidebarWidgetsPath">
</content>
<content tag="sidebarTwoTop">
<#include "includes/sidebar/badge_levels.ftl">
</content>
<content tag="tab">badges</content>

<html>
<head>
    <title><@trans key="thub.badges.title"/></title>
</head>
<body>

<div class="widget" id="badges">
    <div class="widget-header">
        <i class="icon-certificate"></i>

        <h3><@trans key="thub.badges.title" /></h3>
    </div>

    <div class="widget-content badge-list">
    <p class="badges-description"><@trans key="thub.badges.description" /></p>
    <hr>
    <#assign badges = teamHubManager.awardManager.getSiteAndUserAwards(currentUser, currentSite) />

        <ul class="unstyled">
        <#list awardTypes as award>
            <#assign awardPlug>${award.plug}</#assign>
            <#assign awardIcon = award.icon />
            <li>
                <a href="<@url name="award:list" awardType=award desc=awardPlug />" class="medal">
                    <img src="<@url path=awardIcon />" alt=""/>
                </a>

                <strong>
                <#--<span class="${award.level}">&#9679;</span>&nbsp;-->
                    <a href="<@url name="award:list" awardType=award desc=awardPlug />">
                        <@trans key=award.name />
                    </a>
                </strong>(<span class="count">${award.awardedCount}</span>)<br/>
                <#if award.description??>
                    <@trans key=award.description />
                </#if>
            </li>
        </#list>
        </ul>
    </div>
</div>
</body>
</html>
