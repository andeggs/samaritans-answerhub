<#import "/spring.ftl" as spring />

<html>
<head>
    <content tag="fullWidth"></content>
    <title><@trans key="thub.users.templogin.title" /></title>
    <#include "/users/templogin_username.ftl"/>
    <script type="text/javascript" src="<@spring.url "/themes/base/scripts/temp-login-script.js"/>"></script>
</head>
<body>
    <div class="row">
        <div class="span6 offset3 temp-login-wrap">
            <@spring.bind 'form.*' />
            <h3><@trans key="thub.users.templogin.title" /></h3>
            <#if spring.status.error>
            <div class="alert alert-error"><@trans key="form.errors"/></div>
            </#if>
            <p><@trans key="thub.users.templogin.desc" /></p>
            <form accept-charset="utf-8" method="post" action="" id="temp_form">
                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="well">
                        <label class="control-label" for="id_email"><@trans key="thub.users.templogin.email" /></label>
                        <div class="controls">
                            <div class="input-append">
                                <input type="text" id="id_email" name="email" placeholder="<@trans key="thub.placeholder.email" />" value="${(form.email!"")?html}">
                                <input type="submit" value="<@trans key="thub.users.templogin.submit" />" class="submit btn btn-primary">
                            </div>
                            <@spring.showErrors '<span>' 'help-inline' />
                            <input type="hidden" name="username" value=""/>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
