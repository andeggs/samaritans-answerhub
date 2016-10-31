<#import "/macros/teamhub.ftl" as teamhub />

<div class="breadcrumbs">
<a href="<@url name="users:preferences" user=account plug=account.plug/>">My Preferences</a><span class="divider"> / </span>
<#if account.id == currentUser.id>
	<a href="<@url name="develop:apps:list" account=account/>">My Applications</a>
<#else>
    <a href="<@url name="develop:apps:list" account=account/>">${account.username}'s Applications</a>
</#if>
<#if app??>
    <span class="divider"> / </span><@teamhub.clean app.name/>
</#if>
</div>