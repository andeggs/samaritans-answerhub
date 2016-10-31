<div id="message-page" class="main-form inbox-page">
    <h2><span id="view-message-title-label"><@trans key="thub.users.inbox.title" />:</span><span id="view-message-title"></span></h2>

    <div id="message-header">
        <img id="sender-gravatar" src="<@url path="/images/no-image.gif" />" width="64" height="64" />
        <div id="view-message-from" class="message-metadata">
            <span id="view-message-from-label"><@trans key="thub.users.inbox.from" />:</span>
            <span id="sender-username"></span>
        </div>
        <div id="view-message-to" class="message-metadata">
            <span id="view-message-to-label"><@trans key="thub.users.inbox.to" />:</span>
            <span id="message-to-you"><@trans key="thub.users.inbox.to.you" /></span>
        </div>
    </div>
    <div id="message-tools">
        <span id="message-tools-date"></span>
        <a href="#" id="message-tools-reply"><@trans key="thub.users.inbox.reply" /></a>
        <span class="message-tools-separator">|</span>
        <a href="#" id="message-tools-reply-all"><@trans key="thub.users.inbox.replyAll" /></a>
        <span class="message-tools-separator">|</span>
        <#--<a href="#" id="message-tools-reply-forward"><@trans key="osqa.users.inbox.forward" default="forward" /></a>
        <span class="message-tools-separator">|</span>-->
        <a href="#" id="message-tools-reply-delete"></a>
    </div>
    <div id="message-body"></div>

</div>