<#import "/macros/security.ftl" as security />
<#if security.hasPermission("startAnswering", question) || (answerForm.edit && security.hasPermission("edit", answerForm.node))>
    <#if answerForm.edit>
    <content tag="packJS">
        <src>/scripts/ahub.form.attachments.js</src>
    </content>
    </#if>
    <#if !attachmentsAnswerEnabled>
    <script type="text/javascript">
        $(function(){removePluginFromConfig("upload", "answer")});
    </script>
    </#if>

<style type="text/css">
    #notifyFollowers{
        margin: 0px;
    }
</style>
<div class="widget answer-form-widget">
    <div class="widget-header">
        <i class="icon-pencil"></i>

        <h3><#if answerForm.edit><@trans key="thub.question.label.editAnswer" /><#else><@trans key="thub.question.label.answerThisQuestion" /></#if></h3>
    </div>
    <div class="widget-content">

        <div class="row-fluid">
            <div class="span1 hidden-phone">
                <#if answer_alterego??>
                    <@teamhub.avatar answer_alterego 44 />
                    <br/>

                    <div class="answer_alterego_avatar"><@teamhub.avatar currentUser 22 /></div>
                <#elseif currentUser??><@teamhub.avatar currentUser 44 /><#else><img
                        src="<@url path="/images/avi.jpg" />"/></#if>

            </div>
            <@spring.bind 'answerForm.*' />

            <div class="span11">
                <form id="answer-form"
                      data-draftType="an answer"
                      <#if !answerForm.edit>data-draftKey="answer-${question.id}"</#if>
                      action="<#if answerForm.edit><@url name="answers:edit:submit" answer=answerForm.node  /><#else><@url name="answers:post" parent=question  /></#if>"
                      method="POST">

                    <#if answerForm.edit>
                        <@spring.formHiddenInput 'answerForm.edit' />
                        <@spring.formHiddenInput 'answerForm.node' />
                        <@spring.formHiddenInput 'answerForm.question' />

                        <p class="revision_select_container">
                            <b><@trans key="node.label.revisions" default="Revisions"/></b> <select name="revisionId"
                                                                                                    id="revision_select">
                            <#list answerForm.revisions as revision>
                                <option <#if revision.id == answerForm.revisionId>selected</#if>
                                        value="${revision.id}">${revision.revision}<#if revision.author??>
                                    - <@teamhub.showUserName revision.author/></#if> (${revision.revisionDate})
                                </option>
                            </#list>
                        </select></p>
                        <script type="text/javascript">
                            $().ready(function () {
                                $("#revision_select").change(function (event) {
                                    $.post(pageContext.url.getRevision + "?revision=" + $(this).val() + "", function (data) {
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

                    <fieldset>
                        <div class="control-group">
                            <div class="controls">
                                <@spring.bind 'answerForm.body'/>
                                <textarea
                                        class="redactor"
                                        data-type="answer"
                                        id="${spring.status.expression}"
                                        name="${spring.status.expression}"
                                        rows="10"
                                        placeholder="<@trans key="thub.ask.form.body.placeholder" />"
                                        >${(spring.stringStatusValue!"")?html}</textarea>
                                <span class="help-inline"><@trans key="thub.node.body.hints"/></span>
                                <@spring.showErrors '', 'fieldError' />
                            </div>
                        </div>
                    </fieldset>
                    <#assign nodeToAttachType = 'answer' />

                    <#include '../attachments_form.ftl' />
                    <#assign form = answerForm />
                    <#include "../attachments_to_form.ftl" />

                    <div class="form-actions">
                    <#if answerForm.edit>
                        <div  style="margin-bottom:30px">
                            <@trans key="node.label.updateSummary"/>:
                            <div class="row-fluid">
                                <div class="span6" style="width: 505px; bottom: 0px">
                                    <@spring.formInput 'answerForm.summary' "style='width:480px'" 'class="askForm-title"'/><@spring.showErrors '<br>', 'fieldError' />
                                </div>
                                <div class="pull-right" style="margin-left:30px; max-width:130px; padding:0px; margin-top:10px">
                                    <label id="notifyFollowers" for="extraData"> <@trans key="thub.ask.notifyFollowers"/>:
                                        <@spring.formCheckbox "answerForm.notifyFollowers"/>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <input type="submit" class="submit btn btn-primary pull-right" id="submit-question"
                               value="<@trans key="label.save" />"/>
                        <input type="button" class="btn submit cancel pull-right"
                               onclick="window.location='<@url obj=answerForm.node/>'; return false;"
                               value="<@trans key="label.cancel" />"/>
                    <#else>
                        <input type="submit" class="btn btn-primary" value="<@trans key="thub.answers.add" />"/>
                    </#if>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</#if>

