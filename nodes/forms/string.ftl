<@spring.bind name />
<div class="control-group<#if spring.status.isError()> error</#if>">
    <div class="controls">
        <label><@trans key=".${contentType}.${name}.label" /></label>
        <#assign placeholder = trans('.${contentType}.${name}.placeholder', '') />
        <#assign params>placeholder="${placeholder}" class="form-title" autocomplete="off" <#if !editable>readonly="readonly"</#if></#assign>
    <@spring.formInput name params />
    <@spring.showErrors '<span>' 'help-inline' />
    </div>
</div>

