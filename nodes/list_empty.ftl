<#import "/macros/thub.ftl" as teamhub />

<#if !topic?? && !currentSpace?? && !listType?? &&
    ((currentUser?? && currentUser.hasRole('ROLE_SITE_OWNER')) || currentSite.isSiteFirstHits)>
    <#include "list_empty_callouts.ftl" />
</#if>

<#if mixed?? && mixed>
    <#list listedTypes as listedType>
        <@cTypes.forType(listedType).include path="/nodes/list-includes/node_item_block_empty.ftl" />
    </#list>
<#elseif listType??>
    <@listType.include path="/nodes/list-includes/node_item_block_empty.ftl" />
<#else>
    <#list cTypes.writableTypes as type>
        <@type.include path="/nodes/list-includes/node_item_block_empty.ftl" />
    </#list>
</#if>
