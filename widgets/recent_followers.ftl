<#import "/macros/thub.ftl" as teamhub />
<#if followers?size &gt; 0>
<div class="widget">
    <div class="widget-header">
        <h3><@trans key="label.followers" /></h3>
    </div>
    <div class="widget-content">
        <div id="recent-followers">
        <#list followers as follower>
            <#assign avi><@teamhub.avatar follower 48/></#assign>
            <@teamhub.objectLink object=follower content=avi class="user"/>
            <#if follower_index == 21>
            <#break>
        </#if>
        </#list>
        </div>
    </div>
</div>
</#if>