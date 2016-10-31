<#if question??>
    <#assign canObj=question />
<#elseif content??>
    <#assign canObj=content />
<#elseif profileUser??>
    <#assign canObj=profileUser />
</#if>
<#if canObj??>
<link rel="canonical" href="<@url obj=canObj />" />
</#if>