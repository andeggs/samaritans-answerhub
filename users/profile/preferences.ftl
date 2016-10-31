<#import "/macros/thub.ftl" as teamhub />
<#import "/macros/security.ftl" as security />
<#import "/spring.ftl" as spring />


<html>
<head>
<#if currentUser?? && currentUser.id == profileUser.id>
    <title><@trans key="thub.users.preferences.title" /></title>
<#else>
    <#assign profileUserName><@teamhub.showUserName profileUser/></#assign>
    <title><@trans key="thub.users.preferences.title.other" params=[profileUserName] /></title>
</#if>
<#include "/scripts/cmd_includes/user.commands.ftl"/>
<script type="text/javascript">
	$(document).ready(function(){
	    var $hash = window.location.hash;
	    if ($hash) {
	    	var targetHref = $hash.replace( /<.*?>/g, '').replace("\"", '').replace("\'", '').replace('>', '');
            targetHref = targetHref.replace(/\//g, "");
            if ($('.nav a[href=' + targetHref + ']')) {
                var $target = $('.nav a[href=' + targetHref + ']');
                $target.tab('show');
            }
	    }
	    return false;
	});
</script>
</head>
<body>
<div class="row">
    <div id="user_profile" class="span8">

        <div class="widget ">
            <div class="widget-header">
                <i class="icon-wrench"></i>

                <h3>
                <#if currentUser?? && currentUser.id == profileUser.id>
                    <@trans key="thub.users.preferences.title" />
                <#else>
                    <#assign profileUserName><@teamhub.showUserName profileUser/></#assign>
                    <@trans key="thub.users.preferences.title.other" params=[profileUserName] />
                </#if>
                </h3>

                <a class="btn edit-btn" href="<@url name="users:profile" user=profileUser plug=profileUser.plug/>"><i
                        class="icon-user show"></i> <@trans key="thub.user.view_profile" /></a>
            </div>

            <div class="widget-content">
                <ul class="nav nav-tabs">
                    <#if canEditDetails?? && canEditDetails>
                        <li class="active"><a href="#detailsPanel" data-toggle="tab"><@trans key="thub.userPreferences.details" default="Details"/></a></li>
                    </#if>
                    <li <#if !canEditDetails?? || !canEditDetails>class="active"</#if>><a href="#notificationsPanel" data-toggle="tab"><@trans key="thub.userPreferences.notifications" default="Notifications"/></a></li>
                    <li><a href="#expertisePanel" data-toggle="tab"><@trans key="thub.userPreferences.expertiseSettings" default="Expertise settings"/></a></li>
                <@security.access permission="manageAuthSettings" object=profileUser>
                    <li><a href="#authmodesPanel" data-toggle="tab"><@trans key="thub.userPreferences.authenticationModes" default="Authentication Modes"/></a></li>
                </@security.access>

                <#if canUseEgos?? && canUseEgos>
                    <li><a href="#alteregosPanel" data-toggle="tab"><@trans key="thub.userPreferences.alteregos" default="Alteregos"/></a></li>
                </#if>
                <@security.access allowIf='ROLE_REGISTER_APP'>
                    <li><a href="#applicationsPanel" data-toggle="tab"><@trans key="thub.userPreferences.manageApplications" default="Manage Applications"/></a></li>
                </@security.access>
                </ul>

                <div class="tab-content">
                    <#if canEditDetails?? && canEditDetails>
                	    <#include "../includes/pref_details.ftl" />
                	</#if>
                    <#include "../includes/pref_notifications.ftl"/>
                    <#include "../includes/pref_expertise.ftl"/>
                    <@security.access permission="manageAuthSettings" object=profileUser>
                    	<#include "../includes/pref_authmodes.ftl"/>
                	</@security.access>

			        <#if canUseEgos?? && canUseEgos>
                    	<#include "../includes/pref_alteregos.ftl">
                    </#if>
                
                	<@security.access allowIf='ROLE_REGISTER_APP'>
                    	<#include "../includes/pref_applications.ftl">
                	</@security.access>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

