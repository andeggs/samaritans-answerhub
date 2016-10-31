<#import "/macros/thub.ftl" as teamhub />

<#assign userTopics=teamHubManager.socialManager.getUserTopicInterest(profileUser)!0 />

<div id="${profileUser.id}-topics-block" class="widget about-block" xmlns="http://www.w3.org/1999/html"
     xmlns="http://www.w3.org/1999/html">
    <div class="widget-header">
        <h3>
            <#if currentUser?? && profileUser.id == currentUser.id>
                <@trans key="thub.users.profile.blocks.topics.userTopics.yours" />
            <#else>
                <@trans key="thub.users.profile.blocks.topics.userTopics" params=[userUtils.displayName(profileUser)] />
            </#if>
        </h3>
    </div>
    <div class="widget-content">

        <div class="topic_interest topic-block tags">
        <#if isSameUser && !userTopics?is_enumerable>

        <div>
            <#include "topics_interest_empty.ftl" />
        </div>
        <#elseif userTopics?is_enumerable>

            <#list userTopics as topic>
                            <#assign topicTitle><@teamhub.clean topic.title /></#assign><@teamhub.objectLink object=topic content=topicTitle class="tag"/>
                        </#list>
        </#if>

        </div>

    </div>
</div>

