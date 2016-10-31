<#import "/spring.ftl" as spring />
<#import "/macros/teamhub.ftl" as teamhub />

<#macro questionsPanel>

<div class="widget-body-container" style="padding-top: 2px;">

<ul class="userlist unstyled">
    <#if questionPager??>
        <content tag="tail"><@teamhub.paginate questionPager false /></content>
        <#assign questions = questionPager.list>

        <#list questionPager.list as topic>
            <li>
                <div class="node-list-item ${topic.typeName}-list-item pagination" nodeId=${topic.id}>
                    <div class="gravatar-wrapper">
                        <@teamhub.avatar topic.lastActiveUser 32 true/>
                    </div>
                    <div class="info">
                        <p><@teamhub.objectLink object=topic.lastActiveUser content=userUtils.displayName(topic.lastActiveUser)/>
                        </p>
                        <h4 class="title"><a href="${topic.viewUrl}">${topic.title}</a>

                        </h4>

                        <p class="last-active-user muted">
                            <span title="${topic.lastActiveDate}"><@dateSince date=topic.lastActiveDate format="MMM d, ''yy"/></span>
                            <#if topic.space.name != "Default">
                                <@trans key="label.in" default="in"/>
                            <#else>
                                <span class="tags"><#list topic.organizedTopics as topic><#assign topicTitle><@teamhub.clean topic.title /></#assign><@teamhub.objectLink object=topic content=topicTitle class="tag"/><#if topic_has_next>&middot;</#if></#list></span>
                            </#if>
                        </p>
                    </div>
                    <div class="counts ">
        <span style="display:inline-block;position:relative;vertical-align: middle;float:right;">
            <#if currentUser??><a href="#"
                                  class="btn btn-follow <#if teamHubManager.socialManager.isUserFollowing(topic, profileUser)??>on btn-info</#if>"
                                  command="follow" data-node-type="question" nodeId="${topic.id}"></a>
            </#if>
        </span></div>
                </div>
            </li>

        </#list>

    </ul>
        <@teamhub.paginate questionPager />
    <#else>
        <@trans key="thub.questions.followed.empty" />
    </#if>

</div>
</#macro>

<div class="tab-pane" id="question">
<@questionsPanel/>
</div>

