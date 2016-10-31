<#if question?? ><#assign node = question /></#if>
<script type="text/x-jquery-tmpl" id="switch-privacy-dialog">
    <#if node.visibility == "mod">
        <@trans key="thub.question.modal.makePublic" />
    <#else>
        <@trans key="thub.question.modal.makePrivate" />
    </#if>
</script>