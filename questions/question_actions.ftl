<#import "/macros/teamhub.ftl" as teamhub />

<#list actions as act>
    <#if !node??>
        <#assign node=act.node />
    </#if>
    <#if act.type != "nodeview">

        <@teamhub.objectLink act.user userUtils.displayName(act.user)/>

        <#if act.verb == "voted">
        up
        </#if>
    ${act.verb}

        <#if act.node.type != "question" && act.verb != "answered" && act.verb != "commented">
            <#if act.node.type =="answer">
            an answer in
            <#else>
            a comment in
            </#if>
        </#if>
    <a href="<@url obj=node />">${node.title}</a>
    (${act.actionDate?string("MM/dd/yyyy HH:MM")})
    <br/>
    </#if>
</#list>