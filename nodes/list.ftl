<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<#import "/macros/security.ftl" as security />

<html>
<head>
    <title><#if title??>${title}<#else><@trans key=".${contentType!'node'}.list.title"/></#if></title>
<#include "/nodes/list-includes/core_head_block.ftl" />
<#if mixed>
    <#list listedTypes as listedType>
        <@cTypes.forType(listedType).include path="/nodes/list-includes/head_block.ftl" />
    </#list>
<#elseif listType??>
    <@listType.include path="/nodes/list-includes/head_block.ftl" />
</#if>
</head>
<body>
<content tag="tab">${contentType!'node'}s</content>
<content tag="postHeaderWidgetsPath">ahub.subnav</content>

<#assign firstSet=true />

<#assign dateSep="" />

<#assign showList = listPager.list?size != 0 />

<#if currentSpace??>
    <#assign nodeState = "sticky">
<#else>
    <#assign nodeState = "site_sticky">
</#if>

<#if contentType??>
<div class="sticky-posts-list"><@listNodes type=contentType pageSize=5 container=space withState=nodeState sort="newest"; content>
    <p><a href="<@url obj=content />">${content.title}</a></p>
</@listNodes></div>
<#else>
<div class="sticky-posts-list"><@listNodes pageSize=5 container=space withState=nodeState sort="newest"; question>
    <p><a href="<@url obj=question />">${question.title}</a></p>
</@listNodes></div>
</#if>


<div class="widget">
    <div class="widget-header">
    <#if showList>
        <i class="icon-list-alt"></i>
            <h3><#if title??>${title}<#else><@trans key=".${contentType!'node'}.list.title"/></#if></h3>
            <@teamhub.sortBar pager=listPager feedUrl=feedUrl />
    <#else >
        <#include "/includes/pager/list_sort_bar_empty.ftl" />
    </#if>
    </div>

    <div class="widget-content" id="id_topic_content">
    <#if showList>
        <#list listPager.list as node>
            <@node.include path="/nodes/list-includes/node_item_block.ftl" />
        </#list>
    <#else>
        <#include "list_empty.ftl" />
    </#if>

    <#if showList>
        <@teamhub.paginate listPager />
    </#if>
    </div>
</div>

<content tag="sidebarTwoTop">
<#if mixed>
    <#include "/nodes/list-includes/sidebar/sidebar_top.ftl" />
<#elseif listType??>
    <@listType.include path="/nodes/list-includes/sidebar/sidebar_top.ftl" />
</#if>
</content>
<content tag="sidebarOneTop">
<#if mixed>
    <#include "/nodes/list-includes/sidebar/sidebar_top.ftl" />
<#elseif listType??>
    <@listType.include path="/nodes/list-includes/sidebar/sidebar_top.ftl" />
</#if>
</content>
<content tag="sidebarTwoWidgets">ahub.indexSidebar</content>
<content tag="sidebarOneWidgets">ahub.indexSidebar</content>

</body>
</html>