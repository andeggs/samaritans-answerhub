<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<#import "../macros/security.ftl" as security />


<head>
<#assign pageTitle><#if form.edit><@trans key=".${contentType}.edit.title" /><#else><@trans key=".${contentType}.post.title" /></#if></#assign>
    <title>${pageTitle}</title>
    <script type="text/javascript">
        var jsonTopicSearch = '<@url name="topicsSearch.json" />';
        $(document).ready(function () {
            var jsonSearchUrl = '<@url name='search.json' />?type=${contentType}';
            var searchUrl = '<@url name="search"/>?type=${contentType}';
            var $title = $("#title");
            var $similarQuestions = $(".similar-questions");
            var $similarQuestionsList = $similarQuestions.find("ul");
            var request = null;
            var contentViewUrl = "<@url name="content:view" type=contentType node="{id}" plug="{plug}" />";

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
                                    result.link = contentViewUrl.replace("%7Bid%7D", result.id).replace("%7Bplug%7D", result.plug);
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

<#include "../questions/attachments_to_form.ftl" />
</head>

<body>

<content tag="sidebarOneWidgets">ahub.${contentType}.form.sidebar</content>

<div class="widget">
    <div class="widget-header">
        <i class="icon-pencil"></i>

        <h3>${pageTitle}</h3>
    </div>
    <div class="widget-content">
    <@spring.bind "form" />
    <#if spring.status.errors.hasErrors()>
        <div class="alert alert-error"><@trans key=".${contentType}.form.hasErrors" /></div></#if>
        <div class="${contentType}-form-wrapper node-form-wrapper">
            <div class="${contentType}-gravatar post-gravatar hidden-phone">
            <#if !attachmentsEnabled>
                <script>
                    $(function(){removePluginFromConfig("upload", "${contentType}")});
                </script>
            </#if>

            <#if ask_alterego??>
                <@teamhub.avatar ask_alterego 44 />
                <br/>

                <div class="ask_alterego_avatar"><@teamhub.avatar currentUser 22 /></div>
            <#elseif currentUser??><@teamhub.avatar currentUser 48 /><#else><img width="48" class="gravatar"
                                                                                 src="<@url path="/images/avi.jpg" />"/></#if>
            </div>
            <form id="fmask" data-draftType="an idea" <#if !form.edit>data-draftKey="post-${contentType}"</#if> action="${postUrl}" method="post" accept-charset="utf-8">
            <#--<@spring.formHiddenInput 'form.wiki' />-->
            <#if form.edit><@spring.formHiddenInput 'form.edit' />
                <div class="control-group">
                    <@spring.formHiddenInput 'form.node' />
                    <div class="revision-loaded"></div>
                    <label for="id_revision"><strong><@trans key="node.label.revisions" /></strong></label>
                    <select name="revisionId" id="revision_select">
                        <#list form.revisions as revision>
                            <option <#if revision.id == form.revisionId>selected</#if>
                                    value="${revision.id}">${revision.revision}
                                - ${userUtils.displayName(revision.author)}
                                (${revision.revisionDate})
                            </option>
                        </#list>
                    </select>
                </div>
            </#if>
                <@form.renderExtraDetails name="form" formsPath="/nodes/forms"; definition, field>
                    ${field}
                </@form.renderExtraDetails>
            <#if isRoot>
                <@spring.bind "form.title"/>
                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="controls">
                        <label><@trans key=".${contentType}.input.title.label" /></label>
                        <input type="text"
                               id="${spring.status.expression}"
                               name="${spring.status.expression}"
                               value="${(spring.stringStatusValue!"")?html}"
                               autocomplete="off"
                               placeholder="<@trans key=".${contentType}.input.title.placeholder" />"
                               class="${contentType}-form-title form-title"
                                />

                        <@spring.showErrors '<span>' 'help-inline' />
                    </div>
                </div>
                <div class="similar-questions" style="display:none;">
                    <label><@trans key=".label.similar.${contentType}" default="${contentType?cap_first}s that might be similar:"/></label>
                    <ul class="unstyled"></ul>
                </div>
            </#if>
            <@spring.bind 'form.body'/>
                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="controls">
                        <textarea
                                class="redactor"
                                data-type="${contentType}"
                                id="${spring.status.expression}"
                                name="${spring.status.expression}"
                                rows=10
                                placeholder="<@trans key=".${contentType}.input.body.placeholder" />"
                                >${(spring.stringStatusValue!"")?html}</textarea>
                        <span class="help-inline"><@trans key="thub.node.body.hints"/></span>
                    <@spring.showErrors '<span>' 'help-inline' />
                    <#assign nodeToAttachType = postType />
                    <#include 'includes/attachments_form.ftl' />
                    </div>
                </div>

            <#--Extra fields-->
            <@form.renderExtraFields name="form"; definition, field>
                <div class="formItem">
                    <div style="float:left"><label>${definition.label}</label></div>
                    <div style="clear:both;"></div>
                ${field}
                </div>
            </@form.renderExtraFields>
            <#if isRoot && !form.edit>
                <div id="space-selector"
                     <#if teamhub.getSetting("site.navigation.spaces.activateInTheme") == false>style="display:none;"</#if>>
                    <label><@trans key=".${contentType}.input.space.label"/></label>
                    <select name="primarySpace" id="space_select">
                        <#assign requiredRole = postType.featureRole('START_POSTING') />
                        <@listSpaces childrenOpening="" childrenClosing="" requiredRole=requiredRole excludeDefaults=false; space, has_role, depth>
                            <option <#if space.id == form.spaceId>selected</#if> value="${space.id}"
                                    <#if !has_role>disabled="disabled"</#if>>
                                <#list 0..depth as i>&nbsp;&nbsp;&nbsp;</#list>${space.name}
                            </option>
                        </@listSpaces>
                    </select>
                </div>
            </#if>
            <#if isRoot>
                <@spring.bind "form.topics" />
                <div class="control-group<#if spring.status.isError()> error</#if>">
                    <div class="controls">
                        <label><@trans key=".${contentType}.input.topics.label" /></label>
                        <#assign topicsPlaceholder><@trans key=".${contentType}.input.topics.placeholder" /></#assign>
                        <#--<@spring.formHiddenInput 'form.topics' 'data-placeholder="' + topicsPlaceholder + '" style="width:100%;" type="select" multiple' />-->
                        <input type="hidden" id="topics" name="topics" value="${(form.topics!'')?html}" data-placeholder="${topicsPlaceholder}" style="width:100%;" style="width:100%;" type="select" multiple />

                        <@spring.showErrors '<span>' 'help-inline' />
                    </div>
                </div>
                <p id="suggested-topics">
                    <span id="suggested-topics-label"><@trans key=".${contentType}.post.label.suggestedTags" />:</span>
                    <span id="suggested-topics-list" class="tags"></span>
                </p>
            </#if>
                <div class="form-actions">
                <#if form.edit>
                    <input class="submit btn btn-primary pull-right" id="submit-question" name="post" type="submit"
                           value="<@trans key="label.save"/>"
                            />

                    <input type="button" class="btn submit cancel pull-right"
                           onclick="window.location='<@url obj=form.node/>'; return false;"
                           value="<@trans key="label.cancel"/>"/>
                <#else>
                    <input id="submit-question" name="post" class="btn btn-primary pull-right submit" type="submit"
                           value="<@security.isAuthenticated><@trans key=".label.submit.${contentType}" /></@security.isAuthenticated><@security.isNotAuthenticated><@trans key=".label.submit.node.login"/></@security.isNotAuthenticated>"/>
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
                    content: '<@trans key=".${contentType}.input.title.popover"/>'.replace(/\n/g, '<br />'),
                    html: true,
                    placement: the_placement,
                    title: "<@trans key=".${contentType}.input.title.popover.title" />"
                }
        );
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
    <li><a href="${question.link}">${question.title}</a></li>
</script>
</#noparse>

</body>