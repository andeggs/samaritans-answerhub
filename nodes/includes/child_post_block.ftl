<#import "/macros/security.ftl" as security />
<#if replyForm?? && (security.hasPermission("reply", content) || (replyForm.edit && security.hasPermission("edit", replyForm.node)))>
<#assign childType = content.defaultChildType />
<#if !childType.attachmentsEnabled>
<script>
    $(function(){removePluginFromConfig("upload", "${childType.typeName}")});
</script>
</#if>

<div class="widget reply-form-widget">
    <div class="widget-header">
        <i class="icon-pencil"></i>
        <h3><#if replyForm.edit><@trans key=".${content.typeName}.label.editReply" /><#else><@trans key=".${content.typeName}.label.reply" /></#if></h3>
    </div>
    <div class="widget-content">

        <div class="row-fluid">
            <div class="span1 hidden-phone">
            <#if reply_alterego??>
                <@teamhub.avatar reply_alterego 44 />
                <br/>
                <div class="reply_alterego_avatar"><@teamhub.avatar currentUser 22 /></div>
            <#elseif currentUser??><@teamhub.avatar currentUser 44 /><#else><img src="<@url path="/images/avi.jpg" />" /></#if>

            </div>
        <@spring.bind 'replyForm.*' />

            <div class="span11">
                <form id="reply-form" data-draftType="an answer" <#if !replyForm.edit>data-draftKey="post-${content.defaultChildType.typeName}"</#if> action="${content.replyUrl}" method="POST">

                <#if replyForm.edit>
                    <p class="revision_select_container"><b><@trans key="node.label.revisions" default="Revisions"/></b> <select name="revisionId" id="revision_select">
                        <#list replyForm.revisions as revision>
                            <option <#if revision.id == replyForm.revisionId>selected</#if> value="${revision.id}">${revision.revision}<#if revision.author??> - <@teamhub.showUserName revision.author/></#if> (${revision.revisionDate})</option>
                        </#list>
                    </select></p>
                    <script type="text/javascript">
                        $().ready(function(){
                            $("#revision_select").change(function(event) {
                                $.post(pageContext.url.getRevision + "?revision=" + $(this).val() + "", function(data) {

                                    if ($("#body").redactor) {
                                        if (data.body == null) {
                                            $(".redactor").redactor("set", "");
                                        } else {
                                            $(".redactor").redactor("set", data.body);
                                        }
                                    } else {
                                        if (data.body != null) {
                                            $("#body").val(data.body);
                                        }
                                    }

                                    $("#wiki").attr("checked", (data.wiki ? true : false));

                                    $(".revision-loaded").html("Revision " + data.revision + " has been loaded into the form below.").show();
                                });
                            });
                        });
                    </script>
                    <div class="revision-loaded"></div>
                </#if>
                    <input type="hidden" name="parent" value="${content.id}" />
                    <input type="hidden" name="replyType" value="${childType.typeName}" />
                    <fieldset>
                        <div class="control-group">
                            <div class="controls">
                            <@spring.bind 'replyForm.body'/>
                                <textarea id="${spring.status.expression}" name="${spring.status.expression}"
                                          class="redactor"
                                          data-type="childType.typeName"
                                          rows="2"
                                          placeholder="<@trans key="thub.questions.includes.idea.answerPlaceholder" default="Enter your reply here..."/>"><#if replyForm.node??>${(replyForm.node.asHTML())?html}<#else>${(spring.stringStatusValue!"")?html}</#if></textarea>
                            <@spring.showErrors '', 'fieldError' />
                            </div>
                        </div>
                    </fieldset>

                    <#assign nodeToAttachType = childType />
                    <#assign form = replyForm />
                    <#include 'attachments_form.ftl' />
                    <#include "../../questions/attachments_to_form.ftl" />

                <#if replyForm.edit>
                    <input type="submit" class="submit btn btn-primary pull-right" value="<@trans key="label.save" />"  />
                    <input type="button" class="submit btn cancel pull-right" onclick="window.location='<@url obj=replyForm.node/>'; return false;" value="<@trans key="label.cancel" />" />
                <#else>
                    <input type="submit" class="btn btn-primary" value="<@trans key="label.submit" />" />
                </#if>
                </form>
            </div>
        </div>

    </div>

</div>
</#if>