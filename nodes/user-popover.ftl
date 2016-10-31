<script type="text/x-jquery-tmpl" id="user-popover">
<#noparse>
    <div class="user-popover ahub-popover">
        <div class="ahub-popover-content">
            <div class="header">
                <div class="popover-gravatar">
                    <a href="${profileUser.profileUrl}">
                        <img id="" class="gravatar " height="84" width="84" title="${profileUser.displayName}" alt="avatar image"  src="${pageContext.url.userAvatar.replace("%7BuserId%7D",profileUser.id)}?s=84">
                    </a>
                </div>
                <p class="nameAndTagline">
                    <a href="${profileUser.profileUrl}" class="username">${profileUser.displayName}</a><br>
                    {{if profileUser.tagline}}<span class="tagline">${profileUser.tagline}</span>{{else}}{{if profileUser.location}}<span class="location">${profileUser.location}</span>{{/if}}{{/if}}
                </p>
                {{if currentUser.id != profileUser.id}}<a class="btn btn-follow {{if currentUserFollowing}}on btn-info{{/if}}" command="follow" data-node-type="user" nodeId="${profileUser.id}"></a>{{/if}}
            </div>
            <div class="body">
                <div class="stats-wrapper">
                    <ul class="stats unstyled">
                        <li><a href="${profileUser.profileUrl}"><span class="count">${profileUser.reputation}</span><br>${i18n.reputation}</a></li>
                        <li><a href="${profileUser.profileUrl}"><span class="count">${profileUser.postCount}</span><br>${i18n.posts}</a></li>
                        <li><a href="${profileUser.profileUrl}"><span class="count">${profileUser.userFollowCount}</span><br>${i18n.following}</a></li>
                        <li><a href="${profileUser.profileUrl}"><span class="count">${profileUser.followerCount}</span><br>${i18n.followers}</a></li>
                        <li><a href="${profileUser.profileUrl}"><span class="count">${profileUser.creationDateObj.getMonth() + 1 + "/" + profileUser.creationDateObj.getFullYear().toString().substring(2,4)}</span><br>${i18n.joined}</a></li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </div>
</#noparse>
</script>