<#import "/macros/thub.ftl" as teamhub />
<#import "/spring.ftl" as spring />

<html>
<head>
    <title><@trans key="thub.users.inbox.index.title" params=[currentUser.username] /></title>
    <content tag="packCSS">
        <src>/scripts/tagsinput/jquery.tagsinput.css</src>
        <src>/scripts/wmd/wmd.css</src>
        <src>/css/messages.css</src>
    </content>
    <content tag="packJS">
        <src>/scripts/jquery-validation/jquery.validate.js</src>
        <src>/scripts/teamhub.messages.js</src>
    </content>
<#include "js-vars.ftl" />
</head>
<body>
<div id="main-bar" class="headNormal">
<@trans key="thub.users.inbox.index.title" params=[currentUser.username] />
</div>
<content tag="tab"><@trans key="thub.label.users" /></content>
<content tag="fullWidth"></content>
<div id="main-body">
    <div id="left">
    <@teamhub.avatar user=currentUser size=128 />

        <h3><@trans key="thub.users.inbox.messages" /></h3>
        <ul class="menu">
            <li><a href="#" rel="address:/inbox" class="inbox-link active"
                   id="inbox-link"><@trans key="thub.users.inbox.index.inbox" /></a></li>
            <li><a href="#" rel="address:/compose" id="compose-link"
                   class="inbox-link"><@trans key="thub.users.inbox.index.compose" /></a></li>
        </ul>
    </div>
    <div id="inbox-message"></div>
<#include "messages.ftl" />
<#include "compose.ftl" />
<#include "message.ftl" />
</div>
</body>

</html>