<#import "/macros/thub.ftl" as teamhub />

<head>
    <title><@trans key="thub.topics.title" /></title>
</head>

<content tag="fullWidth"></content>
<content tag="tab">topics</content>
<div class="widget">
    <div class="widget-header">
        <i class="icon-list-alt"></i>

        <h3><@trans key="thub.topics.title" /></h3>

    <#assign sortTypes = {
    'popularity': trans('thub.topics.sort.popular', 'popular'),
    'name': trans('thub.topics.sort.alphabetical','alphabetical')
    } />

    <#if !topicPager?? && searchPager??><#assign topicPager = searchPager /></#if>

    <@teamhub.sortBar pager=topicPager sorts=sortTypes />
    </div>

    <div class="widget-content" id="tagpix">

        <ul class="tagsList tags">
        <#if topicPager.list?size != 0>
            <#list topicPager.list as topic>
                <li>
                    <#assign topicTitle><@teamhub.clean topic.title /></#assign>
                    <@teamhub.objectLink object=topic content=topicTitle class="tag"/>
                    <span class="tag-number">&#215; ${topic.usedCount}</span><br/>
                </li>
            </#list>
        <#else>
            <@trans key="thub.topics.empty" />
        </#if>
        </ul>
    <@teamhub.paginate topicPager false/>
    </div>

</div>