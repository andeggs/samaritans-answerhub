<div class="tab-pane active" id="topics">
<#if RequestParameters["setPassword"]??>
    <div class="setPasswordPrompt"><@trans key="thub.users.edit.setPasswordPrompt" /></div>
    <br>
</#if>
    <div class="widget-body-container" style="padding-top: 2px;">
    <#if topicsPager?? && topicsPager.list?size != 0>
        <ul class="tagsList tags unstyled" style="min-height:inherit;">
            <#list topicsPager.list as topic>
                <li style="white-space: nowrap;overflow:hidden;text-overflow: ellipsis;margin-right: 5px;">
                    <#assign topicTitle><@teamhub.clean topic.title /></#assign>
                        <@teamhub.objectLink object=topic content=topicTitle class="tag"/>
                </li>
                <li>
                    <#if currentUser??><a
                            class="btn btn-follow <#if teamHubManager.socialManager.isUserFollowing(topic, profileUser)??>on btn-info</#if>"
                            command="follow" data-node-type="topic" nodeId="${topic.name}"></a></#if>
                </li>
            </#list>
        </ul>
        <@teamhub.paginate topicsPager />
        <#else>
            <@trans key="thub.topics.followed.empty" />
        </#if>
    </div>

</div>
