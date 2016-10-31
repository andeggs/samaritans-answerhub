<#import "/macros/thub.ftl" as teamhub />
<div class="node-attachments">
<#list attachments as attachment>
    <div class="node-attachment">
        <span class="<#if attachment.image>img-</#if>attachment-icon"></span>
        <a href="<@url obj=attachment />">${attachment.name}</a>
        <span>(<@teamhub.humanReadableBytes attachment.size />)</span>
    </div>
</#list>
</div>