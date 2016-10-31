<#import "../macros/security.ftl" as security />
<#import "/macros/thub.ftl" as teamhub />
<#import "/spring.ftl" as spring />
<#import "../nodes/comments.ftl" as commentMacros />

<html>
<@relate node=question; rel>
<head>
    <title><@teamhub.clean question.title /> - Activity Stream</title>
</head>
<body>
<content tag="postHeaderWidgetsPath">ahub.question.header</content>

<div class="widget  " xmlns="http://www.w3.org/1999/html">
    <div class="widget-header">
        <h3>Activity Stream: ${question.title}</h3>
    </div>
<div class="widget-content">

    <#list activities as action>






        <div class="activity_stream_item">
            <div class="gravatar-wrapper">
                <@teamhub.avatar action.node.author 36 true/>
            </div>
			<span>
			<div class="activity_stream_container">
                &nbsp;
                <@teamhub.objectLink object=action.node.author content=userUtils.displayName(action.node.author)/>
            </span>
            <#if action.verb == "answered" >
                <a href="<@url obj=action.node />">${action.verb}</a>
                the
                <a href="<@url obj=action.node.parent />">${action.node.parent.getType()}</a>
            <#elseif action.verb == "commented" >
                <a href="<@url obj=action.node />">${action.verb}</a>
                the
                <a href="<@url obj=action.node.parent />">${action.node.parent.getType()}</a>
            <#else>
            ${action.verb}
                <a href="<@url obj=action.node />">${action.node.getType()}</a>

            </#if>



            <@dateSince date=action.actionDate format="MMM d, ''yy"/>
        </div>
    </div>
        <div style="clear:both"></div>
    </#list>
</div>
</div>

</@relate>

</body>
</html>