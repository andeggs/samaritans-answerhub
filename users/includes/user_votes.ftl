<h3><@trans key="thub.users.profile.tabs.votes" /></h3>
<#if votesPager.list?size != 0 >
    <#list votesPager.list as action>
        <#include "../../actions/activity_item.ftl">
    </#list>
<#else >
    <@trans key="thub.users.profile.tabs.votes.noVotes" />
</#if>