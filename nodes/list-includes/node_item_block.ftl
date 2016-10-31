<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<#import "/macros/security.ftl" as security />

<div class="node-list-item ${node.typeName}-list-item">
    <div class="gravatar-wrapper">
        <#if node.lastActivityAction?? && security.hasPermission("view", node.lastActivityAction.node)>
            <@teamhub.avatar node.lastActiveUser 32 true "" "" "" "user-avatar-${node.id}" />
        <#else>
            <@teamhub.avatar node.author 32 true "" "" "" "user-avatar-${node.id}" />
        </#if>
    </div>
    <div class="info">
        <#assign userName>
            <@teamhub.showUserName user=node.lastActiveUser/>
        </#assign>
        <#if node.lastActivityAction?? && security.hasPermission("view", node.lastActivityAction.node)>
            <p><@teamhub.objectLink object=node.lastActiveUser content=userName/> <@trans key="thub.nodes.listIncludes.${node.lastActionVerb}" default="${node.lastActionVerb}"/></p>
        </#if>
            <h4 class="title"><a href="${node.viewUrl}"><#if node.visibility=='mod'><i class="icon icon-lock"></i>&nbsp;</#if>${node.title?html}</a>
        <#if node.status.closed??> <span class="label"><@trans key="thub.questionHeadline.closed" /></span></#if><#--
        --><#if node.isWiki()> <span class="label label-info"><@trans key="label.wiki" /></span></#if></h4>

        <p class="last-active-user muted">
            <span title="${node.lastActiveDate}"><@dateSince date=node.lastActiveDate format="MMM d, ''yy"/></span>
        <#if node.space.name != "Default">
            <@trans key="thub.nodes.listIncludes.in" default="in"/> <@teamhub.listSpaceHierarchy space=node.space; curSpace><a
                class="space-name" href="<@url obj=curSpace/>">${curSpace.name}</a></@teamhub.listSpaceHierarchy>
        <#--<#assign spaceLink><a class="space-name" href="<@url obj=node.space />">${node.space.name}</a></#assign>
        <@trans key="thub.node.list.inSpace" params=[spaceLink]/>-->
        <#else>
            <span class="tags"><#list node.organizedTopics as topic><#assign topicTitle><@teamhub.clean topic.title /></#assign><@teamhub.objectLink object=topic content=topicTitle class="tag"/><#if topic_has_next>&middot;</#if></#list></span>
        </#if>
        </p>
    </div>
    <div class="counts">
        <#if node.allowChildren>
            <#assign childCount = node.defaultChildrenCount />
            <p class="answers muted <#if node.isMarked()>accepted<#elseif childCount == 0> unanswered</#if>">
                <span>${childCount}</span> <@trans key="label.replies" params=[childCount]/></p>
        </#if>

        <p id="post-${node.id}-score-wrapper" class="votes muted">
            <span><@teamhub.number_as_thousands node.score /></span> <@trans key="label.votes" /></p>
    <#--<p class="views muted"><span><@teamhub.number_as_thousands node.viewCount /></span> <@trans key="label.views" /></p>-->
    </div>
</div>