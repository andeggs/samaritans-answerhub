<#if flash??>
    <#list flash?keys as key>
        <div class="alert ${key} ">
            <#--<a data-dismiss="alert" class="close">×</a>-->
        ${flash[key]?string}
        </div>
    </#list>
</#if>