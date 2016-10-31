<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub/>

<div id="post-header">
    <div class="container">
        <div class="row">
            <div class="span8">
            <@teamhub.breadcrumbs object=node />
            </div>
            <div class="span4">
                <a class=" ask-btn btn btn-primary pull-right"
                   href="<@url name="questions:ask"/><#if currentSpace??>?space=${currentSpace}</#if>"><@trans key="thub.label.askAQuestion" /></a>
            </div>
        </div>
    </div>
</div>

