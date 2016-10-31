<#import "../macros/security.ftl" as security />
<#import "/macros/thub.ftl" as teamhub />
<#import "/spring.ftl" as spring />
<#import "../nodes/comments.ftl" as commentMacros />

<html>
<@relate node=question; rel>
<head>
        <title><@teamhub.clean question.title/></title>

    <content tag="packJS">
        <src>/scripts/ahub.form.attachments.js</src>
    </content>

    <script type="text/javascript">
        $(function () {
            <#include "../nodes/comments-js-vars.ftl" />
            <#include "../nodes/answers-js-vars.ftl" />
            <#include "includes/question-tools-init.ftl" />

            <@security.isAuthenticated>
                initCommandOverrides();
            </@security.isAuthenticated>
            <#if !attachmentsCommentEnabled>
                removePluginFromConfig("upload", "comment");
            </#if>
            commandUtils.initializeLabels();
        });
    </script>
</head>
<body>
<content tag="postHeaderWidgetsPath">ahub.question.header</content>
<content tag="sidebarOneWidgets">ahub.question.sidebar</content>
<content tag="sidebarTwoWidgets">ahub.question.sidebar</content>
    <#include "includes/question-body.ftl" />
    <#include "includes/question-stats.ftl" />
    <#include "includes/answer-list.ftl" />
</@relate>
<#include "/scripts/cmd_includes/node.commands.ftl" />
<#include "../nodes/comment-skeleton.ftl" />
<#include "../nodes/flag-or-close-dialog.ftl" />
<#include "../nodes/redirect-question-dialog.ftl" />
<#include "../nodes/switch-privacy-dialog.ftl" />
<#include "../nodes/wiki-skeleton.ftl" />
<#include "../nodes/user-list-item-skeleton.ftl" />

</body>
</html>