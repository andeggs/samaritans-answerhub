<#import "/macros/thub.ftl" as teamhub />
<#if teamHubManager.socialManager.getFollowRelation(action.followId)??>
<#assign relation = teamHubManager.socialManager.getFollowRelation(action.followId)/>
<div id="follow-${relation.id}" class="row-fluid">
    <#assign followOrigin = action.user/>
    <#assign followOriginTitle = userUtils.displayName(followOrigin)/>
    <#if relation.nodeToFollow??>
        <#assign followDest = relation.nodeToFollow/>
        <#assign followDestTitle = relation.nodeToFollow.title />
        <#assign followType = relation.nodeToFollow.type />
        <div class="span10">
            <@teamhub.objectLink object=followOrigin content=followOriginTitle class="user"/> <@trans key="thub.actions.follow_item.${action.verb?replace(' ', '_')}" /> <@trans key="thub.actions.follow_item.${followType}" default="the ${followType}"/> "<a href="<@url obj=followDest />"><#if followDestTitle?length <= 70>${followDestTitle}<#else>${followDestTitle?substring(0,65)}...</#if></a>" <@trans key="thub.actions.follow_item.tags" default="with the tags" /> <#list followDest.organizedTopics as topic><#assign topicTitle><@teamhub.clean topic.title /></#assign><@teamhub.objectLink object=topic content=topicTitle class="tag"/><#if topic_has_next>&middot;</#if></#list>
        </div>
        <div class="span2">
            <@dateSince date=action.actionDate />
        </div>
    <#elseif relation.userToFollow??>
        <#assign followDest = relation.userToFollow/>
        <#assign followDestTitle = userUtils.displayName(followDest) />
        <div class="span10">
        	<@teamhub.objectLink object=followOrigin content=followOriginTitle class="user"/> <@trans key="thub.actions.follow_item.${action.verb?replace(' ', '_')}" /> <@trans key="thub.actions.follow_item.user" default="user" /> <@teamhub.objectLink object=followDest content=followDestTitle class="user"/>
	    </div>
	    <div class="span2">
	        <@dateSince date=action.actionDate />
	    </div>
    <#elseif relation.spaceToFollow??>
        <#assign followDest = relation.spaceToFollow/>
        <#assign followDestTitle = relation.spaceToFollow.name />
        <div class="span10">
        	<@teamhub.objectLink object=followOrigin content=followOriginTitle class="user"/> <@trans key="thub.actions.follow_item.${action.verb?replace(' ', '_')}" /> <@trans key="thub.actions.follow_item.space" default="space" /> <@teamhub.objectLink object=followDest content=followDestTitle class="space"/>
	    </div>
	    <div class="span2">
	        <@dateSince date=action.actionDate />
	    </div>
    <#elseif relation.topicToFollow??>
        <#assign followDest = relation.topicToFollow/>
        <#assign followDestTitle = relation.topicToFollow.title />
        <div class="span10">
        	<@teamhub.objectLink object=followOrigin content=followOriginTitle class="user"/> <@trans key="thub.actions.follow_item.${action.verb?replace(' ', '_')}" /> <@trans key="thub.actions.follow_item.topic" default="topic" /> <@teamhub.objectLink object=followDest content=followDestTitle class="tag"/>
	    </div>
	    <div class="span2">
	        <@dateSince date=action.actionDate />
	    </div>
    </#if>
</div>
</#if>