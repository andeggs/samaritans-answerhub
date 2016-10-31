<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<head>
    <title><@teamhub.setting key="site.title"/></title>
<#assign isFullWidth><@teamhub.setting "plugin.lc.fullWidthIndex" /></#assign>
<#if isFullWidth == "true">
    <content tag="fullWidth"></content>
</#if>
</head>
<body>
<#assign indexType><@teamhub.setting "plugin.lc.indexType" /></#assign>
<@includeIfExists path="indices/" + indexType + ".ftl" defaultPath="indices/question_list.ftl" parse=true />

</body>



