<#import "/macros/teamhub.ftl" as teamhub />
<html>
<head>
    <#if account.id == currentUser.id>
        <title>My TeamHub Apps</title>
    <#else>
        <title>${account.username}'s TeamHub Apps</title>
    </#if>
</head>
<body>
<div class="widget">
		<div class="widget-header">
		   <#include "app_breadcrumbs.ftl"/>
	       <#if account.id == currentUser.id>
				<h3>My TeamHub Apps</h3>
				<#else>
				<h3>${account.username}'s TeamHub Apps</h3>
			</#if>
    	</div>
		<div class="widget-content">
			<#if appSummaryList?size == 0>
			<p class="message"><@trans key="thub.users.preferences.tabs.applications.noApplications"/></p>
			<#else>
			    <table class="table table-condensed table-hover">
				  <thead>
				  <tr>
				      <th>Application Name</th>
				      <th>Api Key</th>
				      <th>Api Secret</th>
				    </tr>
				  </thead>
				  <tbody>
				  	<#list appSummaryList as appSummary>
				  		<tr>	  		
				    	  <td><a href="<@url name="develop:apps:edit" account=account plug=appSummary.plug />"><@teamhub.clean appSummary.name /></a>
				    	  </td>
				    	  <td>${appSummary.apiKey}</td>	
				    	  <td>${appSummary.secret}</td>
				    	</tr>
					</#list>
				  </tbody>
				</table>
			</#if>   
			<div class="form-actions">
				<a value="Create a new application" class="btn btn-primary" href="<@url name="develop:apps:new" account=account/>" >Create a new application</a>
			</div>
		<div>
	<div>
</body>
</html>