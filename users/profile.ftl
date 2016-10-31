<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<#import "/macros/security.ftl" as security />


<head>
    <title>${userUtils.displayName(profileUser)} - user overview</title>
<#include "/scripts/cmd_includes/user.commands.ftl"/>
</head>

<body>

<#assign isSameUser = currentUser?? && currentUser == profileUser />

<#include "profile/blocks/info.ftl">
<#include "profile/blocks/about.ftl" />
<#include "profile/blocks/activity.ftl" />
<#include "profile/blocks/topics_interest.ftl" />
<@security.access allowIf='ROLE_VIEW_AWARDS'>
<#include "profile/blocks/badges.ftl" />
</@security.access>

</body>
