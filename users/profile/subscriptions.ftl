<#import "/macros/thub.ftl" as teamhub />
<#import "/macros/security.ftl" as security />
<#import "/spring.ftl" as spring />
<html>
<head>
    <title><@trans key="thub.users.preferences.title" /></title>
<#include "/scripts/cmd_includes/user.commands.ftl"/>
    <script type="text/javascript">
        $(document).ready(function () {
            var $hash = window.location.hash;
            if ($hash) {
                var targetHref = $hash.replace(/\//g, '');
                var $target = $('.nav a[href=' + targetHref + ']');
                $target.tab('show');
            }
            return false;
        });


        function showPage(page){
            window.location = page;
        }
    </script>
</head>
<body>
<div class="row">
    <div id="user_profile" class="span8">

        <div class="widget ">
            <div class="widget-header">
                <i class="icon-wrench"></i>

                <h3>
                <@trans key="thub.users.subscriptions.header" /></h3>
                <a class="btn edit-btn" href="<@url name="users:profile" user=profileUser plug=profileUser.plug/>"><i
                        class="icon-user show"></i> <@trans key="thub.user.view_profile" /></a>
            </div>

            <div class="widget-content">
            <#assign writableTypes = cTypes.writableTypes>
                <ul class="nav nav-tabs">
                    <li class="active"><a href="<@url name="users:subscriptions"  user="${currentUser}"/>" data-target="#topics" data-toggle="tab"><@trans key="label.topics"/></a></li>
                <#list writableTypes as type>
                        <li><a href="#${type.simpleName}"
                               data-toggle="tab"><@trans key=".label.${type.simpleName}.list" /></a></li>
                </#list>
                    <li><a href="#users" data-toggle="tab"><@trans key="thub.label.users"/></a></li>
                    <li><a href="#spaces" data-toggle="tab"><@trans key="thub.label.spaces"/></a></li>
                </ul>
                <div class="tab-content">

                <#if ideasPager??> <!-- Handled in IdeationController.java -->
                    <#--<#include "../includes/interests_ideas.ftl"/>-->
                <#else>
                    <#list writableTypes as type>
                        <#assign contentType=type/>
                        <#include "../includes/interests_nodes.ftl"/>
                    </#list>
                    <#include "../includes/interests_topics.ftl" />
                    <#include "../includes/interests_users.ftl"/>
                    <#include "../includes/interests_spaces.ftl"/>
                </#if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
