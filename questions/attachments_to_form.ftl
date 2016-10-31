<#if form.attachments?? && form.attachments?size != 0>
    <script type="text/javascript">
        $(function() {
            <#list form.attachments as attachment>
                addAttachmentToForm({
                    fileName: '${attachment.name}',
                    fileId: ${attachment.id},
                    size: '<@teamhub.humanReadableBytes attachment.size />',
                    url: '<@url obj=attachment />',
                    isImage: ${attachment.image?string}
                });
            </#list>
        });
    </script>
</#if>