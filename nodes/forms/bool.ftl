<@spring.bind name />
<div class="control-group<#if spring.status.isError()> error</#if>">
    <div class="controls">
        <label><@trans key=".${contentType}.${name}.label" /></label>
        <@spring.formCheckbox name/>
    	<@spring.showErrors '<span>' 'help-inline' />
    </div>
</div>

