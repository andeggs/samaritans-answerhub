<div class="tab-pane" id="authmodesPanel">



<#if authModesForm.hasPasswordSet>
        <p class="message"><@trans key="thub.users.preferences.tabs.authModes.hasPassword"/> <a href="<@url name="users:preferences" user=profileUser plug=profileUser.plug/>?setPassword=true"><@trans key="thub.users.preferences.tabs.authModes.updatePassword" /></a></p>
    <#else>
        <p class="message"><@trans key="thub.users.preferences.tabs.authModes.noPassword"/> <a href="<@url name="users:preferences" user=profileUser plug=profileUser.plug/>?setPassword=true"><@trans key="thub.users.preferences.tabs.authModes.setPassword" /></a></p>
    </#if>
    <div>
        <#if authModesForm.authModes?size == 0>
            <p class="message"><@trans key="thub.users.preferences.tabs.authModes.noAuthModes"/></p>
        <#else>
            <p class="message"><@trans key="thub.users.preferences.tabs.authModes.desc"/></p>
        </#if>

        <#list authModesForm.authModes as authMode>
          <p>${authMode.authService}: ${authMode.authInfo} (<a rel="${authMode.id}" command="deleteAuthMode" href="<@url name="users:prefs:deleteAuthMode.json" user=authMode.user />"><@trans key="label.remove"/></a>)</p>
        </#list>
    </div>

    <input type="button" class="submit btn btn-primary" value="<@trans key="thub.users.preferences.tabs.authModes.addNewProvider"/>" onclick="window.location='<@url name="users:login"/>?providerAdd=true'" />

    </div>

