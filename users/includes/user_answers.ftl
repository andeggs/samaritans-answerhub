<#if !currentUser?? || currentUser.id != profileUser.id>
    <h3><@trans key="thub.users.profile.tabs.answers.personalized" params=[profileUser.username?html] /></h3>
<#else>
    <h3><@trans key="thub.users.profile.tabs.answers.curUser" /></h3>
</#if>
<br/>
<#if answerPager.listCount == 0>
    <p><@trans key="thub.users.profile.tabs.answers.noAnswers" params=[profileUser.username?html] /></p>
</#if>
<#list answerPager.list as answer>
    <#include "../../actions/answer_item.ftl">
</#list>