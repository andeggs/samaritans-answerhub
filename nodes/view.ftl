<#import "../macros/security.ftl" as security />
<#import "/macros/thub.ftl" as teamhub />
<#import "/spring.ftl" as spring />
<#import "comments.ftl" as commentMacros />

<@relate node=content; rel>
<#assign contentType = content.originalParent.type />

<html>
<head>
    <title><@teamhub.clean content.title/></title>
    <@content.include path="/nodes/includes/head_block.ftl" />
</head>
<body class="${contentType}-view-page">

<content tag="tab">${contentType}-tab</content>

    <@content.include path="/nodes/includes/sidebar_block.ftl" />
    <@content.include path="/nodes/includes/title_block.ftl" />
    <@content.include path="/nodes/includes/view_block.ftl" />

    <@content.listChildCTypes; childType>
        <#if childType.hasViewRole>

            <@content.include path="/nodes/includes/children_list_block.ftl" />

            <@security.access permission="reply" object=content>
                <@content.include path="/nodes/includes/child_post_block.ftl" />
            </@security.access>

        </#if>
    </@content.listChildCTypes>

<#include "../nodes/switch-privacy-dialog.ftl" />

</body>
</@relate>

