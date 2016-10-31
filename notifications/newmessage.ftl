<#import "/macros/email.ftl" as email />

<@email.subject>
<@trans key="thub.notifications.newmessage.title" default="{1} - Private message from {2} on {0}" params=[site.name, safeInput(title), userUtils.displayName(author)] />
</@email.subject>

<@email.html>

    <#assign inboxLink>
        <a style="text-decoration:none; color:#3060a8; font-weight:bold; font-size:14px;margin-top:10px" href="<@url name="inbox:index" abs=true/>"><@trans key="thub.notifications.newmessage.goToInbox" default="Go to your <i>Inbox</i> and reply to this message" /></a>
    </#assign>

    <div style="color:#333333;font-family:Arial, Helvetica, sans-serif;font-size:12px;margin-top:10px;"><blockquote><i>${safeInput(body)}</i></blockquote> </div>

    <p style="text-decoration:none; color:#3060a8; font-weight:bold; font-size:14px;margin-top:10px">
        ${inboxLink}
    </p>


</@email.html>

<@email.text>

     ${safeInput(body)}

    <@trans key="thub.notifications.newmessage.yourInbox" default="Your inbox" />: <@url name="inbox:index" abs=true/>

</@email.text>