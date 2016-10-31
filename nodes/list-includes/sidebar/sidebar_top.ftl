
<#if mixed>
    <#include "/nodes/list-includes/sidebar/node_count.ftl">
<#else>
    <@listType.include path="/nodes/list-includes/sidebar/node_count.ftl" />
</#if>

<#if currentSpace?? >
    <#if mixed>
        <#include "/nodes/list-includes/sidebar/space_info.ftl">
    <#else>
        <@listType.include path="/nodes/list-includes/sidebar/space_info.ftl" />
    </#if>
</#if>