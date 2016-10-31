<#import "/spring.ftl" as spring />
<@spring.bind 'notifyForm.*' />
<div class="tab-pane <#if !canEditDetails?? || !canEditDetails>active</#if>" id="notificationsPanel">


<p><@trans key="thub.users.preferences.tabs.notifications.desc" /></p>

<#macro radioList name>
    <h4><@trans key=".users.includes.pref_notifications.set.${name}"/>:</h4>
    <#list notifyForm[name] as preference>
        <div class="profileFormField">
            <label for="preference-${preference}"><@trans key=".users.includes.pref_notifications.preference.${preference}"/></label>
            <span class="pref-select-radio">
                <input type="radio" name="preferences[${preference}]" value="null"
                       <#if notifyForm[preference] == "null">checked="checked"</#if>/>  <@trans key=".users.includes.pref_notifications.select.none"/>
                <input type="radio" name="preferences[${preference}]" value="direct-mail"
                       <#if notifyForm[preference] == "direct-mail">checked="checked"</#if>/>  <@trans key=".users.includes.pref_notifications.select.instant"/>
                <input type="radio" name="preferences[${preference}]" value="daily-mail"
                       <#if notifyForm[preference] == "daily-mail">checked="checked"</#if>/>  <@trans key=".users.includes.pref_notifications.select.dailyDigest"/>
                <input type="radio" name="preferences[${preference}]" value="weekly-mail"
                       <#if notifyForm[preference] == "weekly-mail">checked="checked"</#if>/>  <@trans key=".users.includes.pref_notifications.select.weeklyDigest"/>
            </span>
        </div>
    </#list>
</#macro>

<#macro radioSet name>
    <h4><@trans key=".users.includes.pref_notifications.set.${name}"/>:</h4>
    <#list notifyForm[name] as preference>
        <div class="profileFormField">
            <label for="preference-${preference}"><@trans key=".users.includes.pref_notifications.preference.${preference}"/></label>
            <span class="pref-select-radio">
                <input type="radio" name="preferences[${preference}]" value="direct-mail"
                   <#if notifyForm[preference] != "null">checked="checked"</#if>/>  <@trans key=".users.includes.pref_notifications.radio.on"/>
                <input type="radio" name="preferences[${preference}]" value="null"
                   <#if notifyForm[preference] == "null">checked="checked"</#if>/>  <@trans key=".users.includes.pref_notifications.radio.off"/>
            </span>
        </div>
    </#list>
</#macro>

<form action="" method="POST">
    <input type="hidden" name="tab" value="notify" />
    <#if notifyForm.disableAllNotifications>
        <input type="hidden" name="disableAllNotifications" value="true" />
    </#if>

    <div class="profileFormSection">
        <div class="profileFormCover" <#if notifyForm.disableAllNotifications>style="display:block;"<#else>style="display:none;"></#if>">
        </div>
        <div class="profileFormFields">
            <@radioList 'instant' />
            <br/>
            <@radioList 'follow' />
            <br/>
            <@radioSet 'auto' />
            <br/>
            <@radioSet 'additional' />
        </div>
    </div>

    <br />
    <br />


    <#if !notifyForm.disableAllNotifications>
        <button class="btn btn-primary" name="updateSettings"><@trans key="thub.users.preferences.submit" /></button>
        <input type="submit" class="btn btn-danger" name="disableAllNotifications" value="<@trans key="thub.users.preferences.tabs.notifications.disableAllNotifications" />"/>
    <#else>
        <input type="submit" class="btn btn-info" name="enableAllNotifications" value="<@trans key="thub.users.preferences.tabs.notifications.enableAllNotifications" />"/>
    </#if>
</form>


</div>