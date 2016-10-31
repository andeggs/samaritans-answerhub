<#if pager.page?number?long != 1 && pager.pageCount?number?long &gt; 5 && pager.page?number?long &gt; 3>
<li class="first">
    <a href="?${pageVar}=${1}&${pageSizeVar}=${pager.pageSize}&${sort}${pager.additionalParamsAsString}" title="<@trans key="label.first" />"><@trans key="thub.pager.first" /></a>
</li>
</#if>