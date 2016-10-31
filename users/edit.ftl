<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />

<head>
    <title><#if currentUser == profileUser><@trans key="thub.users.edit.myProfile" /><#else><@trans key="thub.users.edit.usersProfile" params=[userUtils.displayName(profileUser)]/></#if></title>
</head>

<body>
<#include "includes/pref_details.ftl"/>
</body>