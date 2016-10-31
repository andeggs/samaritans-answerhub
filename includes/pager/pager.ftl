<#assign pageVar = "page" />
<#assign pageSizeVar = "pageSize" />
<#if pager.name != "" >
    <#assign pageVar = pager.name + "Page" />
    <#assign pageSizeVar = pager.name + "PageSize" />
</#if>

<#assign sort = "" />
<#if pager.sort??>
    <#if pager.name != "" >
        <#assign sort = pager.name + "Sort=" + pager.sort/>
    <#else>
        <#assign sort = "sort=" + pager.sort/>
    </#if>
</#if>

<#if 1 < pager.pageCount>
    <div class="pagination">
        <ul>
            <#include "first.ftl" />
            <#include "prev.ftl" />
            <#include "pages.ftl" />
            <#include "next.ftl" />
            <#include "last.ftl" />
        </ul>
    </div>
</#if>        