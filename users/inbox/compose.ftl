<script type="text/javascript">
    var attachmentsEnabled = false;
</script>
<form id="compose-form" class="main-form inbox-page">
    <h2><@trans key="thub.users.inbox.compose" /></h2>
    <div id="compose-in-reply-to" style="display: none;">
        <@trans key="thub.users.inbox.compose.inReply" params=['<span id="compose-reply-title"></span>'] />
        (<a href="#" id="compose-reply-quote"><@trans key="thub.users.inbox.compose.quote" /></a>)
    </div>
    <p>&nbsp;</p>
    <table class="form-table">
        <tr>
            <td class="label"><@trans key="thub.users.inbox.compose.to" />:</td>
            <td>
                <div id="to-container" class="tagsinput">
                    <input type="text" id="add-to-input" />
                </div>
                <input type="text" name="fake-to-input" style="display: none;" />
            </td>
        </tr>
        <tr>
            <td class="label"><@trans key="thub.users.inbox.compose.title" />:</td>
            <td>
                <input type="text" name="title" id="title" class="compose-form-el title-input" size="255" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td><div id="wmd-button-bar" class="wmd-panel"></div></td>
        </tr>
        <tr>
            <td class="label"><@trans key="thub.users.inbox.compose.body" />:</td>
            <td>
                <textarea name="body" id="body" class="compose-form-el"></textarea>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><div id="previewer" class="wmd-preview"></div></td>
        </tr>
        <tr>
            <td></td>
            <td id="compose-buttons-container">
                <input type="submit" class="submit" id="send-button" value="<@trans key="thub.users.inbox.compose.send" />" />
                <input type="submit" class="submit" id="cancel-button" value="<@trans key="thub.users.inbox.compose.cancel" />" />
                <input type="submit" class="submit" id="clear-button" value="<@trans key="thub.users.inbox.compose.clear" />" />
            </td>
        </tr>
    </table>
</form>

