<@cache key="related_topics" subkey=node.id cacheTime=60*60>
    <#assign topics = relatedTopics() />
    <#if topics?size &gt; 0>
    <div class="widget">
        <div class="widget-header">
            <i class="icon-tags"></i>
            <h3><@trans key="thub.widgets.relatedTopics.title" /></h3>
        </div>
        <div class="widget-content topic-block tags">
            <#list topics as topic>
                <a class="tag" nodeId="${topic}" rel="topic" no-popover="1" title="see questions tagged '${topic.name}'" href="<@url name="topics:view" topics=topic.name/>">${topic.name}</a>
            </#list>
            <br/>
        </div>
    </div>
    </#if>
</@cache>
