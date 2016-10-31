<#assign panelName = contentType.simpleName + "Panel">
<#assign pagerName = contentType.simpleName + "Pager">
<#if contentPagerMap??>
    <#assign contentListPager = contentPagerMap[pagerName]>
</#if>
<#macro panelName>
<div class="widget-body-container" style="padding-top: 2px;">
<ul class="userlist unstyled">
    <#if contentListPager?? && contentListPager.list?size gt 0>
        <content tag="tail"><@teamhub.paginate contentListPager false /></content>
        <#assign questions = contentListPager.list>

        <#list contentListPager.list as node>
            <li>
                <div class="node-list-item ${node.typeName}-list-item pagination" nodeId=${node.id}>
                    <div class="gravatar-wrapper">
                        <@teamhub.avatar node.lastActiveUser 32 true/>
                    </div>
                    <div class="info">
                        <p><@teamhub.objectLink object=node.lastActiveUser content=userUtils.displayName(node.lastActiveUser)/>
                        </p>
                        <h4 class="title"><a href="${node.viewUrl}">${node.title}</a>

                        </h4>

                        <p class="last-active-user muted">
                            <span title="${node.lastActiveDate}"><@dateSince date=node.lastActiveDate format="MMM d, ''yy"/></span>
                            <#if node.space.name != "Default">
                                <@trans key="label.in" default="in"/>
                            <#else>
                                <span class="tags"><#list node.organizedTopics as topic><#assign topicTitle><@teamhub.clean topic.title /></#assign><@teamhub.objectLink object=topic content=topicTitle class="tag"/><#if topic_has_next>&middot;</#if></#list></span>
                            </#if>
                        </p>
                    </div>
                    <div class="counts ">
        <span style="display:inline-block;position:relative;vertical-align: middle;float:right;">
            <#if currentUser??><a href="#"
                                  class="btn btn-follow <#if teamHubManager.socialManager.isUserFollowing(node, profileUser)??>on btn-info</#if>"
                                  command="follow" data-node-type="${contentType.simpleName}" nodeId="${node.id}"></a>
            </#if>
        </span></div>
                </div>
            </li>

        </#list>

    </ul>
        <@teamhub.paginate contentListPager />
    <#else>
        <#assign key><@trans key=".label.${contentType.simpleName}.list"/></#assign>
        <@trans key="thub.content.followed.empty"/> ${key?lower_case}
    </#if>
</div>
</#macro>

<div class="tab-pane" id="${contentType.simpleName}">
<@panelName/>
</div>

