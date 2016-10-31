<#if pager.page?number?long < pager.pageCount?number?long && 5 < pager.pageCount?number?long && pager.pageCount?number?long-3 &gt;= pager.page?number?long>
<li class="last">
    <a href="?${pageVar}=${pager.pageCount?number}&${pageSizeVar}=${pager.pageSize}&${sort}${pager.additionalParamsAsString}" title="<@trans key="label.last" />  (${pager.pageCount?number?long})"><@trans key="thub.pager.last" /></a>
</li>
</#if>