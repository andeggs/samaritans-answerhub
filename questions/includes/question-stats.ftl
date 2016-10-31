<#--<#import "/spring.ftl" as spring />-->
<#--<#import "/macros/thub.ftl" as teamhub />-->

<#--<div class="widget widget-nopad question-stats-widget">-->
    <#--<div class="widget-content">-->
        <#--<ul class="question-stat-block">-->
            <#--<li>-->
                <#--<span class="stat-title"><@trans key="label.views" /></span>-->
                <#--<strong><@teamhub.number_as_thousands question.viewCount /></strong>-->
            <#--</li>-->
            <#--<li>-->
                <#--<span class="stat-title"><@trans key="label.activity" /></span>-->

                <#--<span class="last-active-user muted stat-title">-->
                <#--<#if question.lastActivityAction??><a class="stat-title"-->
                                                      <#--href="#${question.lastActivityAction.node.type}-${question.lastActivityAction.node.id}"><span-->
                        <#--class="capitalize"-->
                        <#--title="<@trans key="thub.question.stats.mostRecent.mouseover" />"><@trans key="label." + question.lastActivityAction.node.type /></span></a>-->
                <#--<#else><a class="stat-title" href="#${question.type}-${question.id}"><span class="capitalize"-->
                                                                                           <#--title="<@trans key="thub.question.stats.mostRecent.mouseover" />"><@trans key="label." + question.type /></span></#if>-->
                    <#--by-->
                    <#--<span><@teamhub.avatar question.lastActiveUser 24 true /></span>-->
                <#--<#if question.lastActivityAction??><a class="stat-title"-->
                                                      <#--href="#${question.lastActivityAction.node.type}-${question.lastActivityAction.node.id}">-->
                <#--<#else>-->
                <#--<a class="stat-title" href="#${question.type}-${question.id}">-->
                <#--</#if>-->
                    <#--<span class="capitalize"-->
                          <#--title="${question.lastActiveDate}"><@dateSince date=question.lastActiveDate format="MMM d, ''yy"/></span>-->
                <#--</a>-->
                <#--</span>-->
            <#--</li>-->
            <#--<li>-->
                <#--<span class="stat-title"><@trans key="label.followers" params=[question.followers?size,"question"] /></span>-->

                <#--<div class="followers stat-title">-->
                <#--<#list question.followers as follower>-->
                    <#--<#if follower_index &lt; 10>-->
                    <#--<@teamhub.avatar follower 24 true/>-->
                <#--<#else>-->
                    <#--<@trans key="thub.question.followers.soManyMore" params=[question.followers?size - 10] />-->
                    <#--<#break>-->
                <#--</#if>-->
                <#--</#list>-->
                <#--</div>-->
            <#--</li>-->
        <#--</ul>-->
    <#--</div>-->
<#--</div>-->