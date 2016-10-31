<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<head>
    <title><#if title??>${title}<#else><@teamhub.setting key="site.title"/></#if></title>
</head>
<body>

<content tag="postHeaderWidgetsPath">ahub.subnav</content>

<content tag="preMainContentWidgets">ahub.preMainContent.index</content>


<div class="sticky-posts-list"><@listNodes type="com.teamhub.models.node.Question" container=space withState="sticky" sort="newest"; question>
    <p><a href="<@url obj=question />">${question.title}</a></p>
</@listNodes></div>

<#assign showList = questionPager.list?size != 0 />

<div class="widget">
    <div class="widget-header">
        <#if mixed?? && mixed>
            <h3><@trans key="thub.space.title" params=[space.name] /></h3>
        <#else>
        <div class="pull-left dropdown">
            <a class="pull-left dropdown-toggle" data-toggle="dropdown" href="#"><h3><#if tab?? && tab == "unanswered"><@trans key="question.unanswered.space.title" params=[space.name]/><#else><@trans key="question.all.space.title" params=[space.name]/></#if> <i class="icon-caret-down"></i></h3></a>
            <ul class="dropdown-menu">
                <#if tab?? && tab == "unanswered" >
                    <li><a href="?unanswered=false"><@trans key="question.all.space.title" params=[space.name]/></a></li>
                <#else>
                    <li><a href="?unanswered=true"><@trans key="question.unanswered.space.title" params=[space.name]/></a></li>
                </#if>
            </ul>
        </div>
        </#if>
        <#if showList>
            <#assign feedUrl><@url name="feed:questions"/></#assign>
            <@teamhub.sortBar pager=questionPager feedUrl=feedUrl />
        <#elseif !tab?? || tab != "unanswered">
            <#include "/includes/pager/list_sort_bar_empty.ftl" />
        </#if>
    </div>

    <div class="widget-content">
    <#if showList>
        <#list questionPager.list as question><#include "actions/question_item.ftl"></#list>
    <#elseif tab?? && tab == "unanswered">
        <p><@trans key="thub.guide.unanswered.space.noResultsFound" params=[space.name]/></p>
    <#else>
        <#include "/nodes/list_empty.ftl" />
    </#if>

    <@teamhub.paginate questionPager />
    </div>
</div>

<content tag="postMainContentWidgets">ahub.postMainContent</content>

<content tag="sidebarOneWidgets">ahub.indexSidebar</content>

<content tag="sidebarTwoWidgets">ahub.indexSidebar</content>

</body>


<content tag="tail"><@teamhub.paginate questionPager /></content>


</html>