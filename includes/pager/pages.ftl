<#--if there are 5 or more pages, the current page is the last page, and the current page isn't page 4: print the fourth page before the current-->
<#if 5 <= pager.pageCount && pager.pageCount-1 < pager.page?number && pager.page != 4 >
    <@pagerPage pager pager.page-4 />
</#if>
<#--if there are 4 or more pages, the current page is the last page or second to last, and the current page isn't page 3: print the third page before the current-->
<#if 4 <= pager.pageCount && pager.pageCount-2 < pager.page?number && pager.page != 3>
    <@pagerPage pager pager.page-3 />
</#if>
<#--if there are more than 2 pages before the current print the second page before the current-->
<#if 0 < pager.page?number?double-2><@pagerPage pager pager.page-2 /></#if>
<#--if there is more than one pages print the page before the current-->
<#if 0 < pager.page?number?double-1><@pagerPage pager pager.page-1 /></#if>

<#--print current page-->
<@pagerPage pager pager.page true />

<#--if there is one or more page after the current print the next page-->
<#if pager.page?number?double+1 <= pager.pageCount><@pagerPage pager pager.page+1 /></#if>
<#--if two or more pages after the current print the page after next-->
<#if pager.page?number?double+2 <= pager.pageCount><@pagerPage pager pager.page+2 /></#if>

<#--if the current page is before the third, there are more than 3 pages, and the third page after the current exists: print the third page after the current-->
<#if pager.page?number < 3 && 3 < pager.pageCount && pager.page+3 <= pager.pageCount>
    <@pagerPage pager pager.page+3 />
</#if>

<#--if the current page is the first and there are more than 4 pages: print the fifth page-->
<#if pager.page?number == 1 && 4 < pager.pageCount>
    <@pagerPage pager 5 />
</#if>

<#macro pagerPage pager page active=false>
    <#if active><li class="active"><a <#else><li><a href="?${pageVar}=${page}&${pageSizeVar}=${pager.pageSize}&${sort}${pager.additionalParamsAsString}"</#if>>${page}</a></li>
</#macro>