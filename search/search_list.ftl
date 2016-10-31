<#import "/macros/thub.ftl" as teamhub />
<#import "/spring.ftl" as spring />

<content tag="postHeaderWidgetsPath">ahub.subnav</content>
<content tag="packJS">
    <src>/scripts/thub.search.js</src>
</content>

<head>
<#if types??>
<#list types as listedType>
        <@cTypes.forType(listedType).include path="/nodes/list-includes/head_block.ftl" />
</#list>
</#if>
</head>
<#assign firstSet=true />
<#assign dateSep="" />
<div class="widget">
    <div class="widget-header">
        <i class="icon-search"></i>

        <#-- For reference, the output of query below has been sanitized in the actual controller -->
        <h3><@trans key="thub.search.resultsFor" default="Results For:" /> ${query}</h3>
    <#assign feedUrl><@url name="feed:questions"/></#assign>

        <ul class="nav nav-pills sort search-sort-links">
            <li title="${trans('sort.relevance')}" data-search-sort="relevance"><a href="javascript:void(0)"><i class="icon-signal"></i></a></li>
            <li title="${trans('sort.active')}" class="disabled"><a href="javascript:void(0)"><i class="icon-edit"></i></a></li>
            <li title="${trans('sort.newest')}" data-search-sort="newest"><a href="javascript:void(0)"><i class="icon-time"></i></a></li>
            <li title="${trans('sort.hottest')}" class="disabled"><a href="javascript:void(0)"><i class="icon-fire"></i></a></li>
            <li title="${trans('sort.votes')}" class="disabled"><a href="javascript:void(0)"><i class="icon-thumbs-up"></i></a></li>
        </ul>

    </div>

    <div class="widget-content">
    <#if searchPager.listCount == 0 >
        <h4 style="margin-top: 0; padding-top: 0;"><i>${searchPager.listCount}
                <@trans key="thub.search.resultsFound" params=[searchPager.listCount] default="Results Found" /></i></h4>
        <p><@trans key="thub.search.noResultsFound"/></p>
    <#else>
        <@listSearchResults results=mixedResults; topResults, internalResults, externalLoop>
            <#if topResults??>
                <h4 style="margin-top: 0; padding-top: 0;"><i><@trans key="thub.search.topResults" default="Top Results" /></i></h4>
                <@topResults; hit, highlight>
                    <#include "items/node-result.ftl" />
                </@topResults>
            </#if>

            <#if searchResults.count != 0>
                <h4 style="margin-top: 0; padding-top: 0;"><i>${searchPager.listCount} <#if externalLoop??><@trans key="thub.search.labelInternal" default="Internal" /> </#if>
                    <@trans key="thub.search.resultsFound" params=[searchPager.listCount] default="Results Found" /></i></h4>
                <@internalResults; hit, highlight, attachments>
                    <#include "items/node-result.ftl" />
                </@internalResults>
            <#else>
                <h4 style="margin-top: 0; padding-top: 0;"><i>${searchPager.listCount} <#if externalLoop??><@trans key="thub.search.labelInternal" default="Internal" /> </#if>
                    <@trans key="thub.search.resultsFound" params=[searchPager.listCount] default="Results Found" /></i></h4>
                <p><@trans key="thub.search.noResultsFound"/></p>
            </#if>

            <#if externalLoop??>
                <@externalLoop; title, externalResults>
                    <h4 style="margin-top: 0; padding-top: 0;"><i>${title}</i></h4>
                    <@externalResults; hit></@externalResults>
                </@externalLoop>
            </#if>
        </@listSearchResults>
     </#if>
    </div>
</div>

<content tag="sidebarTwoWidgets">ahub.searchSidebar</content>