<#import "/macros/thub.ftl" as teamhub />

<#if nodeToAttachType?? && nodeToAttachType.attachmentsEnabled >

<script type="text/javascript">
    var attachmentsEnabled = true;
    pageContext.url.authorizeAttachmentsUrl = "<@url name="authorizeAttachment.json" />";
    pageContext.authorizeUploadContext = {
        type: '${nodeToAttachType.typeName}'
    };
</script>

<div id="main-attachments-container" class="message">
    <#--<p>
        <strong><label><@trans key="node.label.attachments" />:</label></strong>
        <@trans key="node.attachments.editorHelp" params=[
        nodeToAttachType.attachmentsMax,
        nodeToAttachType.attachmentsMaxSizeBytes,
        nodeToAttachType.attachmentsMaxSizeBytesTotal
        ] />
    </p>
-->
        <p>
            <strong><label><@trans key="node.label.attachments" />:</label></strong>
            <@trans key="node.attachments.editorHelp" params=[
            nodeToAttachType.attachmentsMax,
            teamHubManager.humanReadableByteCount(nodeToAttachType.attachmentsMaxSizeBytes),
            teamHubManager.humanReadableByteCount(nodeToAttachType.attachmentsMaxSizeBytesTotal)
            ] />
        </p>
    <div id="img-attachments-container"></div>
    <div id="attachments-container"></div>
</div>

<#else>

<script>
    var attachmentsEnabled = false;
</script>

</#if>
