<script type="text/javascript" src="<@url path="/scripts/teamhub.user.commands.js" />"></script>
<script type="text/javascript" src="<@url path="/scripts/edit-user-photo.js" />"></script>
<script type="text/javascript">

    commands.awardRepBonus.setUrl('click', "<@url name="users:profile:awardRep.json" user="%ID%" />");
    commands.awardRepBonus.setMsg('points', "<@trans key="user.award.points" />");
    commands.awardRepBonus.setMsg('message', "<@trans key="user.award.message" />");

    commands.awardRepBonus.onSuccess = function(data) {
        window.location.reload();
    };

    commands.resendEmailValidation.setMsg('title', "<@trans key="user.email.validate.prompt.title" />");
    commands.resendEmailValidation.setUrl('click', "<@url name="users:resendEmailValidation.json" user="%ID%" />");

    commands.suspendUser.setUrl('click', "<@url name="users:profile:suspendUser.json" user="%ID%" />");
    commands.suspendUser.setMsg('title.off', "<@trans key="user.suspendUser.title" />");
    commands.suspendUser.setMsg('title.on', "<@trans key="user.suspendUser.title.on" />");
    commands.suspendUser.setMsg('linkText.on', "<@trans key="user.suspendUser.command.withdraw" />");
    commands.suspendUser.setMsg('linkText.off', "<@trans key="user.suspendUser.command" />");
    commands.suspendUser.setMsg('message', "<@trans key="user.suspendUser.message" />");
    commands.suspendUser.setMsg('message.explanation', "<@trans key="user.suspendUser.message.explanation" />");

    // Suspend user override
    commands.suspendUser.onSuccess = function(data) {
        window.location.reload();
    };

    commands.suspendUser.setMsg('suspended', "<@trans key="user.suspended" />");
    commands.suspendUser.setMsg('karma', "<@trans key="user.karma" />");

    commands.deleteAllPosts.setUrl('click', "<@url name="users:profile:deleteAllPosts.json" user="%ID%" />");

    commands.makeModerator.setUrl('click', "<@url name="users:profile:makeModerator.json" user="%ID%" />");
    commands.makeModerator.setMsg('title.off', "<@trans key="user.makeModerator.title" />");
    commands.makeModerator.setMsg('title.on', "<@trans key="user.makeModerator.title.on" />");
    commands.makeModerator.setMsg('linkText.on', "<@trans key="user.makeModerator.command.withdraw" />");
    commands.makeModerator.setMsg('linkText.off', "<@trans key="user.makeModerator.command" />");

    commands.makeSuperUser.setUrl('click', "<@url name="users:profile:makeSuperUser.json" user="%ID%" />");
    commands.makeSuperUser.setMsg('title.off', "<@trans key="user.makeSuperUser.title" />");
    commands.makeSuperUser.setMsg('title.on', "<@trans key="user.makeSuperUser.title.on" />");
    commands.makeSuperUser.setMsg('linkText.on', "<@trans key="user.makeSuperUser.command.withdraw" />");
    commands.makeSuperUser.setMsg('linkText.off', "<@trans key="user.makeSuperUser.command" />");

    commands.editUserPhoto.setUrl('authorizeUrl', '<@url name="authorizeUserPhotoUpload.json" user="%ID%" />');
    commands.editUserPhoto.setUrl('resetUrl', '<@url name="users:photo:reset" user="%ID%" />');
    <#--commands.editUserPhoto.setUrl('form.target', "<@url name="users:uploadPhoto" user="%ID%" />");
    //commands.editUserPhoto.setUrl('form.loadFromWeb', "<@url name="users:loadPhotoFromWeb" user="%ID%" />");-->
    commands.editUserPhoto.setUrl('click', "<@url name="users:photo:submit" user="%ID%" />");
    commands.editUserPhoto.setMsg('gravatar', '<@trans key="user.editUserPhoto.useGravatar" default="use your gravatar.com picture" />');
    commands.editUserPhoto.setMsg('or', "<@trans key="user.editUserPhoto.orUseGravatar" default="Or" />");
    <#if profileUser??>
    commands.editUserPhoto.setUrl('user.photo', "${teamhub.avatarUrl(profileUser)}");
    commands.editUserPhoto.setMsg('gravatarUrl', "https://secure.gravatar.com/avatar/${profileUser.avatarEmailHash}?d=identicon&r=PG");
    </#if>
    commands.editUserPhoto.setUrl('user.uploaded.photo', "<@url name="users:photo" userId="%ID%" />");

    commands.expertTopic.setUrl('click', "<@url name="users:expert:update.json" user="%ID%" />");
    commands.expertTopic.setMsg('linkText.off', "<@trans key="user.expertTopic.add.title" default="add to my skills" />");
    commands.expertTopic.setMsg('linkText.on', "<@trans key="user.expertTopic.remove.title" default="remove from my skills" />");

</script>
<script type="text/x-jquery-tmpl" id="award-bonus-dialog">
<#noparse>
    <form onsubmit='return false;'>
        <b>${points}:</b><br/>
        <input type="text" value="1" name="points"/><br/>
        <b>${message}:</b><br/>
        <textarea rows=5 name="reason"></textarea>
    </form>
</#noparse>
</script>

<script type="text/x-jquery-tmpl" id="suspend-user-dialog">
<#noparse>
    <center><h1>${title}</h1></center>
    <b>${message}:</b><br/>

    <form><textarea rows=5 name="reason"></textarea></form>
    <p>${message.explanation}</p>
</#noparse>
</script>

<script type="text/x-jquery-tmpl" id="edit-user-photo">
<#noparse>
    <h2 class="dialog-header">Edit Photo</h2>

    <div id="editUserPhotoForm">
        <img width="75" height="75" style="position: absolute; left: 0px; top: 0px;" src="${iconUrl}"/>
        <h4>Upload New Photo</h4>

        <form enctype="multipart/form-data" method="POST" target="uploaderFrame"
              action="${formAction}?trackingId=${trackingId}">
            <input type="file" name="userPhoto"/>
        </form>
        <button class="btn btn-green btn-mini" type="submit" value="Upload" id="processUpload">Upload</button>
        <div id="uploadProgressContainer"></div>
        <div id="editUserPhotoFromWeb">
            <div id="editUserPhotoFromWeb1">
                Or you can choose <a href="#">an image from the web</a>.
            </div>
            <div id="editUserPhotoFromWeb2">
                <h4>Use an image from the Web</h4>
                <input type="text" id="imageFromWebBox"/>
                <button class="btn btn-green btn-mini" type="submit" value="Upload" id="processImageFromWeb">Download
                </button>
            </div>
        </div>
    </div>
    <iframe name="uploaderFrame" style="display: none;"></iframe>
</#noparse>
</script>
<script type="text/x-jquery-tmpl" id="edit-user-photo-preview">
<#noparse>
    <h2 class="dialog-header">Preview and resize</h2>

    <div class="editTopicIconPreview">
        <table>
            <tr>
                <td>
                    <div style="margin: 20px; width: 300px; height: 300px; border: 1px solid black;">
                        <img class="previewEditor" width="300" height="300" src="${iconPreviewUrl}"/>
                    </div>
                </td>
                <td>
                    <div style="width:100px;height:100px;overflow:hidden;">
                        <img class="finalPreview" width="100" height="100"
                             style="width: 100px; height: 100px; border: 1px solid black;" src="${iconPreviewUrl}"/>
                    </div>
                </td>
            </tr>
        </table>
        <br/>
        <button class="btn btn-green btn-mini" id="acceptChanges">Accept</button>
        <button class="btn btn-grey btn-mini" id="cancelChanges">Cancel</button>
    </div>
</#noparse>
</script>
