<#assign listActivity = true />

<#if activityPager.page == 1 && activityPager.list?size < 3 && currentUser?? && currentUser == profileUser>
    <#assign listActivity = false />
    <#list activityPager.list as action>
            <#if action.type != 'userjoins' && action.type != 'userjoinsite'>
                <#assign listActivity = true />
            </#if>
        </#list>
</#if>


<#if !listActivity>
    <#include "/users/profile/blocks/activity_empty.ftl" />

    <#else>

    <#list activityPager.list as action>
        <#include "../../actions/action_item.ftl">
    </#list>
</#if>