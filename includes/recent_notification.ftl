<#if notification??>
<#--<div class="widget">
    <div class="widget-content">
 -->       <div class="alert alert-block recent-notification">
    <#if notification.headline??><h4><i class="icon-microphone"></i> <#if notification.link?? && notification.link?has_content><a
            href="${notification.link}"></#if>${notification.headline}<#if notification.link?? && notification.link?has_content></a></#if>
        <#if notification.startDate??><small><strong>${notification.startDate?string("MM/dd")}</strong></small></#if></h4></#if>
    <p>${(notification.asHTML())}</p>
</div>
<#--   </div>
</div>-->
</#if>