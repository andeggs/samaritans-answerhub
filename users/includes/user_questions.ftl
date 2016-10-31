<#import "/macros/thub.ftl" as teamhub />
<#if !currentUser?? || currentUser.id != profileUser.id>
<h3><@trans key="thub.users.profile.tabs.questions.personalized" params=[profileUser.username] /></h3>
<#else>
<h3><@trans key="thub.users.profile.tabs.questions" /></h3>
</#if>
<br/>
<#if questionPager.listCount == 0>
<p><@trans key="thub.users.profile.tabs.questions.noQuestions" params=[profileUser.username]/></p>
</#if>
<#list questionPager.list as question>
    <#include "../../actions/question_item.ftl">
</#list>

