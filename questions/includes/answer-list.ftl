<#if security.hasRole("VIEW_ANSWERS")>

<div class="widget widget-nopad answer-list">
<#if !singleAnswer??>
    <div class="widget-header">
        <h3><@trans key="thub.questions.answerList.title" params=[answerPager.listCount] /></h3> <#if security.hasPermission("startAnswering", question)>&middot; <a
            href="#answer-form"><@trans key="thub.question.addYourAnswer" /></a></#if>
        <ul class="nav nav-pills sort">
            <li class="sort-label"><@trans key="label.sort"/>:&nbsp;</li>
            <li title="${trans('sort.votes')}" <#if (!sort?? || sort == "votes")> class="active"</#if>><a href="<@url obj=question/>?sort=votes"><i class="icon-thumbs-up"></i></a></li>
            <li title="${trans('sort.newest')}" <#if sort?? && sort == "newest"> class="active"</#if>><a href="<@url obj=question/>?sort=newest"><i class="icon-time"></i></a></li>
            <li title="${trans('sort.oldest')}" <#if sort?? && sort == "oldest"> class="active"</#if>><a href="<@url obj=question/>?sort=oldest"><i class="icon-history"></i></a></li>
        </ul>
    </div>
<#else>
    <div class="widget-header">
        <h3><@trans key="thub.questions.singleAnswer.title" default="Viewing a single answer from "/>${userUtils.displayName(answer.author)?html}</h3>
    </div>
</#if>

<div class="widget-content">
<#if !singleAnswer??>
    <#list rel.visibleAnswers as answer>
        <@relate node=answer; arel>
                <div
                id="answer-container-${answer.id}" class="post-container answer-container clearfix <#if answer.status.accepted??> accepted-answer"</#if>
            " nodeid="${answer.id}">
            <div id="answer-${answer.id}" class="answer clearfix post">
                <#assign node = answer />
                <#include "../../nodes/includes/node_left.ftl" />
                <#assign authorLink>
                    <@teamhub.objectLink answer.author userUtils.displayName(answer.author)/>
                    <#if answer.author.tagline?? && answer.author.tagline != "">, ${answer.author.tagline}</#if>
                </#assign>
                <#if arel.canEdit() || arel.canConvertToComment() || arel.canReport() || arel.canUseDelete() || arel.canUseWiki() || arel.canViewRevisions()>
                    <div class="post-tools" nodeid="${answer.id}">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="icon-cog"></i></a>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                            <#if arel.canEdit() >
                                <li class="item">
                                    <a rel="nofollow" class="node-tools-edit-link"
                                       href="<@url name="answers:edit" answer=answer/>"><i
                                            class="icon-edit"></i> <@trans key="label.edit"/></a>
                                </li></#if>

                            <#if arel.canViewRevisions()>
                                <li class="item">
                                    <a rel="nofollow" class="node-tools-revisions-link"
                                       href="<@url name="revisions:view" node=answer/>"><@trans key="thub.nodes.post_controls.see.revisions" default="see revisions" /></a>
                                </li>

                            </#if>

                            <#if arel.canConvertToComment()>
                                <li class="item">
                                    <a href="#" class="ajax-command convert-to-comment"
                                       command="convertToComment"> <@trans key="comment.add.short" /></a>
                                </li></#if>

                            <#if arel.canReport() || arel.canCancelReport()>
                                <li class="item">
                                    <a arel="nofollow" class="ajax-command<#if arel.reported()> on</#if> " href="#"
                                       command="reportPost">
                                        <#if !arel.reported()><@trans key="label.report" default="Flag" /><#else><@trans key="label.report.cancel" /></#if>
                                        <#if arel.canViewReports()>(${answer.reportCount})</#if>
                                    </a>
                                </li></#if>

                            <#if arel.canUseDelete()>
                                <li class="item">
                                    <a title="" class="ajax-command<#if arel.deleted()> on</#if>" command="deletePost"
                                       href="#"><@trans key="label.delete" default="Delete" /></a>
                                </li></#if>

                            <#if arel.canUseWiki()>
                                <li class="item">
                                    <a class="ajax-command<#if answer.status.wiki??> on</#if>" href="#"
                                       command="wikifyPost"><@trans key="label.wikify" default="Wikify" /></a>
                                </li></#if>
                            <#if arel.canUseLock()>
                                <li class="item">
                                    <a class="ajax-command<#if answer.status.locked??> on</#if>" href="#"
                                       command="lockPost"><@trans key="commands.lock.link" /></a>
                                </li>
                            </#if>
                        </ul>
                    </div>
                </#if>
                <div class="labels">
                    <#if answer.marked><span
                            class="label label-success"><@trans key="thub.question.answer.bestAnswer" /></span></#if>
                    <#if answer.isWiki()><span
                            class="label label-info label-wiki"><@trans key="label.wiki" /></span></#if>
                </div>
                <p class="muted author-info">
                    <@trans key="thub.question.userAnswered" params=[authorLink] /> <span class="post-info muted">&middot;
                    <#if (currentUser?? && teamhub.get_node_real_author(answer) =  currentUser) || (security.hasRole('ROLE_USE_ANY_ALTEREGO'))  >
                        <#if !teamhub.is_node_real_author(answer)>
                            (
                            <#assign realUser=teamhub.get_node_real_author(answer) />
                            <@teamhub.avatar realUser 12 true/>
                            <@teamhub.objectLink realUser userUtils.displayName(realUser)/>
                            )
                        </#if>
                    </#if>
                    <@dateSince date=answer.creationDate />
                    </span></p>

                <div class="answer-body">
                ${answer.asHTML()}
                </div>
                <#if answer.attachments?? && answer.attachments?size != 0>
                    <br />
                    <#assign attachments = answer.attachments />
                    <#include "../attachments.ftl" />
                </#if>

                <div class="comment-tools hidden"><span class="add-comment-link "><a
                        href="#"><@trans key="thub.questions.view.add-new-comment"/></a></span></div>
                <@teamhub.controlBar answer arel />
                <#assign parent = answer />
                <#include "../../nodes/comment_add.ftl" />
                <div class="comments-container" id="comments-container-${answer.id}" nodeid="${answer.id}">
                    <@commentMacros.listComments answer />
                </div>
                <script type="text/javascript">
                    $(function () {
                        setupComments($('#answer-container-${answer.id}'), true, <#if answer.status.locked??>true<#else>false</#if>, croles, "full", <#if autoExpandComments??>true<#else>false</#if>)
                    });
                    $(document).ready(function () {
                        var $answer = $("#answer-container-${answer.id}");
                        var $replyLink = $answer.find(".reply-link");
                        $replyLink.click(function (e) {
                            e.preventDefault();
                            $answer.find(".add-comment-link").click();
                        });
                    });
                </script>
            </div>
        </div>
        </@relate>
    </#list>
    <@teamhub.paginate pager=answerPager showPageSizer=false />
<#else>
    <@relate node=answer; arel>
            <div
            id="answer-container-${answer.id}" class="post-container answer-container clearfix <#if answer.status.accepted??> accepted-answer"</#if>
        " nodeid="${answer.id}">
        <div id="answer-${answer.id}" class="answer clearfix post">
            <#assign node = answer />
            <#include "../../nodes/includes/node_left.ftl" />
            <#assign authorLink>
                <@teamhub.objectLink answer.author userUtils.displayName(answer.author)/>
                <#if answer.author.tagline?? && answer.author.tagline != "">, ${answer.author.tagline}</#if>
            </#assign>
            <#if arel.canEdit() || arel.canConvertToComment() || arel.canReport() || arel.canUseDelete() || arel.canUseWiki()>
                <div class="post-tools" nodeid="${answer.id}">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="icon-cog"></i></a>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                        <#if arel.canEdit() >
                            <li class="item">
                                <a rel="nofollow" class="node-tools-edit-link"
                                   href="<@url name="answers:edit" answer=answer/>"><i
                                        class="icon-edit"></i> <@trans key="label.edit"/></a>
                            </li></#if>
                        <#if arel.canConvertToComment()>
                            <li class="item">
                                <a href="#" class="convert-to-comment"
                                   command="convertToComment"> <@trans key="comment.add.short" /></a>
                            </li></#if>

                        <#if arel.canReport() || arel.canCancelReport()>
                            <li class="item">
                                <a arel="nofollow" class="ajax-command<#if arel.reported()> on</#if> " href="#"
                                   command="reportPost">
                                    <#if !arel.reported()><@trans key="label.report" default="Flag" /><#else><@trans key="label.report.cancel" /></#if>
                                    <#if arel.canViewReports()>(${answer.reportCount})</#if>
                                </a>
                            </li></#if>

                        <#if arel.canUseDelete()>
                            <li class="item">
                                <a title="" class="ajax-command<#if arel.deleted()> on</#if>" command="deletePost"
                                   href="#"><@trans key="label.delete" default="Delete" /></a>
                            </li></#if>

                        <#if arel.canUseWiki()>
                            <li class="item">
                                <a class="ajax-command<#if answer.status.wiki??> on</#if>" href="#"
                                   command="wikifyPost"><@trans key="label.wikify" default="Wikify" /></a>
                            </li></#if>
                        <#if arel.canUseLock()>
                            <li class="item">
                                <a class="ajax-command<#if answer.status.locked??> on</#if>" href="#"
                                   command="lockPost"><@trans key="commands.lock.link" /></a>
                            </li>
                        </#if>
                    </ul>
                </div>
            </#if>
            <div class="labels">
                <#if answer.marked><span
                        class="label label-success"><@trans key="thub.question.answer.bestAnswer" /></span></#if>
                <#if answer.isWiki()><span class="label label-info label-wiki"><@trans key="label.wiki" /></span></#if>
            </div>
            <p class="muted author-info">
                <@trans key="thub.question.userAnswered" params=[authorLink] /> <span class="post-info muted">&middot;
                <#if (currentUser?? && teamhub.get_node_real_author(answer) =  currentUser) || (security.hasRole('ROLE_USE_ANY_ALTEREGO'))  >
                    <#if !teamhub.is_node_real_author(answer)>
                        (
                        <#assign realUser=teamhub.get_node_real_author(answer) />
                        <@teamhub.avatar realUser 12 true/>
                        <@teamhub.objectLink realUser userUtils.displayName(realUser)/>
                        )
                    </#if>
                </#if>
                <a href="<@url obj=answer />"><@dateSince date=answer.creationDate /></a>
		            </span></p>

            <div class="answer-body">
            ${answer.asHTML()}
            </div>

            <#if answer.attachments?? && answer.attachments?size != 0>
                <#assign attachments = answer.attachments />
                <#include "../attachments.ftl" />
            </#if>
        </div>
        <@teamhub.controlBar answer arel />
        <div class="comment-tools hidden"><span class="add-comment-link "><a
            href="#"><@trans key="thub.questions.view.add-new-comment"/></a></span></div>
        <#assign parent = answer />
        <#include "../../nodes/comment_add.ftl" />
        <div class="comments-container" id="comments-container-${answer.id}" nodeid="${answer.id}">
            <@commentMacros.listComments answer />
        </div>
        <script type="text/javascript">
            $(function () {
                setupComments($('#answer-container-${answer.id}'), true, <#if answer.status.locked??>true<#else>false</#if>, croles, "full", <#if autoExpandComments??>true<#else>false</#if>)
            });
            $(document).ready(function () {
                var $answer = $("#answer-container-${answer.id}");
                var $replyLink = $answer.find(".reply-link");
                $replyLink.click(function (e) {
                    e.preventDefault();
                    $answer.find(".add-comment-link").click();
                });
            });
        </script>
    </div>
    </@relate>
</#if>
</div>
</div>

<#if !singleAnswer??>
<#include "answer-form.ftl" />
</#if>

</#if>
