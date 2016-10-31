<#assign popTopics = teamHubManager.topicManager.getTagsForSite(currentSite, "popularity", 1, 30) />

<div class="widget" id="recent-topics-widget">
    <div class="widget-header">
        <i class="icon-tags"></i>
        <h3><@trans key="thub.widgets.popTopics.title" /></h3>
    </div>
<div class="widget-content topic-block tags" style="position: relative;">
    <#if popTopics?size == 0>
        <#include "popular_topics_empty.ftl">
    <#else >
        <#list popTopics as topic>
            <#if currentSpace??>
                <a class="tag" nodeId="${topic.id}" rel="topic" no-popover="1" title="see questions tagged '${topic.title}'" href="<@url obj=currentSpace/>?topics=${topic.title}">${topic.title}</a>
            <#else>
                <a class="tag" nodeId="${topic.id}" rel="topic" no-popover="1" title="see questions tagged '${topic.title}'" href="<@url name="topics:view" topics=topic.title/>">${topic.title}</a>
            </#if>
        </#list>
        <br/>
        <a href="<@url name="topics" abs=true />"><@trans key="thub.widgets.poptopics.viewAll" /></a>

    </#if>
</div>
</div>

