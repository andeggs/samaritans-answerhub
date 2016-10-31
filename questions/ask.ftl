<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<#import "/forms/macros.ftl" as forms />
<#import "../macros/security.ftl" as security />

<head>
<#assign pageTitle><#if askForm.edit><@trans key="thub.ask.edit.title" /><#else><@trans key="thub.ask.title" /></#if></#assign>
    <title>${pageTitle}</title>
    <script type="text/javascript">
        var jsonTopicSearch = '<@url name="topicsSearch.json" />';
        $(document).ready(function () {
            var jsonSearchUrl = '<@url name='search.json' />?type=question';
            var searchUrl = '<@url name="search"/>';
            var $title = $("#title");
            var $similarQuestions = $(".similar-questions");
            var $similarQuestionsList = $similarQuestions.find("ul");
            var request = null;
            var questionViewUrl = "<@url name="questions:view" question="{id}" plug="{plug}" />";

            $title.keyup(function () {
                if ($title.val().trim().length > 5) {
                    $.ajax({
                        dataType: "json",
                        url: jsonSearchUrl,
                        data: "compact=true&q=" + $title.val(),
                        success: function (data) {
                            if (data.searchResults.results.length > 0) {
                                $similarQuestionsList.html("");
                                $.each(data.searchResults.results, function (i, result) {
                                    result.link = questionViewUrl.replace("%7Bid%7D", result.id).replace("%7Bplug%7D", result.plug);
                                    var context = {"question": result};
                                    $similarQuestionsList.append(commandUtils.renderTemplate('similar-question-skeleton', context));
                                });
                                $similarQuestions.slideDown();
                            } else {
                                $similarQuestions.slideUp();
                            }
                        },
                        beforeSend: function (jqXHR) {
                            if (request !== null) {
                                request.abort();
                            }
                            request = jqXHR;
                        }
                    });
                } else {
                    if (request !== null) {
                        request.abort();
                    }
                    $similarQuestions.slideUp(400, function () {
                        $similarQuestionsList.html("");
                    });
                }
            });
        });
    </script>
    <content tag="packJS">
        <src>/scripts/ahub.ask.js</src>
        <src>/scripts/ahub.form.attachments.js</src>
    </content>
    <style type="text/css">
        #notifyFollowers{
            margin: 0px;
        }
    </style>
<#include "attachments_to_form.ftl" />
</head>

<body>

<content tag="sidebarOneWidgets">ahub.askSidebar</content>
<content tag="sidebarTwoWidgets">ahub.askSidebar</content>

<div class="widget">
    <div class="widget-header">
        <i class="icon-pencil"></i>

        <h3>${pageTitle}</h3>
    </div>
    <div class="widget-content">
    <@spring.bind "askForm" />
    <#if spring.status.errors.hasErrors()>
        <div class="alert alert-error"><@trans key="thub.ask.form.hasErrors" /></div></#if>
        <div class="ask-form-wrapper">
            <div class="ask-gravatar hidden-phone">
            <#if !attachmentsQuestionEnabled>
                <script>
                    $(function(){removePluginFromConfig("upload", "question")});
                </script>
            </#if>

            <#if ask_alterego??>
                <@teamhub.avatar ask_alterego 44 />
                <br/>

                <div class="ask_alterego_avatar"><@teamhub.avatar currentUser 22 /></div>
            <#elseif currentUser??><@teamhub.avatar currentUser 48 /><#else><img width="48" class="gravatar"
                                                                                 src="<@url path="/images/avi.jpg" />"/></#if>
            </div>
            <form id="fmask" data-draftType="a question" data-draftKey="<#if !askForm.edit>question-ask</#if>" action="<@url name="questions:ask.submit" />" method="post" accept-charset="utf-8">
            <@spring.bind "askForm.wiki" />
            <#--<@spring.formHiddenInput 'askForm.wiki' />-->
            <input type="hidden" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
            <@spring.bind "askForm.externalReferencedNodeId" />
            <#--<@spring.formHiddenInput 'askForm.externalReferencedNodeId' />-->
            <input type="hidden" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>
            <@spring.bind "askForm.externalReferencedNodeType" />
            <#--<@spring.formHiddenInput 'askForm.externalReferencedNodeType' />-->
            <input type="hidden" name="${spring.status.expression}" id="${spring.status.expression}" value="${(spring.stringStatusValue!"")?html}"/>

            <#if askForm.edit><@spring.formHiddenInput 'askForm.edit' />
                <div class="control-group">
                    <@spring.formHiddenInput 'askForm.node' />
                    <div class="revision-loaded"></div>
                    <label for="id_revision"><strong><@trans key="node.label.revisions" /></strong></label>
                    <select name="revisionId" id="revision_select">
                        <#list askForm.revisions as revision>
                            <option <#if revision.id == askForm.revisionId>selected</#if>
                                    value="${revision.id}">${revision.revision}
                                - ${userUtils.displayName(revision.author)}
                                (${revision.revisionDate?string(trans('thub.questions.edit.date', "MMM dd, yyyy HH:mm:ss a"))})
                            </option>
                        </#list>
                    </select>
                </div>
            </#if>
            <@spring.bind "askForm.title"/>

                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="controls">
                        <label><@trans key="thub.ask.label.title" /></label>
                        <input type="text"
                               placeholder="<@trans key="thub.ask.form.title.placeholder"/>"
                               id="${spring.status.expression}"
                               name="${spring.status.expression}"
                               value="${(spring.stringStatusValue!"")?html}"
                               autocomplete="off"
                               class="askForm-title"
                                />

                    <@spring.showErrors '<span>' 'help-inline' />
                    </div>
                </div>
                <div class="similar-questions" style="display:none;">
                    <label><@trans key="thub.ask.similarQuestions.label" /></label>
                    <ul class="unstyled"></ul>
                </div>
            <#if !askForm.edit && teamhub.getSetting("site.question.enablePrivate") && (security.hasRole("SWITCH_OWN_NODE_PRIVACY", false) || security.hasRole("SWITCH_NODE_PRIVACY", false)) >
                <@spring.bind 'askForm.visibility'/>
                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="controls">
                        <label><@trans key="thub.ask.label.makePrivate" default="Make this question private" /></label>
                        <input type="checkbox" name="visibility" value="mod"/>
                    </div>
                </div>
            </#if>
            <@spring.bind 'askForm.body'/>
                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="controls">
                        <textarea
                                class="redactor"
                                data-type="question"
                                id="${spring.status.expression}"
                                name="${spring.status.expression}"
                                rows=10
                                placeholder="<@trans key="thub.ask.form.body.placeholder" />"
                                >${(spring.stringStatusValue!"")?html}</textarea>
                        <p class="body-hints"><@trans key="thub.node.body.hints"/></p>
                    <@spring.showErrors '<span>' 'help-inline' />
                    <#assign nodeToAttachType = 'question' />
                    <#include 'attachments_form.ftl' />
                    </div>
                </div>

            <#--Extra fields-->
            <#--<@forms.renderExtraFields askForm "form" group!"" extraFields; definition, field>
                <div class="formItem">
                    <div style="float:left"><label>${definition.label}</label></div>
                    <div style="clear:both;"></div>
                ${field}
                </div>
            </@forms.renderExtraFields>-->
                <@askForm.renderExtraFields name="form"; definition, field>
                    <@spring.bind "askForm.extraData[${definition.name}]"/>
                    <div class="control-group<#if spring.status.isError()> error</#if>">
                        <div class="controls">
                            <div class="formItem">
                                <div style="float:left"><label>${definition.label}</label></div>
                                <div style="clear:both;"></div>
                            ${field}
                            </div>
                            <@spring.showErrors '<span>' 'help-inline' />
                        </div>
                    </div>
                </@askForm.renderExtraFields>

            <#if !askForm.edit>
                <div id="space-selector"
                     <#if teamhub.getSetting("site.navigation.spaces.activateInTheme") == false>style="display:none;"</#if>>
                    <label><@trans key="node.label.primarySpace"/></label>
                    <select name="primarySpace" id="space_select">
                    <@listSpaces childrenOpening="" childrenClosing="" requiredRole="ROLE_START_ASKING" excludeDefaults=false; space, has_role, depth>
                        <option <#if space.id == askForm.spaceId>selected</#if> value="${space.id}"
                                <#if !has_role>disabled="disabled"</#if>>
                            <#list 0..depth as i>&nbsp;&nbsp;&nbsp;</#list>${space.name}
                        </option>
                    </@listSpaces>
                    </select>
                </div>
            </#if>
            <@spring.bind "askForm.topics" />
                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="controls">
                        <label><@trans key="thub.ask.label.topics" /></label>
                    <#assign topicsPlaceholder><@trans key="thub.ask.topics.placeholder" /></#assign>
                    <input type="hidden" id="topics" name="topics" value="${(askForm.topics!'')?html}" data-placeholder="${topicsPlaceholder}" style="width:100%;" type="select" multiple />
                    <@spring.showErrors '<span>' 'help-inline' />
                    </div>
                </div>
                <p id="suggested-topics">
                    <span id="suggested-topics-label"><@trans key="thub.questions.ask.suggestedTags" />:</span>
                    <span id="suggested-topics-list" class="tags"></span>
                </p>

                <div class="form-actions">
                <#if askForm.edit>
			        <div>
                        <@trans key="node.label.updateSummary"/>:
                        <div class="row-fluid">
                        <div class="span9">
			        	    <@spring.formInput  'askForm.summary' 'class="edit-summary"'/><@spring.showErrors '<br>', 'fieldError' />
                        </div>
                        <div class="span3">
                            <label id="notifyFollowers" for="extraData"> <@trans key="thub.ask.notifyFollowers"/>:
                                <@spring.formCheckbox "askForm.notifyFollowers"/>
                            </label>
                        </div>
                        </div>
			        </div>
			        <br />

                    <input class="submit btn btn-primary pull-right" id="submit-question" name="ask" type="submit"
                           value="<@trans key="label.save"/>"/>

                    <input type="button" class="btn submit cancel pull-right"
                           onclick="window.location='<@url obj=askForm.node/>'; return false;"
                           value="<@trans key="label.cancel"/>"/>
                    <#else>
                    <input id="submit-question" name="ask" class="btn btn-primary pull-right submit" type="submit"
                           value="<@security.isAuthenticated><@trans key="thub.ask.submit"/></@security.isAuthenticated><@security.isNotAuthenticated><@trans key="thub.ask.submit.login"/></@security.isNotAuthenticated>"/>
                    <#--<a href="<@url name="index"/>" class="pull-right">Cancel</a>-->
                    <input type="button" class="btn submit cancel pull-right"
                           onclick="window.location='<@url name="index"/>'; return false;"
                           value="<@trans key="label.cancel"/>"/>
                </#if>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function getIsSidebarRight() {
        var all_blocks = $(".main-inner .container .row").children();

        var passed_main = false;
        var has_right = false;
        for (var i = 0; i < all_blocks.length; i++) {
            var block = all_blocks[i];
            if ($(block).hasClass("mainContent")) {
                passed_main = true;
            }
            else {
                if (passed_main)
                    has_right = true;
            }


        }
        return has_right;
    }

    $(function () {
        var the_placement;
        if (getIsSidebarRight())
            the_placement = "right";
        else
            the_placement = "left";

        $("#title").popover(
                {
                    trigger: 'focus',
                    content: '<@trans key="thub.ask.form.title.popover"/>'.replace(/\n/g, '<br />'),
                    html: true,
                    placement: the_placement,
                    title: "<@trans key="thub.ask.form.title.popover.title" />",
                }
        );

        if(typeof Attacklab !== 'undefined' && typeof Attacklab.wmd !== 'undefined'){
            $("#body").parent().popover(
                    {
                        trigger: 'click',
                        content: '<@trans key="thub.ask.form.body.popover"/>'.replace(/\n/g, '<br />'),
                        html: true,
                        placement: the_placement,
                        title: "<@trans key="thub.ask.form.body.popover.title" />",
                    }
            );
        }

        $("#s2id_topics").popover(
                {
                    trigger:'click',
                    content:'<@trans key="thub.ask.form.tags.popover"/>'.replace(/\n/g, '<br />'),
                    html:true,
                    placement:the_placement,
                    title:"<@trans key="thub.ask.form.tags.popover.title" />",
                }
        );

        $("#topics").on("select2-blur",function(){
            $("#s2id_topics").popover("hide");
        });
    });
    $("#revision_select").change(function(event) {
        $.post(pageContext.url.getRevision + "?revision=" + $(this).val() + "", function(data) {
            if (data.title != null) {
                $("#title").val(data.title);
            }

            if ($(".redactor").redactor) {
                if (data.body == null) {
                    $(".redactor").redactor("set", "");
                } else {
                    $(".redactor").redactor("set", data.body);
                }
            } else {
                if (data.body != null) {
                    $(".redactor").val(data.body);
                }
            }

            if (data.topics != null) {
                $("#topics").select2("val", data.topics.split(","));
            }
            if (data.spaceId != null) {
                $("#space_select").val(data.spaceId);
            }

            $(".revision-loaded").html("<@trans key="answer.edit.revisionLoaded" default="Revision {0} has been loaded into the form below." params=["nrevisions"] />".replace("nrevisions",data.revision)).show();
            $(".revision-loaded").addClass("alert alert-info");
        }, 'json');
    });
</script>

<#noparse>
<script type="text/x-jquery-tmpl" id="similar-question-skeleton">
<li><span
        class='score {{if question.accepted}}accepted{{/if}}' title="${question.score} {{if question.score === 1}}</#noparse><@trans key="node.votes.1" /><#noparse>{{else}}</#noparse><@trans key="node.votes.default" /><#noparse>{{/if}}{{if question.accepted}}</#noparse><@trans key="thub.ask.similarQuestions.accepted" /><#noparse>{{/if}}">
    ${question.score}</span><a href="${question.url}">${question.title}</a>{{if question.childCount > 0}} <span
        class="answer-count" title="${question.childCount} {{if question.childCount === 1}}</#noparse><@trans key="answer" /><#noparse>{{else}}</#noparse><@trans key="answers" /><#noparse>{{/if}}">
    ${question.childCount}</span>{{/if}}</li>
</script>
</#noparse>

</body>