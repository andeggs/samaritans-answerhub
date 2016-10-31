<script type="text/javascript">
    pageContext.url.mockProfileUrl = '<@url name="users:profile" user="{id}" plug="{plug}" safe=true />';
    pageContext.url.getMessagesUrl = '<@url name="inbox:messages.json" />';
    pageContext.url.getMessageUrl = '<@url name="inbox:message.json" />';
    pageContext.url.sendMessageUrl = '<@url name="inbox:send.json" />';
    pageContext.url.readMessageUrl = '<@url name="inbox:read.json" />';
    pageContext.url.deleteMessageUrl = '<@url name="inbox:delete.json" />';
    pageContext.url.undeleteMessageUrl = '<@url name="inbox:undelete.json" />';
    pageContext.url.searchToUrl = '<@url name="users:list.json" />';

    pageContext.i18n.toRequired = '<@trans key="thub.users.inbox.compose.to.required" />';
    pageContext.i18n.titleRequired = "<@trans key="thub.users.inbox.compose.title.required" />";
    pageContext.i18n.titleMinlength = "<@trans key="thub.users.inbox.compose.title.required" />";
    pageContext.i18n.sending = "<@trans key="thub.users.inbox.compose.sending" />";
    pageContext.i18n.done = "<@trans key="thub.users.inbox.compose.done" />";
    pageContext.i18n.messageDelete = "<@trans key="thub.users.inbox.delete" />";
    pageContext.i18n.messageUndelete = "<@trans key="thub.users.inbox.undelete" />";
    pageContext.i18n.messageDeleteConfirm = "<@trans key="thub.users.inbox.delete.confirm" />";
    pageContext.i18n.messageUndeleteConfirm = "<@trans key="thub.users.inbox.undelete.confirm" />";
</script>