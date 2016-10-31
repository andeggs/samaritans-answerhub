<#import "/macros/teamhub.ftl" as teamhub />
<#macro spacesPanel>
<div class="tab-pane active" id="users">
    <#if RequestParameters["setPassword"]??>
        <div class="setPasswordPrompt"><@trans key="thub.users.edit.setPasswordPrompt" /></div><br>
    </#if>
    <div class="widget-body-container" style="padding-top: 2px;">
        <ul class="userlist unstyled interestsUsers">
            <#if spacesPager.list?size != 0>
                <#list spacesPager.list as topic>
                    <#assign user=topic>
                    <li class="user">
                        <h4 class="title">${topic.spaceToFollow.name}
                        </h4>
                        <br>
                        <span style="float:right">
                            <#if currentUser??><a
                                    class="btn btn-follow <#if teamHubManager.socialManager.isUserFollowing(topic.spaceToFollow, profileUser)??>on btn-info</#if>"
                                    command="follow" data-node-type="space" nodeId="${topic.spaceToFollow.id}"></a></#if>
                        </span>
                    </li>
                </#list>
            <#else>
                <@trans key="thub.spaces.followed.empty" />
            </#if>
        </ul>
        <@teamhub.paginate spacesPager />
    </div>
</div>
</#macro>

<div class="tab-pane" id="spaces">
<@spacesPanel/>
</div>