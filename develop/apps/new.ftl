<#import "/spring.ftl" as spring />
<html>
<head>
    <#if edit??>
        <title>Editing: "${app.name}"</title>
    <#else>
        <title>Add a new application</title>
    </#if>
</head>
<body>
	<div class="widget">
		<div class="widget-header">
	        <#include "app_breadcrumbs.ftl"/>
	        <#if edit??>
	        <h3>Editing Application ( ${app.name} )</h3>
			<#else>
			<h3>Create a new application</h3>
			</#if>
    	</div>
		<div class="widget-content">
			<@spring.bind 'form.*' />
			<div id="flashMessages">
				<#if spring.status.error>
				    <div class="flashMessage alert alert-error"><@trans key="form.errors"/></div>
				</#if>
			</div>
			<div class="row-fluid">
				<div class="app-form-wrapper span8">
					<#include "app_form.ftl" />
				</div>
				<div class="app-form-help span4">
					<div class="row-fluid">
			        	<div class="span12">
			          		<div class="alert alert-info">
			          			<@trans key="applications.info.general" default="Creating credentials for external applications provides means for app developers to get access to users data."/>
							</div>
						</div>
			        </div>
			        <div class="row-fluid">
			          <div class="span12">
			          		<div class="alert alert-info">
								<@trans key="applications.info.type" default="Please provide information about the application type so we can do a better job at integrating those.
			          			If the application you want to integrate with is not in the list just pick Generic Application."/>			          			
							</div>
						</div>
			        </div>
			        <div class="row-fluid">
			          <div class="span12">
			          		<div class="alert alert-info">
			          		<@trans key="applications.info.callback" default="Please Provide a callback url in order to redirect users back to your domain after they've granted access to their teamhub information."/>
							</div>
						</div>
			        </div>
				</div>
			</div>
		<div>
	<div>
</body>
</html>