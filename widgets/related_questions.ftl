<#if relatedQuestions()??>

<#assign related = relatedQuestions() />

<#if related?size != 0>

<div class="widget">
    <div class="widget-header">
        <i class="icon-list-alt"></i>
        <h3><@trans key="question.related" default="Related Questions" /></h3>
    </div>
    <div class="widget-content">
        <#list related as node>
            <#if node?? && node.type == 'question'>
                <p><a href="${node.viewUrl}">${node.title}</a>
                ${node.getAnswerCount()}
                <#if node.getAnswerCount() == 1 >
                <@trans key="label.answer" defaulf="Answer" />
                <#else>
                <@trans key="label.answers" defaulf="Answers" />
                </#if>

                </p>

            </#if>
            <#if (node_index >= 4)><#break/></#if>
        </#list>
        <#--<a class="pull-right">View all</a>-->
    </div>
</div>

</#if>
</#if>
