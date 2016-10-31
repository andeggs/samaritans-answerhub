<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<html>
<head>
    <title><#if title??>${title}<#else><@trans key="question.list.title"/></#if></title>
</head>
<body>
<content tag="tab">questions</content>
<content tag="postHeaderWidgetsPath">ahub.subnav</content>


<div class="sticky-posts-list"><@listNodes type="com.teamhub.models.node.Question" pageSize=5 container=space withState="sticky" sort="newest"; question>
    <p><a href="<@url obj=question />">${question.title?html}</a></p>
</@listNodes></div>

<#if topics?? || topic??>
<content tag="sidebar">
    <div class="sidebox">
        <div class="question-stats">
            <h3><@trans key="thub.questions.list.sidebar.topicStats" /></h3>
            <#if topic??>
                <#include "topic_full.ftl">
                <br/>
            <#else>
            <#-- Combo list -->
                <#list topics as topic>
                    <div class="topic-info">
                        <#include "topic_full.ftl">
                    </div>
                </#list>
            </#if>
        </div>
    </div>
</content>
</#if>

<#assign firstSet=true />

<#assign dateSep="" />

<#assign showList = questionPager.list?size != 0 />

<div class="widget">
    <div class="widget-header">
        <div class="pull-left dropdown">
            <a class="pull-left dropdown-toggle" data-toggle="dropdown" href="#"><h3><#if title??>${title}<#else><@trans key="question.list.title"/></#if> <i class="icon-caret-down"></i></h3></a>
            <ul class="dropdown-menu">
            <#if tab?? ><li><a href="<@url name="questions:list" />"><@trans key="question.list.title"/></a></li></#if>
            <#if !tab?? || (tab?? && tab != "unanswered")><li><a href="<@url name="questions:unanswered" />"><@trans key="question.unanswered.title" /></a></li></#if>
            <#if !tab?? || (tab?? && tab != "recommended")><li><a href="<@url name="questions:recommended" />"><@trans key="question.recommended.title" /></a></li></#if>
            </ul>
        </div>
        <#if showList>
            <#assign feedUrl><@url name="feed:questions"/></#assign>
            <@teamhub.sortBar pager=questionPager feedUrl=feedUrl />
        <#elseif !tab?? || tab != "unanswered">
            <#include "/includes/pager/list_sort_bar_empty.ftl" />
        </#if>
    </div>

<#if topic ??>
    <div class="btn-group pull-right" id="id_topic_follow">
        <a class="btn  btn-nostyle" title="Follow by RSS" href="<@url name="feed:topic" topic=topic />">
            <i class="icon-rss"></i>

        </a>
        <#if currentUser??>
            <#if teamHubManager.socialManager.isUserFollowing(topic, currentUser)??>
                <a title="UnFollow by mail" href="<@url name="unfollow" objId=topic.name type="topic" />"
                   class="btn btn-danger  btn-white-text btn-nostyle">
                    <i class=" icon-envelope"></i> </a>
            <#else>
                <a title="Follow by mail" href="<@url name="follow" objId=topic.name type="topic" />"
                   class="btn   btn-nostyle"><i class="icon-envelope"></i>
                </a>
            </#if>
        <#else>
            <@trans key="thub.widgets.follow.onceYouSignIn" />
        </#if>


    </div>

</#if>

<#assign showList = questionPager.list?size != 0 />

    <div class="widget-content" id="id_topic_content">
    <#if showList>
        <#list questionPager.list as question><#include "../actions/question_item.ftl"></#list>
    <#elseif tab?? && tab == "unanswered">
        <p><@trans key="thub.guide.unanswered.noResultsFound"/></p>
    <#else>
        <#include "/nodes/list_empty.ftl" />
    </#if>
    <@teamhub.paginate questionPager />
    </div>
</div>


<content tag="sidebarTwoWidgets">ahub.indexSidebar</content>
<content tag="sidebarOneWidgets">ahub.indexSidebar</content>

</body>
</html>