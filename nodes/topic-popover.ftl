<script type="text/x-jquery-tmpl" id="topic-popover">
<#noparse>
    <div class="topic-popover ahub-popover">
        <div class="ahub-popover-content">
            <div class="header">
                <div class="popover-icon">
                    <a href="${topic.url}">
                        <img id="" class="gravatar " height="84" width="84" title="${topic.name}" alt="${topic.name} icon" src="${topic.icon}">
                    </a>
                </div>
                <p class="name"><a href="${topic.url}">${topic.name}</a></p>
                <a class="btn btn-follow {{if currentUserFollowing}}on btn-info{{/if}}" command="follow" data-node-type="topic" nodeId="${topic.name}"></a>
            </div>
            <div class="body">
                <div class="stats-wrapper">
                    <ul class="stats unstyled">
                        <li><a href="${topic.url}"><span class="count">${followerCount}</span><br>${i18n.followers}</a></li>
                        <li><a href="${topic.url}"><span class="count">${questionCount}</span><br>${i18n.questions}</a></li>
                        <li><a href="${topic.url}"><span class="count">${answerCount}</span><br>${i18n.answers}</a></li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
                {{if description}}<div class="description">{{html description}}</div>{{/if}}
            </div>
        </div>
    </div>
</#noparse>
</script>