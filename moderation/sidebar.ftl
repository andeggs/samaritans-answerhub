<#function spacesFilterContains space>
    <#list spacesFilter as nextSpace>
        <#if nextSpace.id == space.id><#return true></#if>
    </#list>
    <#return false>
</#function>

<div class="boxC">
    <div class="alert alert-info">
        <#if reported??>
            ${nodesQuery.count} <@trans key="label.reportedNodesInModeration" default="post(s) have been reported"/>
        <#else>
            ${nodesQuery.count} <@trans key="label.nodesInModeration" default="post(s) waiting moderation"/>
        </#if>
    </div>
    <form action="" method="GET">
        <#if tab??><input type="hidden" name="tab" value="${tab}"/></#if>
        <#if !reported??>
        <h4 class="subtitle"><@trans key="moderation.sidebar.queueType" default="Queue type" /></h4>
        <select name="queueType" id="queueType" class="mod-filter-field">
            <option value="moderation" <#if !queueType?? || queueType == "moderation">selected="selected"</#if>><@trans key="moderation.sidebar.inModeration" default="In moderation" /></option>
            <option value="wait-reply" <#if queueType == "wait-reply">selected="selected"</#if>><@trans key="moderation.sidebar.waitingReply" default="Waiting reply" /></option>
            <option value="replied" <#if queueType == "replied">selected="selected"</#if>><@trans key="moderation.sidebar.replied" default="Replied" /></option>
            <option value="rejected" <#if queueType == "rejected">selected="selected"</#if>><@trans key="moderation.sidebar.rejected" default="Rejected" /></option>
        </select>
        </#if>
        <h4 class="subtitle"><@trans key="moderation.sidebar.filterBySpaces" default="Filter by spaces" /></h4>
        <small><@trans key="moderation.sidebar.ifNoSpaces" default="* If no spaces are selected, content from all spaces will be shown." /></small>
        <br />
        <ul style="list-style: none; margin-left: 0;">
            <@listSpaces requiredRole="VIEW_IN_REVIEW_NODES" excludeDefaults=false; space>
                <li>
                    <input type="checkbox" name="spaces" class="mod-filter-space-field child-of-${space.parent.id}" value="${space.id}"
                            <#if spacesFilter?? && spacesFilterContains(space)>checked="checked"</#if>/>
                ${space.name}</li>
            </@listSpaces>
        </ul>
        <div class="form-actions">
            <input type="reset" class="btn" value="<@trans key="moderation.sidebar.reset" default="Reset" />" id="mod-filter-space-reset" /> <input type="submit" class="btn btn-primary" value="<@trans key="moderation.sidebar.filter" default="Filter" />" />
        </div>
    </form>
</div>
