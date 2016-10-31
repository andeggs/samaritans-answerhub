<#import "/macros/thub.ftl" as teamhub />

<div class="widget topic-experts-widget">
    <div class="widget-header">
        <h3><@trans key="thub.widgets.topicExperts.header" /></h3>
    </div>
    <div class="widget-body-container" style="padding-top: 45px;">
    <#if experts?size == 0>
        <@trans key="thub.widgets.topicExperts.none" />
    <#else>
        <#assign map = expertsMap/>
        <#assign index = 0>
        <#assign subIndex = 0>
        <#list experts as expert>
            <#if index &lt;3>
                    <div class="row" id="topic-experts">
                        <div class="span1" style="width: 32px">
                            <#if index == 0>
                                <@teamhub.avatar user=expert size=32 link=true />
                            <#elseif index &lt;  3 && index &gt; 0>
                                <@teamhub.avatar user=expert size=32 link=true />
                                <#assign subIndex = subIndex +  1>
                            </#if>
                        </div>
                        <#if index == 2 || index &lt; 3>
                            <div class="span3" style="margin-left: 15px;">
                                <strong><@teamhub.objectLink expert userUtils.displayName(expert)/></strong>
                                <#assign id = expert.id/>
                                <div class="progress" style="height:20px">
                                    <div class="bar" style="<#if map[id?string] == "0">color:black; </#if>width: ${map[id?string]}%;">${map[id?string]}<span style="padding-left: 5px; padding-right: 5px;"><@trans key="thub.widgets.topicExperts.points" /></span></div>
                                </div>
                            </div>
                        </#if>
                    </div>
            </#if>

            <#if index == 3 || index &gt; 3>
                <div class="widget-body-container" id="other-experts" align="left" style="position:relative;width:100%; margin-top:-15px;">
                    <#if index == 3>
                        <div class="span" style="display:inline-block; margin-left:0"><label
                                style="width:150px;margin-left:0;font-weight:lighter"><@trans key="thub.widgets.topicOtherExperts.header" />: </label></div>
                    </#if>
                    <#assign subIndex = subIndex +  1>
                    <#if subIndex == 3 || subIndex &gt; 3>
                        <div class="span1"
                             style="margin-left: 2px; margin-right: -45px"><@teamhub.avatar user=expert size=24 link=true /></div>
                    </#if>
                </div>
            </#if>
            <#assign index = index + 1>
        </#list>
    </#if>

    </div>
</div>