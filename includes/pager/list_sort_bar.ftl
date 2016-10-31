<#import "/macros/thub.ftl" as teamhub />

<#if !(sortTypes??)>
    <#assign sortTypes = {
    'active': "<i class=\"icon-edit\"></i>",
    'newest': "<i class=\"icon-time\"></i>",
    'hottest': "<i class=\"icon-fire\"></i>",
    'votes': "<i class=\"icon-thumbs-up\"></i>"
    } />
</#if>
<ul class="nav nav-pills sort">
    <li class="disabled" title="${trans('sort.relevance')}"><a href="#"><i class="icon-signal"></i></a></li>
    <#list sortTypes?keys as sortType>
    <li title="${trans('sort.${sortType}')}" <#if pager.sort?? && pager.sort == sortType>class="active"</#if>><a href="?sort=${sortType}${pager.additionalParamsAsString}">${sortTypes[sortType]}</a></li>
    </#list>
</ul>


