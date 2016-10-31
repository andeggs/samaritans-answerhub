<script>
	var url = "<@url name="develop:apps:delete" account=account plug=plug />"
		function deleteApp(){
		$.post( url, function( data ) {
		  window.location.replace("<@url name="develop:apps:list" account=account/>");
		});
	}
</script>
<form name="appRegister" action="<#if edit??><@url name="develop:apps:edit" plug=plug account=account /><#else><@url name="develop:apps:save" account=account/></#if>" method="post">
	<input type="hidden" name="account" value="${form.account.id}"/>
	
	<@spring.bind "form.name"/>
    <div class="control-group<#if spring.status.isError()> error</#if>">
        <div class="controls">
            <label for="type">Name:</label>
            <input type="text"
                   id="${spring.status.expression}"
                   name="${spring.status.expression}"
                   value="${(spring.stringStatusValue!"")?html}"
                   autocomplete="off"/>
        <@spring.showErrors '<span>' 'help-inline' />
        </div>
    </div>
    
    <#-- Other fields are optional, so no need for fancy stuff -->
    
	<p>
		<label for="type">Application Type:</label>
		<@spring.formSingleSelect 'form.type', ['Confluence','Generic Application'], attributes/>
	</p>
	<p>
		<label for="description">Description: </label>
		<@spring.formInput 'form.description' />
	</p>
	<p>
	    <label for="organization">Organization: </label>
		<@spring.formInput 'form.organization' />
	</p>
	<p>
	    <label for="website">Website: </label>
		<@spring.formInput 'form.website' />
	</p>
	<p>
	    <label for="callbackUrl">Callback URL</label>
		<@spring.formInput 'form.callbackUrl' />
	</p>
	<div class="form-actions">
		<input type="submit" class="btn btn-primary pull-left" name="bnewaccount" id="bnewaccount" value="<#if edit??>Save<#else>Create</#if>"/>
		<#if edit??>
			<a class="btn pull-left" href="<@url name="develop:apps:list" account=account/>">Cancel</a>
			<a class="btn btn-danger pull-left"onclick="deleteApp()">Delete</a>
		</#if>
	</div>	
</form>
