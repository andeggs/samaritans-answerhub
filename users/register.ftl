<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />

<head>
    <content tag="fullWidth"></content>
    <title><@trans key="thub.users.register.title" /></title>
</head>

<body>

<div class="widget register">
    <div class="widget-content">
        <h2><@trans key="thub.users.register.createYourAccount" /></h2>

    <@spring.bind 'registerForm.*' />
    <#if ALT_USER_INFO??>
    <#--<p>Creating a login via '${ALT_USER_SERVICE}' with ${ALT_USER_INFO}</p>-->
        <div class="alert alert-info">
            <strong><@trans key="thub.users.register.create.via" default="Creating a login via ''{0}'' with ''{1}''" params=[ALT_USER_SERVICE, ALT_USER_INFO] /></strong>

            <p></p>

            <p>
                <@trans key="thub.users.register.noPasswordRequired" default="When using an external service such as OpenID or Twitter to login, a password is not required."/>
            </p>
        </div>
    </#if>

        <div id="flashMessages">
        <#if spring.status.error>
            <div class="alert alert-error"><@trans key="form.errors"/></div>
        </#if>
        </div>

        <form name="fregister" action="<@url name="users:register" />" method="POST">
        <#if ALT_USER_INFO??>
            <input type="hidden" name="authService" value="${ALT_USER_SERVICE}"/>
            <input type="hidden" name="authInfo" value="${ALT_USER_INFO}"/>
        </#if>
        <@spring.bind "registerForm.username" />
            <div class="control-group<#if spring.status.isError()> error</#if>" id="regpix">
                <label class="control-label" for="username"><@trans key="thub.users.register.Username" /></label>

                <div class="controls">
                <#--<@spring.formInput 'registerForm.username' 'autocomplete="off"' />-->
                <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}" autocomplete="off"/>
                <@spring.showErrors '<span>' 'help-inline' />
                </div>
            </div>
        <@spring.bind "registerForm.email" />
            <div class="control-group<#if spring.status.isError()> error</#if>">
                <label class="control-label" for="email"><@trans key="thub.users.register.Email" /></label>

                <div class="controls">
                <#--<@spring.formInput 'registerForm.email' 'autocomplete="off"'/>-->
                    <input type="text" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}" autocomplete="off"/>

                <@spring.showErrors '<span>' 'help-inline' />
                </div>
            </div>

        <#-- If we're using an external service, we don't need these -->
        <@spring.bind "registerForm.password1" />
            <div class="control-group<#if spring.status.isError()> error</#if>">
                <label class="control-label" for="password"><@trans key="user.password"/></label>

                <div class="controls">
                <@spring.formPasswordInput 'registerForm.password1' 'autocomplete="off"' />
                        <@spring.showErrors '<span>' 'help-inline' />
                </div>
            </div>
        <@spring.bind "registerForm.password2" />
            <div class="control-group<#if spring.status.isError()> error</#if>">
                <label class="control-label" for="password2"><@trans key="user.passwordConfirm"/></label>

                <div class="controls">
                <@spring.formPasswordInput 'registerForm.password2' 'autocomplete="off"'/>
                        <@spring.showErrors '<span>' 'help-inline' />
                </div>
            </div>
        <@teamhub.widgets "user.register.beforeSubmit" />
            <div class="control-group">
                <input type="submit" class="btn btn-primary btn-large" name="bnewaccount" id="bnewaccount"
                       value="<@trans key="label.register" />"/>
            </div>
        </form>
    </div>
    <div class="login-extra">
    <@trans key="thub.users.register.alreadyHaveAccount" /> <a
            href="<@url name="users:login" />"><@trans key="label.login" /></a>
    </div>
</div>
</body>
