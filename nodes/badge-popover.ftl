<#noparse>
<script type="text/x-jquery-tmpl" id="badge-popover">
    <div class="badge-popover ahub-popover">
        <div class="ahub-popover-content">
            <div class="header">
                <div class="pull-left">
                    <img class="gravatar award-icon" height="84" width="84" title="${awardType.name}" alt="avatar image" src="${awardType.awardIconSrc}">
                </div>
                <p class="nameAndTagline">
                    <a href="${awardType.awardUrl}" class="name">${awardType.name}</a><br>
                    <span class="tagline">${awardType.description}</span>
                </p>   
            </div>
            <div class="body">
                	<div class="stats-wrapper">
	                	<ul class="stats unstyled">
							<li><a href="${awardType.awardUrl}"><span class="count">${awardPager.totalCount}</span><br>${i18n.awarded}</a></li>
	                		<li>
	                			<ul class="users unstyled">
	                				<li><span class="user-list-title">${i18n.completedBy}:</span></li>
			                		{{each awardPager.list}}
				                		<li>
					                		<a href="${$value.user.profileUrl}" title="${$value.user.username}">
					                			<img class="gravatar " width="32" height="32" src="${$value.user.avatar}?s=32">
					                		</a>
					                	</li>
				                	{{/each}}
				                	<div class="clearfix"></div>
		                		</ul>
	                		</li>
	                		<div class="clearfix"></div>
	                	</ul>
	                </div>
            </div>
        </div>
    </div>
</script>
</#noparse>