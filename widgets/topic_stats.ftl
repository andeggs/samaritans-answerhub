<div class="widget topic-stats-widget">
    <div class="widget-content">
        <div class="stats">
            <div class="posts">
                <span class="count">${postCount}</span>
                <@trans key="thub.topic.stats.posts.label" params=[postCount] default="Posts"/>
            </div>
            <div class="users">
                <span class="count">${userCount}</span>
                <@trans key="thub.topic.stats.users.label" params=[userCount] default="Users"/>
            </div>
            <div class="followers">
                <span class="count">${followerCount}</span>
                <@trans key="thub.topic.stats.followers.label" params=[followerCount] default="Followers"/>
            </div>
        </div>
    </div>
</div>