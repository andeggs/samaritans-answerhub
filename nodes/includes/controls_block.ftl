<#import "../../macros/security.ftl" as security />

<#assign nodeCommands = cCommands(controlNode) />

<#if nodeCommands.isAvailable("moveToInstance")>
<script type="text/javascript">
    register_command('moveToInstance', {
        execute: function (evt) {
            var parser = this;
            $.getJSON(this.getParsedUrl('remoteCandidates'), function (data) {
                $.extend(data.result, parser.messages);
                parser.dialog(evt, 'move-to-space-dialog', data.result);
            });
        },
        executeRequest: function(data, evt){
            $.ajax({
                type: 'POST',
                url: this.getUrl(),
                data: {targetSpace: data.targetSpace},
                dataType: 'json',
                success: function (data) {
                    commandUtils.showMessage(evt, "<@trans key="replication.success" default="The replicaiton was successful" />");
                }
            });
        }
    });
    commands.moveToInstance.setUrl('click', "<@url name="replication:moveToInstance.json" question="%ID%" />");
    commands.moveToInstance.setUrl('remoteCandidates', "<@url name="replication:moveToCandidates" node="%ID%" />");
</script>
</#if>
<@security.access allowIf='MAKE_STICKY'>
    <script type="text/javascript">
    $(document).ready(function () {
        register_command('makeSticky', {
            onSuccess: function (data) {
                commandUtils.reloadPage();
            }
        });
        commands.makeSticky.setMsg('linkText.on', "Undo sticky");
        commands.makeSticky.setMsg('linkText.off', "Make sticky");

        commands.makeSticky.setUrl('click.off', "<@url name="commands:cMetadata:apply.json" node="%ID%" mdType="sticky" />");
        commands.makeSticky.setUrl('click.on', "<@url name="commands:cMetadata:cancel.json" node="%ID%" mdType="sticky" />");
    });
    </script>
</@security.access>

<@security.access allowIf='MAKE_SITE_STICKY'>
    <script type="text/javascript">
    $(document).ready(function () {
        register_command('makeSiteSticky', {
            onSuccess: function (data) {
                commandUtils.reloadPage();
            }
        });
        commands.makeSiteSticky.setMsg('linkText.on', "Undo site sticky");
        commands.makeSiteSticky.setMsg('linkText.off', "Make site sticky");

        commands.makeSiteSticky.setUrl('click.off', "<@url name="commands:cMetadata:apply.json" node="%ID%" mdType="site_sticky" />");
        commands.makeSiteSticky.setUrl('click.on', "<@url name="commands:cMetadata:cancel.json" node="%ID%" mdType="site_sticky" />");
    });
    </script>
</@security.access>

<div class="post-tools" nodeid="${controlNode.id}">
    <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="icon-cog"></i></a>
    <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
        <#if nodeCommands.isAvailable("edit")>
            <#assign editCommand = nodeCommands.extract("edit") />
            <li class="item"><a rel="nofollow" title="" href="${editCommand.url}"><i class="icon-edit"></i> ${editCommand.label}</a></li>
        </#if>

        <#if rel.canReport() || rel.canCancelReport()>
        <li class="item">
            <a rel="nofollow" class="ajax-command<#if rel.reported()> on</#if> " href="#" command="reportPost">
                <#if !rel.reported()><@trans key=".report.link" /><#else><@trans key=".cancelReport.link" /></#if>
                <#if rel.canViewReports()>(${controlNode.reportCount})</#if>
            </a>
        </li>
        </#if>

		<#if nodeCommands.isAvailable("moveToSpace")>
            <#assign moveCommand = nodeCommands.extract("moveToSpace") />
            <li class="item"><a title="" class="ajax-command ${moveCommand.status}"  command="${moveCommand.webCommand}" href="#">${moveCommand.label}</a></li>
        </#if>

        <#if nodeCommands.isAvailable("deletePost")>
            <#assign deleteCommand = nodeCommands.extract("deletePost") />
            <li class="item"><a title="" class="ajax-command ${deleteCommand.status}"  command="${deleteCommand.webCommand}" href="#">${deleteCommand.label}</a></li>
        </#if>

        <#if nodeCommands.isAvailable("articleToPdf")>
            <#assign toPdfCommand = nodeCommands.extract("articleToPdf") />
            <li class="item"><a title="" class="ajax-command ${toPdfCommand.status}"  command="${toPdfCommand.webCommand}" href="#">${toPdfCommand.label}</a></li>
        </#if>

        <@security.access allowIf='MAKE_STICKY'>
            <li class="item">
                <a class="ajax-command <#if (controlNode.status.custom["sticky"])??> on</#if>" href="#" command="makeSticky"><#if !(controlNode.status.custom["sticky"])??><@trans key="commands.makeSticky" /><#else><@trans key="commands.cancelMakeSticky" /></#if></a>
            </li>
        </@security.access>

        <@security.access allowIf='MAKE_SITE_STICKY'>
            <li class="item">
                <a class="ajax-command <#if (controlNode.status.custom["site_sticky"])??> on</#if>" href="#" command="makeSiteSticky"><#if !(controlNode.status.custom["site_sticky"])??><@trans key="commands.makeSiteSticky" /><#else><@trans key="commands.cancelMakeSiteSticky" /></#if></a>
            </li>
        </@security.access>

    <#assign moreCommands = nodeCommands.remaining />
    <#if moreCommands?size != 0>
        <#list moreCommands as command>
            <li class="item"><a <#if command.ajax>class="ajax-command"</#if> <#if command.status??>data-status="${command.status}"</#if> href="${command.url!"#"}" <#if command.ajax>command="${command.webCommand}"</#if>>
            ${command.label}
            </a></li>
        </#list>
    </#if>
    </ul>
</div>
