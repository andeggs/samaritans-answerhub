<content tag="postHeaderWidgetsPath">ahub.subnav</content>

<content tag="preMainContentWidgets">ahub.preMainContent.index</content>

<#assign showList = questionPager.list?size != 0/>

<div class="sticky-posts-list"><@listNodes type="com.teamhub.models.node.Question" pageSize=5 container=space withState="site_sticky" sort="newest"; question>
    <p><a href="<@url obj=question />">${question.title?html}</a></p>
</@listNodes></div>

<div class="widget">
        <div class="widget-header">
        <#if showList || (hasContent?? && hasContent == true)>
            <div class="pull-left dropdown">
                <a class="pull-left dropdown-toggle" data-toggle="dropdown" href="#"><h3><#if title??>${title}<#else><@trans key="question.list.title"/></#if> <i class="icon-caret-down"></i></h3></a>
                <ul class="dropdown-menu">
                    <li><a href="<@url name="questions:unanswered" />"><@trans key="question.unanswered.title" /></a></li>
                    <li><a href="<@url name="questions:recommended" />"><@trans key="question.recommended.title" /></a></li>
                </ul>
            </div>
        <#assign feedUrl><@url name="feed:questions"/></#assign>
        <@teamhub.sortBar pager=questionPager feedUrl=feedUrl />
        <#else>
            <#include "/includes/pager/list_sort_bar_empty.ftl" />
        </#if>
    </div>

    <div class="widget-content">
    <#if showList || (hasContent?? && hasContent == true)>
        <#list questionPager.list as question><#include "../actions/question_item.ftl"></#list>
        <#if questionPager.list?size == 0 && sort == "hottest"><@trans key="sort.hottest.empty" default="There are currently no hottest questions"/>.</#if>
    <#else>
                <#include "/nodes/list_empty.ftl" />
    </#if>

    <@teamhub.paginate questionPager />
    </div>
</div>

<content tag="postMainContentWidgets">ahub.postMainContent</content>


<content tag="sidebarOneWidgets">ahub.indexSidebar</content>

<content tag="sidebarTwoWidgets">ahub.indexSidebar</content>
