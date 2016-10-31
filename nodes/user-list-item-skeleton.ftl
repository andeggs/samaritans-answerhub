<script type="text/x-jquery-tmpl" id="user-with-follow">
<#noparse>
    <li class="userWithFollow">
        <a class="gravatar-link" href="${user.profileUrl}"><img class="gravatar" src="${user.avatarUrl}"></a>
        <div class="info">
            <a href="${user.profileUrl}" class="username">${user.displayName}</a>
        </div>
        {{if user.id != currentUser.id}}
        {{if $.grep(follows, function(follow){ return follow.followed.id == user.id }).length < 1}}
        <a class="followLink btn" command="follow" data-node-type="user" nodeId="${user.id}"></a>
        {{else}}
        <a class="followLink on btn" command="follow" data-node-type="user" nodeId="${user.id}" ></a>
        {{/if}}
        {{/if}}
    </li>
</#noparse>
</script>
