<#import "../macros/security.ftl" as security />

<#macro listSpacesAsDivs base class>
    <#if base.spaces??>
        <#assign spaces = base.spaces />
    <#else>
        <#assign spaces = base.subSpaces />
    </#if>

    <#if class != "sub">
        <#list security.filterSpaces(spaces, "VIEW_QUESTIONS_LIST") as space>
            <#if space.name != 'Help' && space.name != 'Default'>
            <li class="${class + "space " + space.id}">
                <div class="space-list-header">
                    <h2 class="${class + "space " + space.id}"><a href="<@url obj=space />">${space.name}</a></h2>
                </div>
                <@listSpacesAsDivs space "sub" + class />
            </li>
            </#if>
        </#list>
    <#else>
    <div class="${class}spaces">
        <#list security.filterSpaces(spaces, "VIEW_QUESTIONS_LIST") as space>
            <div class="${class}space">
                <a href="<@url obj=space />"><h3>${space.name} <span class="question-count">(${getQuestionCount(space)})</span></h3></a>
                <div class="${class}space-questions">
                    <#list getTopQuestions(space) as question><a href="<@url obj=question />">${question.title}</a></#list>
                </div>
            </div>
        </#list>
        <div class="clearfix"></div>
    </div>
    </#if>
</#macro>

<html>

<body>
<div class="widget widget-nopad">

    <div class="widget-content">
        <ul id="space-list">
            <@listSpacesAsDivs base=currentSite class=""/>
        </ul>
    </div>
</div>
</body>
</html>