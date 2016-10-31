<#import "/macros/thub.ftl" as teamhub/>


<#if question??>
<div class="widget question-follow-widget">
    <div class="widget-header">
        <i class="icon-arrow-right"></i>
        <#if currentUser??>
        	<#if currentUser.hasRole("ROLE_FOLLOW") >
	            <#if teamHubManager.socialManager.isUserFollowing(question, currentUser)??>
	                <a href="<@url name="unfollow" objId=question type="question" />" class="btn btn-danger pull-right widget-action">
	                    <i class=" icon-remove-circle"></i>
	                    <@trans key="thub.widgets.follow.question.unfollow" /></a>
	            <#else>
	                <a href="<@url name="follow" objId=question type="question" />" class="btn btn-success pull-right widget-action"><i
	                        class="icon-ok-sign"></i>
	                    <@trans key="thub.widgets.follow.question.follow" /></a>
	            </#if>
            </#if>
        </#if>
        <h3><@trans key="thub.widgets.follow.question.title" /></h3>
    </div>
    <div class="widget-content">
    <#if !currentUser??>
        <p><@trans key="thub.widgets.follow.onceYouSignIn" /></p>
    </#if>
        <p>
            <a class="btn btn-small" title="<@trans key="thub.widgets.follow.question.subToAnswers" />"
               href="<@url name="feed:answers" question=question />">
                <i class="icon-rss"></i>

                <@trans key="label.answers" /> </a>


            <a class="btn btn-small" title="<@trans key="thub.widgets.follow.question.subToCommentsAndAnswers" />"
               href="<@url name="feed:comments:answers" node=question />">
                <i class="icon-rss"></i>
                <@trans key="thub.widgets.follow.question.answersAndComments" />
            </a>
        </p>

        <p>
            <@trans key="thub.widgets.follow.followerCount" params=[question.followers?size,"question"]/>

        <div class="followers">

            <#list question.followers as follower>
                    <@teamhub.avatar follower 24 true/>
                </#list>
        </div>
        </p>
    </div>

</div>
</#if>

<#if topic??>
<div class="widget topic-follow-widget">
    <div class="widget-header">
        <i class="icon-arrow-right"></i>
        <#if currentUser??>
            <#if teamHubManager.socialManager.isUserFollowing(topic, currentUser)??>
                <a href="<@url name="unfollow" objId=topic.name type="topic" />" class="btn btn-danger pull-right widget-action">
                    <i class=" icon-remove-circle"></i>
                    <@trans key="thub.widgets.follow.topic.unfollow" /></a>
            <#else>
                <a href="<@url name="follow" objId=topic.name type="topic" />" class="btn btn-success pull-right widget-action"><i
                        class="icon-ok-sign"></i>
                    <@trans key="thub.widgets.follow.topic.follow" /></a>
            </#if>
        </#if>
        <h3><@trans key="thub.widgets.follow.topic.title" /></h3>
    </div>
    <div class="widget-content">
        <#if !currentUser??>
            <p><@trans key="thub.widgets.follow.onceYouSignIn" /></p>
        </#if>
        <p>
            <a class="btn btn-small" title="<@trans key="thub.widgets.follow.topic.RSSFollow" />"
               href="<@url name="feed:topic" topic=topic />">
                <i class="icon-rss"></i>

                <@trans key="thub.widgets.follow.topic.RSSFollow" /> </a>
        </p>

        <p>
            <@trans key="thub.widgets.follow.followerCount" params=[topic.followers?size, "topic"]/>

        <div class="followers">

            <#list topic.followers as follower>
                    <@teamhub.avatar follower 24 true/>
                </#list>
        </div>
        </p>
    </div>
</div>
</#if>

<#if space??>
<div class="widget space-follow-widget">
    <div class="widget-header">
        <i class="icon-arrow-right"></i>
        <#if currentUser??>
            <#if teamHubManager.socialManager.isUserFollowing(space, currentUser)??>
                <a href="<@url name="unfollow" objId=space type="space" />" class="btn btn-danger pull-right widget-action">
                    <i class=" icon-remove-circle"></i>
                    <@trans key="thub.widgets.follow.space.unfollow" /></a>
            <#else>
                <a href="<@url name="follow" objId=space type="space" />" class="btn btn-success pull-right widget-action"><i
                        class="icon-ok-sign"></i>
                    <@trans key="thub.widgets.follow.space.follow" /></a>
            </#if>
        </#if>
        <h3><@trans key="thub.widgets.follow.space.title" /></h3>
    </div>
    <div class="widget-content">
        <#if !currentUser??>
            <p><@trans key="thub.widgets.follow.onceYouSignIn" /></p>
        </#if>
    <#--<p>
        <a class="btn btn-small"  title="<@trans key="thub.widgets.follow.question.subToAnswers" />" href="<@url name="feed:answers" question=space />" >
        <i class="icon-rss"></i>

        <@trans key="label.answers" /> </a>


        <a class="btn btn-small" title="<@trans key="thub.widgets.follow.question.subToCommentsAndAnswers" />" href="<@url name="feed:comments:answers" node=space />" >
        <i class="icon-rss"></i>
        <@trans key="thub.widgets.follow.question.answersAndComments" />
    </a>
    </p>-->
        <p>
            <@trans key="thub.widgets.follow.followerCount" params=[space.followers?size,"space"]/>

        <div class="followers">

            <#list space.followers as follower>
                    <@teamhub.avatar follower 24 true/>
            </#list>
        </div>
        </p>
    </div>
</div>
</#if>

<#if content??>
<div class="widget idea-follow-widget node-follow-widget">
    <div class="widget-header">
        <i class="icon-arrow-right"></i>
        <#if currentUser??>
            <#if teamHubManager.socialManager.isUserFollowing(content, currentUser)??>
                <a href="<@url name="unfollow" objId=content type=content.type />" class="btn btn-danger pull-right widget-action">
                    <i class=" icon-remove-circle"></i>
                    <@trans key="thub.widgets.follow.${content.type}.unfollow" /></a>
            <#else>
                <a href="<@url name="follow" objId=content type=content.type />" class="btn btn-success pull-right widget-action"><i
                        class="icon-ok-sign"></i>
                    <@trans key="thub.widgets.follow.${content.type}.follow" /></a>

            </#if>
        </#if>
        <h3><@trans key="thub.widgets.follow.${content.type}.title" /></h3>
    </div>
    <div class="widget-content">
        <#if !currentUser??>
            <p><@trans key="thub.widgets.follow.onceYouSignIn" /></p>
        </#if>
        <p>
            <@trans key="thub.widgets.follow.followerCount" params=[content.followers?size,content.type]/>

        <div class="followers">

            <#list content.followers as follower>
                    <@teamhub.avatar follower 24 true/>
                </#list>
        </div>
        </p>
    </div>

</div>
</#if>
