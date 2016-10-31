<#import "/macros/thub.ftl" as teamhub />

<#if relatedPosts??>
<div class="widget">
    <div class="widget-header">
        <h3><@trans key=".related.${contentType}" default="Related posts"/></h3>
    </div>
    <div class="widget-content questions-related">
        <#list relatedPosts() as node>
            <#if node??>
                <p>
                    <a href="${node.viewUrl}">${node.title}</a>
                </p>
            </#if>
        </#list>
    </div>
</div>
</#if>