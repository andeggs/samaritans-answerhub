<#assign awards = teamHubManager.awardManager.getSiteAndUserAwards(profileUser, currentSite) />
<div class="widget">
    <div class="widget-header">
        <h3><@trans key="thub.users.profile.tabs.badges.count" params=["<span class=\"count\">" + awards?size + "</span>"] /></h3>
    </div>
    <div class="widget-content">
        <#if isSameUser && awards?size == 0>
            <#include "badges_empty.ftl" />
        <#else>
        <ul class="answer-badges user-badges">
        <#list awards as award>
            <li>
                <#assign awardPlug><@trans key=award[1]/></#assign>
                <#assign awardPlug = awardPlug?lower_case?replace(" ", "-") />
                <#assign awardIcon = "/images/badges/"+award[1]?lower_case?replace(" ", "-")+".png" />
                <#assign awardIconSrc>
                	<@url path=awardIcon/>
                </#assign>
                <a rel="award" nodeId="${award[0]}" awardType="${award[0]}" desc="${awardPlug}" awardIconSrc="${awardIconSrc}" title="<#if award[2]??><@trans key=award[2]/><#else><@trans key="thub.users.profile.tabs.badges.noDesc" /></#if>" href="<@url name="award:list" awardType=award[0] desc=awardPlug/>">
                    <img src="${awardIconSrc}"/>
                </a>
                <span class="count">x${award[3]}</span>
            </li>
        </#list>
        </ul>
        </#if>
    </div>
</div>
