<#import "/spring.ftl" as spring />
<#import "/macros/teamhub.ftl" as teamhub />
<div class="tab-pane" id="applicationsPanel">
<p><@trans key="thub.users.preferences.tabs.applications.desc" /></p>
	<#if appSummaryList?size == 0>
            <p class="message"><@trans key="thub.users.preferences.tabs.applications.noApplications"/></p>
        <#else>
            <table class="table table-condensed table-hover">
			  <thead>
			  <tr>
			      <th><@trans key="thub.users.preferences.tabs.applications.table.appName" default="Application Name"/></th>
			      <th><@trans key="thub.users.preferences.tabs.applications.table.apiKey" default="Api Key"/></th>
			      <th><@trans key="thub.users.preferences.tabs.applications.table.apiSecret" default="Api Secret"/></th>
			    </tr>
			  </thead>
			  <tbody>
			  	<#list appSummaryList as appSummary>
			  		<tr>
	    	  		  <td><a href="<@url name="develop:apps:edit" account=profileUser plug=appSummary.plug />"><@teamhub.clean appSummary.name /></a>
			    	  <td>${appSummary.apiKey}</td>	
			    	  <td>${appSummary.secret}</td>
			    	</tr>
				</#list>
			  </tbody>
			</table>
        </#if>   
	<div class="form-actions">
		<input type="button" value="<@trans key="thub.users.preferences.tabs.applications.addNewButton" default="Add Application"/>" class="btn btn-primary" onclick="window.location='<@url name="develop:apps:new" account=profileUser/>'">
	</div>
</div>