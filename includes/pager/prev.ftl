<#if pager.page?number?long != 1 >
    <li class="prev">
        <a href="?${pageVar}=${pager.page-1}&${pageSizeVar}=${pager.pageSize}&${sort}${pager.additionalParamsAsString}" title="<@trans key="label.previous" />"><@trans key="thub.pager.prev" /></a>
    </li>
</#if>