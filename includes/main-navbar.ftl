<#import "/macros/thub.ftl" as teamhub />

<div id="main-navbar" class="navbar navbar-fixed-top">
    <div class="navbar-inner brand-nav">
        <div class="container brand-container">
            <a class="brand" href="<@url name="index" />">
                <img src="<@url path="/images/teamhub-logo.png"/>?<@teamhub.setting key="site.lastUpdated"/>"/>
            </a>
        </div>
    </div>
<@security.access allowIf='ROLE_USE_SITE'>
    <div class="navbar-inner">
        <div class="container">
            <div class="row-fluid">
                <div class="search-wrapper span${Request["mainContentWidth"]}">
                    <a type="button" class="btn btn-navbar off-canvas-nav-btn" href="#sidr">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    </a>
                    <form action="<@url name="search"/>" method="get" class="navbar-search">
                        <input type="hidden" id="search-filters" name="f" value="<#if search_filters??>${search_filters?html}</#if>"/>
                        <input type="hidden" id="search-types" name="type"
                               value="<#if search_type??>${search_type}<#else><#list cTypes.listableTypes as type>${type.simpleName}<#if type_has_next> OR </#if></#list></#if>" />
                        <input type="hidden" id="search-redirect" name="redirect"
                               value="<#if redirect??><@teamhub.clean redirect/><#else>search/search</#if>"/>
                        <input type="hidden" id="search-sort" name="sort"
                               value="<#if search_sort??><@teamhub.clean search_sort /><#else>relevance</#if>"/>
                    <#-- For reference, the output of query below has been sanitized in the actual controller -->
                        <input type="text"
                               class="search-query"
                               value="<#if query??>${query}</#if>"
                               name="q"
                               id="search-query"
                               data-provide="typeahead"
                               data-items="4"
                               autocomplete="off"
                               placeholder="<@trans key="thub.search.placeholder" />"
                                />
                        <a href="#" class="search-button no-style-link"><i class="icon-search"></i></a>

                        <script type="text/javascript">
                            $(document).ready(function () {
//                                var ie7 = $.browser.msie && $.browser.version <= 7;

                                var label = $('.navbar-search label[for=search_box]');
                                label.css({
                                    position: 'absolute',
                                    top: 4,
                                    left: 17,
                                    zindex: 10
                                });
                                $('#search_box')
                                        .focus(function () {
                                            label.hide()
                                        })
                                        .blur(function () {
                                            this.value == "" ? label.show() : label.hide()
                                        })
                            });
                        </script>
                        <div id="searchResultsAutoComplete"></div>
                    </form>
                </div>

                <ul class="nav-links span${12 - Request["mainContentWidth"]}">
                    <li>
                        <#assign writableTypes = cTypes.writableTypes />

                        <#assign visibleTypes = 0 />
                        <#assign contentTypesList>
                            <#list writableTypes as type>
                                <#if type.hasStartPostingRole>
                                    <#assign visibleTypes = visibleTypes + 1 />
                                    <li>
                                        <a href="${type.postUrl}<#if currentSpace??>?space=${currentSpace}</#if>"><@trans key=".label.${type.simpleName}.post" /></a>
                                    </li>
                                </#if>
                            </#list>
                        </#assign>

                        <#list writableTypes as type>
                            <#if type.hasStartPostingRole>
                                <#assign firstEntry = type />
                                <#break>
                            </#if>
                        </#list>

                         <#if contentTypesList?has_content>
                            <#if visibleTypes == 1>
                                <#assign type = firstEntry />
                                <div class="btn-group navbar-action">
                                    <a id="create-button" class="btn btn-success"
                                       href="${type.postUrl}<#if currentSpace??>?space=${currentSpace}</#if>"><@trans key=".label.${type.simpleName}.post" /></a>
                                </div>
                            <#elseif visibleTypes != 0>
                                <div class="btn-group navbar-action">
                                    <#assign type = firstEntry />
                                    <a id="create-button" class="btn btn-success"
                                       href="${type.postUrl}<#if currentSpace??>?space=${currentSpace}</#if>"><@trans key=".label.create" /></a>
                                    <button class="btn btn-success dropdown-toggle" data-toggle="dropdown">
                                        <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu pull-right">
                                        ${contentTypesList}
                                    </ul>
                                </div>
                            </#if>
                        </#if>
                    </li>

                    <#if currentSite??>
                        <#assign smartSpaces = listSpaces.smartSpaces />
                    </#if>

                    <#if currentSite?? && (teamhub.getSetting("site.navigation.spaces.activateInTheme") || smartSpaces?has_content)>
                        <#assign smartSpacesList>
                            <#list smartSpaces as smartSpace>
                                <li <#if currentSmartSpace?? && currentSmartSpace.id==smartSpace.id>class="active"</#if>>
                                    <a class="main-nav" href="<@url name="smart-spaces:index" space=smartSpace.id plug=smartSpace.plug />">${smartSpace.name?html}</a>
                                </li>
                            </#list>
                        </#assign>

                        <#assign spacesList>
                            <@listSpaces isNav=true excludeDefaults=false childrenOpening='<ul>' childrenClosing='</ul>'; space, has_role, depth>
                                <#if space.name != 'Default'>
                                <li <#if currentSpace?? && (currentSpace.name=space.name || currentSpace.parent.name == space.name)>class="active"</#if>>
                                    <a <#if depth=0>class="main-nav"</#if>
                                       href="<@url name="spaces:index" space=space plug="index"/>">${space.name?html}</a>
                                    <#assign haveSpaces=true/>
                                </#if>
                            </@listSpaces>
                        </#assign>

                        <#if smartSpacesList?has_content || spacesList?has_content>
                            <li class="dropdown">
                                <a href="#" id="spaces-menu-dropdown" class="dropdown-toggle" data-toggle="dropdown">
                                    <@trans key="thub.label.spaces" />
                                    <i class="icon-caret-down"></i>
                                </a>
                                <ul class="dropdown-menu pull-right">
                                    ${smartSpacesList}
                                    <#if smartSpacesList?has_content && spacesList?has_content>
                                        <li class="divider"></li>
                                    </#if>
                                    ${spacesList}
                                </ul>
                            </li>
                        </#if>
                    </#if>
                    <li class="dropdown">
                        <a href="#" id="explore-menu-dropdown" class="dropdown-toggle" title="<@trans key="thub.label.explore" />"
                           data-toggle="dropdown">
                            <i class="icon-sitemap"></i>
                            <i class="icon-caret-down"></i>
                        </a>
                        <ul class="dropdown-menu pull-right">
                            <li>
                                <a href="<@url name="topics" abs=true />"><@trans key="label.topics" /></a>
                            </li>

                            <#list cTypes.listableTypes as type>
                                <#if type.hasViewListRole>
                                <li>
                                    <a href="${type.listUrl}"><@trans key=".label.${type.simpleName}.list" /></a>
                                </li>
                                </#if>
                            </#list>

                            <@security.access allowIf='ROLE_VIEW_USERS'>
                            <li>
                                <a href="<@url name="users:list" />"><@trans key="thub.label.users" /></a>
                            </li>
                            </@security.access>


                            <@security.access allowIf='ROLE_VIEW_AWARDS'>
                             <li>
                                <a href="<@url name="awards:types" />"><@trans key="thub.badges.title" /></a>
                            </li>
                            </@security.access>
                        </ul>
                    </li>
                    <@security.isAuthenticated>
                        <li class="dropdown">
                            <a href="#" id="profile-menu-dropdown" class="dropdown-toggle user-dropdown" data-toggle="dropdown">
                            <#--<span>${userUtils.displayName(currentUser)}</span>-->
                                <@teamhub.avatar currentUser 20 />
                                <i class="icon-caret-down"></i>
                            </a>

                            <ul class="dropdown-menu pull-right">
                                <li><a href="<@url obj=currentUser />"><@trans key="label.profile" /></a></li>
                                <li><a href="<@url name="users:preferences" user=currentUser plug=currentUser.plug />"><@trans key="thub.users.preferences.title" /></a></li>
                                <#if moderationUtils.canViewModerationConsole()>
                                    <li><a href="<@url name="moderation:list"/>"><@trans key="thub.label.moderation" default="Moderation"/> <#assign inModerationCount = moderationUtils.inModerationCount() />
                                        <#assign repliedCount = moderationUtils.repliedCount() />
                                        <#if repliedCount != 0 || inModerationCount != 0>
                                            (${inModerationCount} /
                                        ${repliedCount})
                                        </#if></a>
                                        </li>
                                </#if>

                                <@security.access allowIf='ROLE_EDIT_SETTINGS'>
                                    <li>
                                        <a href="<@url name="admin:index"/>"><@trans key="label.admin" /></a>
                                    </li>
                                </@security.access>
                                <li class="divider"></li>
                                <li><a href="<@url name="users:logout" />"><@trans key="label.logout" /></a></li>
                            </ul>
                        </li>
                    </@security.isAuthenticated>
                    <@security.isNotAuthenticated>
                        <li>
                            <a href="<@url name="users:login" />"><@trans key="label.login" /></a>
                        </li>
                    </@security.isNotAuthenticated>
                </ul>
            </div>
        </div>
    </div>
</@security.access>
</div>
<#if question?? || space?? || node?? || content?? || smartSpace??>
<div id="main-breadcrumb" class="container">
    <@teamhub.breadcrumbs object=question!node!content!space!smartSpace />
</div>
</#if>
