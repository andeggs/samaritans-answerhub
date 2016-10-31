<#include "/macros/teamhub.ftl" />
<#-- This will have other macros in it -->

<#macro display_topic_link topic><#--
 --><#if topic??><#--
    --><a data-topic-rank="${topic.getUsedCount()}"

          data-topic-follow="${topic.showFollowersCount()}"

          data-topic-icon="<@url name="topics:icon" topic=topic />"

          href="<@url name="questions:topics" topics=topic.name />" rel="tag" class="tag"
          xmlns="http://www.w3.org/1999/html"><@teamhub.clean topic.title/></a><#--
 --></#if><#--
--></#macro>

<#function is_node_real_author node>
    <#if teamHubManager.getActionManager().getNodeCreationAction(node).getRealUser()??>
        <#return false>
    <#else>
        <#return true>
    </#if>
</#function>

<#function get_node_real_author node>
    <#assign firstAction = teamHubManager.getActionManager().getNodeCreationAction(node) />
    <#if firstAction.getRealUser()??>
        <#return firstAction.getRealUser()>
    <#else>
        <#return firstAction.getUser()>
    </#if>
</#function>

<#macro breadcrumbs object>
    <#if object??>
        <#if !(object?is_string && object == "")>
        <#-- We passed in an object and it wasn't the empty string, so lets figure out what to show -->
        <ul class="breadcrumb">
            <li>
                <a href="<@url name="index"/>"><@trans key="thub.subnav.home" /></a> <span class="divider">/</span>
            </li>
            <#if object.type?? && object.type != 'space' && object.type != 'smartspace'>
                <#if currentSmartSpace??>
                    <li><a href="<@url name="smart-spaces:index" space=currentSmartSpace.id plug=currentSmartSpace.plug />">${currentSmartSpace.name}</a> <span class="divider">/</span>
                    </li>
                <#elseif object.primaryContainer?? && object.primaryContainer.id != currentSite.id>
                <#-- Its a space, let's show the space heirarchy -->
                    <#list object.space.orderedParents as spaceParent>
                        <#if spaceParent.name != "Default">
                            <li><a href="<@url obj=spaceParent />">${spaceParent.name}</a> <span
                                    class="divider">/</span></li>
                        </#if>
                    </#list>
                    <#if object.space.name != "Default">
                        <li><a href="<@url obj=object.space />">${object.space.name}</a> <span class="divider">/</span>
                        </li>
                    </#if>
                </#if>
                <#if answerForm?? && answerForm.edit>
                    <li>
                        <a href="<@url obj=answerForm.node.originalParent />">${answerForm.node.originalParent.title?html}</a>
                        <span class="divider">/</span></li>
                </#if>
            <#--<#elseif object.type?? && object.type == 'topic'>
       <li><a href="<@url obj=object />">${object.title}</a> <span class="divider">/</span></li>-->
            <#elseif object.type?? && object.type == 'space'>
                <#list object.orderedParents as spaceParent>
                    <#if spaceParent.name != "Default">
                        <li><a href="<@url obj=spaceParent />">${spaceParent.name}</a> <span class="divider">/</span>
                        </li>
                    </#if>
                </#list>
            <#elseif object.type?? && object.type == 'user'>
                <#if notifyForm??> <#-- got some preferences form, object is a user -->
                    <li><a href="<@url obj=object />">User Profile: ${userUtils.displayName(object)?html}</a> <span
                            class="divider">/</span></li>
                </#if>
            <#--<#elseif object.level?? && object.mode??>
      <li><a href="<@url obj=object />"><@trans key=object.name/></a> <span class="divider">/</span></li>-->
            <#elseif object.node?? && (object.node.type == 'question' || object.node.type == 'answer')>
                <#assign node = object.node />
                <#if object.node.type == 'question'>
                    <#assign pnode = node />
                <#else>
                    <#assign pnode = node.originalParent />
                </#if>
                <#if object.node.primaryContainer.id != currentSite.id>
                <#-- Its a space, let's show the space heirarchy -->
                    <#list pnode.space.orderedParents as spaceParent>
                        <#if spaceParent.name != "Default">
                            <li><a href="<@url obj=spaceParent />">${spaceParent.name}</a> <span
                                    class="divider">/</span></li>
                        </#if>
                    </#list>
                    <#if pnode.name != "Default">
                        <li><a href="<@url obj=pnode.space />">${pnode.space.name}</a> <span class="divider">/</span>
                        </li>
                    </#if>
                </#if>
                <#if pnode.title != "Default">
                    <li><a href="<@url obj=node />">${pnode.title?html}</a> <span class="divider">/</span></li>
                </#if>
            <#else>
            <#-- We're some other type of object, how do we deal with it? -->
                <#if object.user??>
                <#-- Maybe we're editing a user? -->
                    <li><a href="<@url obj=object.user />">User Profile: ${userUtils.displayName(object.user)?html}</a>
                        <span class="divider">/</span></li>
                </#if>
            </#if>
        </ul>
        </#if>
    </#if>
</#macro>

<#macro controlBar node rel>
    <#include "../nodes/includes/control_bar.ftl" />
</#macro>

<#macro listSpaceHierarchy space><#--
 --><#list space.orderedParents as curSpace><#--
     --><#nested curSpace/> / <#--
 --></#list><#--
 --><#nested space/>
</#macro>

<#macro printSiteNotifications count=2>
    <#if teamHubManager.requestInfo.site?? && teamHubManager.siteManager.getMostRecentNotification(teamHubManager.requestInfo.site)??>
        <#assign notifications = teamHubManager.siteManager.getActiveSiteNotifications(teamHubManager.requestInfo.site, 1, count) />
        <#list notifications as notification>
            <#include "../includes/recent_notification.ftl" />
        </#list>
    </#if>
</#macro>