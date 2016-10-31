<#import "/macros/thub.ftl" as teamhub />

<#if teamhub.getSetting("attachments.${nodeToAttachType}.enable")!false >

<script type="text/javascript">
    var attachmentsEnabled = true;
    pageContext.url.authorizeAttachmentsUrl = "<@url name="authorizeAttachment.json" />";
    pageContext.authorizeUploadContext = {
        type: '${nodeToAttachType}'
    };
</script>

<div id="main-attachments-container" class="message">
    <p>
        <strong><label><@trans key="node.label.attachments" />:</label></strong>
        <@trans key="node.attachments.editorHelp" params=[
        teamhub.getSetting("attachments.${nodeToAttachType}.max"),
        teamHubManager.humanReadableByteCount(teamhub.getSetting("attachments.${nodeToAttachType}.maxSizeBytes")),
        teamHubManager.humanReadableByteCount(teamhub.getSetting("attachments.${nodeToAttachType}.maxSizeBytesTotal"))
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