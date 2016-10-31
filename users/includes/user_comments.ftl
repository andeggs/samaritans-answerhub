<#if !currentUser?? || currentUser.id != profileUser.id>
<h3><@trans key="thub.users.profile.tabs.comments.personalized" params=[profileUser.username?html] /></h3>
<#else>
<h3><@trans key="thub.users.profile.tabs.comments.curUser" /></h3>
</#if>
<br/>
<#if commentPager.listCount == 0>
<p><@trans key="thub.users.profile.tabs.comments.noAnswers" params=[profileUser.username?html] /></p>
</#if>
<#list commentPager.list as comment>

    <#include "../../actions/comment-item.ftl">
</#list>