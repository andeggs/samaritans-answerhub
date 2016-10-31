<#macro ideasPanel>
<div class="tab-pane active" id="idea">
    <div class="widget-body-container" style="padding-top: 2px;">

    <#list ideasFollowed as topic>
        <#assign node=topic.nodeToFollow>
        <div class="node-list-item ${node.typeName}-list-item" nodeId=${node.id}>
            <div class="type-icon">
                <i class="icon-lightbulb"></i>
            </div>
            <div class="gravatar-wrapper">
                <@teamhub.avatar node.lastActiveUser 32 true/>
            </div>
            <div class="info">
                <p><@teamhub.objectLink object=node.lastActiveUser content=userUtils.displayName(node.lastActiveUser)/> <@trans key="idea.nodes.listIncludes" params=[node.lastActionVerb?replace(' ', '_')] />
                </p>
                <h4 class="title"><a href="${node.viewUrl}">${node.title}</a>
                    <#if node.status.closed??> <span
                            class="label"><@trans key="ahub.questionHeadline.closed" /></span></#if>
                    <#if node.isWiki()> <span class="label label-info"><@trans key="label.wiki" /></span></#if>
                    <#assign ideaStatus = plugin.ideaUtils.ideaStatus(node) />
                    <#if ideaStatus != "none">
                        <a href="<@url name="ideas:list_state" state=ideaStatus />"><span
                                class="idea-status-label label ${ideaStatus}"><@trans key="idea.states.${ideaStatus}" default="${ideaStatus}" /></span></a>
                    </#if>
                </h4>

                <p class="last-active-user muted">
                    <span title="${node.lastActiveDate}"><@dateSince date=node.lastActiveDate format="MMM d, ''yy"/></span>
                        <span class="tags"><#list node.organizedTopics as topic><#assign topicTitle><@teamhub.clean topic.title /></#assign><@teamhub.objectLink object=topic content=topicTitle class="tag"/><#if topic_has_next>&middot;</#if></#list></span>
                </p>
            </div>
            <div class="counts ">
        <span style="display:inline-block;position:relative;vertical-align: middle;float:right;">
            <#if currentUser??><a href="?dummy=1#idea"
                    class="btn btn-follow <#if teamHubManager.socialManager.isUserFollowing(topic.nodeToFollow, profileUser)??>on btn-info</#if>"
                    command="follow" data-node-type="idea" nodeId="${topic.nodeToFollow.id}"></a>
            </#if>
        </span></div>
        </div>
    </#list>
    </div>
    <@teamhub.paginate usersPager />
</div>
</#macro>

<div class="tab-pane" id="idea">
<@ideasPanel/>
</div>

