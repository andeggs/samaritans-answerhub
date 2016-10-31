<#import "/spring.ftl" as spring />
<@spring.bind 'socialForm.*' />
<style type="text/css">
    .spacedLabel {
        padding-right: 15px;
    }

    div.profileFormField label {
        font-weight: normal;
    }
</style>

<h2><@trans key="thub.users.preferences.tabs.social" /></h2>

<p class="message"><@trans key="thub.users.preferences.tabs.social.desc"/><br/></p>

<form action="?tab=social" method="POST">

<#if social.isEnabled("twitter") >
<h4><@trans key="thub.label.twitter" /></h4>
<#if social.isConnected("twitter") >
    <div class="profileFormField">
    <@spring.formCheckbox 'socialForm.autoTweetMyQuestions' /><@spring.showErrors '<br>', 'fieldError' />
        <label for="autoTweetMyQuestions"><@trans key="thub.users.preferences.tabs.social.autoTweetQuestions"/></label>
    </div>

    <div class="profileFormField">
    <@spring.formCheckbox 'socialForm.autoTweetMyAwards' /><@spring.showErrors '<br>', 'fieldError' />
        <label for="autoTweetMyAwards"><@trans key="thub.users.preferences.tabs.social.autoTweetBadges"/></label>
    </div>
<#else>
    <@trans key="thub.users.preferences.tabs.social.notConnected" params=["twitter", currentSite.name] />
    <a href="<@url name="users:social:login:submit" providerId="twitter" />"><img src="<@url path="/images/twitter_connect_button.gif" theme="ahub" />" /></a>
</#if>
<p>&nbsp;</p>

</#if>

<#if social.isEnabled("facebook") >
<h4><@trans key="thub.label.facebook" /></h4>

<#if social.isConnected("facebook")>
    <#if social.hasPermissions("facebook", "publish_stream", "offline_access")>
        <div class="profileFormField">
        <@spring.formCheckbox 'socialForm.facebookAutoShareQuestions' /><@spring.showErrors '<br>', 'fieldError' />
            <label for="facebookAutoShareQuestions"><@trans key="thub.users.preferences.tabs.social.autoShareQuestions"/></label>
        </div>

        <div class="profileFormField">
        <@spring.formCheckbox 'socialForm.facebookAutoShareMyAwards' /><@spring.showErrors '<br>', 'fieldError' />
            <label for="facebookAutoShareMyAwards"><@trans key="thub.users.preferences.tabs.social.autoShareBadges"/></label>
        </div>
    <#else>
        <@trans key="thub.users.preferences.tabs.social.notEnoughPermissions" params=["facebook", currentSite.name] />
        <a href="<@url name="users:social:login:submit" providerId="facebook" />?scope=publish_stream,offline_access"><img src="<@url path="/images/facebook_connect_button.gif" theme="base" />" /></a>
    </#if>
<#else>
     <@trans key="thub.users.preferences.tabs.social.notConnected" params=["facebook", currentSite.name] />
    <br /><a href="<@url name="users:social:login:submit" providerId="facebook" />?scope=publish_stream,offline_access"><img src="<@url path="/images/facebook_connect_button.gif" theme="base" />" /></a>
</#if>



</#if>
<p>&nbsp;</p>
<button class="submit" name="updateSettings"><@trans key="thub.users.preferences.submit"/></button>

</form>