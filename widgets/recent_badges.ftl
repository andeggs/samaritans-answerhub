<#import "/macros/thub.ftl" as teamhub />
<div class="widget" id="recent-badges-widget">
    <div class="widget-header">
        <i class="icon-certificate"></i>
        <h3><@trans key="thub.widgets.recentAwards.title" /></h3>
    </div>
    <div class="widget-content" style="position: relative;">
<#if awards?size == 0 >
    <#include "recent_badges_empty.ftl">
<#else >
    <ul class="answer-badges">
    <#list awards as award>
        <li>
            <#--<#assign content>
                <span class="badge-${award.type.level}">&#9679;</span> <#if award.type.name??><@trans key=award.type.name/><#else ><@trans key="thub.widgets.recentBadges.no.name" /></#if>
            </#assign>-->
            <#assign awardPlug>${award.type.plug}</#assign>
            <#assign awardIcon = award.type.icon />
            <#assign awardIconSrc>
                <@url path=awardIcon/>
            </#assign>
            <#assign content>
                <img src="<@url path=awardIcon />" alt="<#if award.type.name??><@trans key=award.type.name/><#else ><@trans key="thub.widgets.recentBadges.no.name" /></#if>"/>
            </#assign>
            <@teamhub.objectLink object=award content=content awardType="${award.type}" desc="${awardPlug}" awardIconSrc="${awardIconSrc}" class="award"/>
            &nbsp;
            <@teamhub.objectLink award.user userUtils.displayName(award.user)/>
        </li>
    </#list>
    </ul>
</#if>
    </div>
</div>
