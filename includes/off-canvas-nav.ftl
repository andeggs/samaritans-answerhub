<a class="dummy-navbar-link hidden"></a>
<div class="off-canvas-nav" id="sidr" style="display:none;">
<ul class="nav nav-list">
<@security.isNotAuthenticated>
    <li class="nav-header">
        <@trans key="label.anonymous" />
    </li>
    <li>
        <a href="<@url name="users:login" />"><@trans key="label.login" /></a>
    </li>
</@security.isNotAuthenticated>
<@security.isAuthenticated>
    <li class="nav-header">
        <@teamhub.avatar currentUser 20 />
        ${userUtils.displayName(currentUser)}</li>
    <li>
        <a href="<@url obj=currentUser />"><@trans key="label.profile" /></a>
    </li>
    <li>
        <a href="<@url name="users:preferences" user=currentUser plug=currentUser.plug />"><@trans key="thub.users.preferences.title" /></a>
    </li>

    <@security.access allowIf='VIEW_IN_REVIEW_NODES'>
        <li><a href="<@url name="moderation:list"/>"><@trans key="thub.label.moderation" default="Moderation"/> <#assign inModerationCount = moderationUtils.inModerationCount() />
            <#assign repliedCount = moderationUtils.repliedCount() />
            <#if repliedCount != 0 || inModerationCount != 0>
                (${inModerationCount} /
            ${repliedCount})
            </#if></a>
        </li>
    </@security.access>

    <@security.access allowIf='ROLE_EDIT_SETTINGS'>
        <li>
            <a href="<@url name="admin:index"/>"><@trans key="label.admin" /></a>
        </li>
    </@security.access>
</@security.isAuthenticated>
    <li class="nav-header"><@trans key="label.create" /></li>
<#assign writableTypes = cTypes.writableTypes />
<#list writableTypes as type>
    <li>
        <a href="${type.postUrl}<#if currentSpace??>?space=${currentSpace}</#if>"><@trans key=".label.${type.simpleName}.post" /></a>
    </li>
</#list>

<#if currentSite??>
    <#assign smartSpaces = listSpaces.smartSpaces />
</#if>

<#if currentSite?? && (teamhub.getSetting("site.navigation.spaces.activateInTheme") || smartSpaces?has_content)>
    <li class="nav-header"><@trans key="thub.label.spaces" /></li>

    <#assign smartSpacesList>
        <#list smartSpaces as smartSpace>
            <li <#if currentSmartSpace?? && currentSmartSpace.id==smartSpace.id>class="active"</#if>>
                <a class="main-nav" href="<@url name="smart-spaces:index" space=smartSpace.id plug=smartSpace.plug />">${smartSpace.name}</a>
            </li>
        </#list>
    </#assign>

    <#assign spacesList>
        <@listSpaces isNav=true excludeDefaults=false childrenOpening='<ul>' childrenClosing='</ul>'; space, has_role, depth>
            <#if space.name != 'Default'>
            <li <#if currentSpace?? && (currentSpace.name=space.name || currentSpace.parent.name == space.name)>class="active"</#if>>
                <a <#if depth=0>class="main-nav"</#if>
                   href="<@url name="spaces:index" space=space plug="index"/>">${space.name}</a>
                <#assign haveSpaces=true/>
            </#if>
        </@listSpaces>
    </#assign>

    <#if smartSpacesList?has_content || spacesList?has_content>
            ${smartSpacesList}
                <#if smartSpacesList?has_content && spacesList?has_content>
                    <li class="divider"></li>
                </#if>
            ${spacesList}
    </#if>
</#if>


        <li class="nav-header"><@trans key="thub.label.explore" /></li>
        <li>
            <a href="<@url name="topics" abs=true />"><@trans key="label.topics" /></a>
        </li>

    <#list cTypes.listableTypes as type>
        <li>
            <a href="${type.listUrl}"><@trans key=".label.${type.simpleName}.list" /></a>
        </li>
    </#list>

        <li>
            <a href="<@url name="users:list" />"><@trans key="thub.label.users" /></a>
        </li>

        <li>
            <a href="<@url name="awards:types" />"><@trans key="thub.badges.title" /></a>
        </li>
    <@security.isAuthenticated>
        <li class="divider"></li>
        <li><a href="<@url name="users:logout" />"><@trans key="label.logout" /></a></li>
    </@security.isAuthenticated>
</ul>
</div>