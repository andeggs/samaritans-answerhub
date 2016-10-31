<#if pager.page?number?long < pager.pageCount?number?long >
    <li class="next">
        <a href="?${pageVar}=${pager.page+1}&${pageSizeVar}=${pager.pageSize}&${sort}${pager.additionalParamsAsString}" title="<@trans key="label.next" />"><@trans key="thub.pager.next" /></a>
    </li>
</#if>