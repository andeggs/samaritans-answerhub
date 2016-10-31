<#import "/spring.ftl" as spring/>

<script type="text/javascript" src="<@url path="/scripts/xss.min.js" />"></script>

<script type="text/javascript">
    $(document).ready(function(){
        $('#detailsPanel > form').submit(function(){
            $(this).find('input[type=text]').each(function(i,e){
                var val = $(e).val().replace(/(?:&[a-z]+\;|&#[\da-z]+\;)/gi, '');
                var newVal = filterXSS(val, {
                  whiteList:          [],        // empty, means filter out all tags
                  stripIgnoreTag:     true,      // filter out all HTML not in the whilelist
                  stripIgnoreTagBody: ['script'] // the script tag is a special case, we need
                                                 // to filter out its content
                });
                $(e).val(newVal);
            });

            return true;
        });
    });
</script>

<style>
	.form-error{
		color: rgb(185, 74, 72);
		display: inline-block;
		padding-left: 5px;
	}
</style>
<div class="tab-pane active" id="detailsPanel">
<#if RequestParameters["setPassword"]??>
    <div class="setPasswordPrompt"><@trans key="thub.users.edit.setPasswordPrompt" /></div><br>
</#if>
    <form name="" class="form-horizontal" action="?tab=details" method="post">
    <@spring.bind "userForm.username" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="username"><@trans key="thub.users.edit.username" /></label>
            <div class="controls">
            <@spring.formHiddenInput 'userForm.username'/>
                <span class="uneditable-input">${profileUser.username}</span>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.email" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="email"><@trans key="thub.users.edit.email" /></label>
            <div class="controls">
            <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
                    <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.password1" />
        <div class="control-group<#if RequestParameters["setPassword"]??> warning</#if><#if spring.status.isError()> error</#if>">
            <label class="control-label" for="password1"><@trans key="thub.users.edit.Password" /></label>
            <div class="controls">
            <@spring.formPasswordInput 'userForm.password1' 'autocomplete="off"'/>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.password2" />
        <div class="control-group<#if RequestParameters["setPassword"]??> warning</#if><#if spring.status.isError()> error</#if>">
            <label class="control-label" for="password2"><@trans key="thub.users.edit.confirmPassword" /></label>
            <div class="controls">
            <@spring.formPasswordInput 'userForm.password2' 'autocomplete="off"'/>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.realname" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="realname"><@trans key="thub.users.edit.real.name" /></label>
            <div class="controls">
            <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.company" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="company"><@trans key="thub.users.edit.Company" /></label>
            <div class="controls">
            <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.website" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="website"><@trans key="thub.users.edit.Website" /></label>
            <div class="controls">
            <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.location" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="location"><@trans key="thub.users.edit.Location" /></label>
            <div class="controls">
            <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.birthday" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="birthday"><@trans key="thub.users.edit.birth" /></label>
            <div class="controls">
            <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
            <#--<@spring.formInput 'userForm.birthday'/>-->
                <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
    <@spring.bind "userForm.locale" />
        <div class="control-group<#if spring.status.isError()> error</#if>">
        <@spring.bind "userForm.locale" />
            <label class="control-label" for="locale"><@trans key="thub.users.edit.locale" /></label>
            <div class="controls">
                <select name="locale">
                <#--<option value="  ">  </option>-->
                <#list locales as locale>
                    <option value="${locale}"
                            <#if locale == userLocale >selected</#if>>${locale.displayName}</option>
                </#list>
                </select>
            <@spring.showErrors '<span>' 'help-inline' />
            </div>
        </div>
        <br>

    <#--<@spring.formTextarea 'userForm.about', 'style="display:none"'/>-->
        <@spring.bind "userForm.about" />
        <textarea style="display: none;"
                id="${spring.status.expression}"
                name="${spring.status.expression}"
                >${(spring.stringStatusValue!"")?html}</textarea>

	<@userForm.renderExtraFields name="userForm"; definition, field>
		<div class="control-group<#if spring.status.isError()> error</#if>">
            <label class="control-label" for="locale">${definition.label}</label>
            <div class="controls">
                ${field}
            </div>
        </div>
    </@userForm.renderExtraFields>
    
    <div class="form-actions">
        <input id="cancel" type="button" value="<@trans key="label.cancel" />"
               class="btn"
               onclick="window.location='<@url name='users:profile' user=userForm.user plug=userForm.user.plug />'">
        <input type="submit"
               value="<@trans key="thub.users.edit.Update" />"
               class="btn btn-primary">
    </div>
    </form>
</div>