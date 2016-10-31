<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />

<head>
    <title><@trans key="node.revisions.title"/></title>

    <script type="text/javascript">

        $(document).ready(function () {
            rev_bodies = $('div.rev-body');
            if (rev_bodies.length > 0)toggleRev(rev_bodies.length);
            if (rev_bodies.length > 1)toggleRev(rev_bodies.length - 1);

            for (var index = 0; index < rev_bodies.length; index++) {
                rev_bodies.get(index);
            }
        });

        function toggleRev(id) {
            var rev_body = $('div#rev-body-' + id).get(0);
            var rev_arrow = $($('i#rev-arrow-' + id).get(0));
            if (rev_body.style.display == "none") {
                rev_body.style.display = "";
                rev_arrow.removeClass("icon-plus");
                rev_arrow.addClass("icon-minus");
            } else {
                rev_body.style.display = "none";
                rev_arrow.removeClass("icon-minus");
                rev_arrow.addClass("icon-plus");
            }
        }

    </script>
</head>
<body>

<content tag="postHeaderWidgetsPath">ahub.subnav</content>


<div class="widget">
    <div class="widget-header">
        <i class="icon-list"></i>

        <h3><@trans key="thub.nodes.revisions.title" /></h3>
    <#assign feedUrl><@url name="feed:questions"/></#assign>
        <a class="btn edit-btn widget-action" href="<@url obj=node/>"><i
                class="icon-arrow-left show"></i>

        <#if node.type == "question">
            <@trans key="thub.nodes.back_to_question" />
        <#elseif node.type == "answer" >
            <@trans key="thub.nodes.back_to_answer" />

        <#elseif node.type == "comment" >
            <@trans key="thub.nodes.back_to_comment" />

        <#else>
            <@trans key="thub.nodes.back_to_item" />

        </#if>
        </a>
    </div>

    <div class="widget-content">


    <#list revisions as revision>
        <div class="revision">
            <div id="rev-header-${revision.revision}"
                 class="header <#if revision.author.id == node.author.id>author</#if>">
                <div class="header-controls row">

                    <div class="span1">


                        <a href="#"
                           onclick="toggleRev(${revision.revision}); return false;">

                            <i id="rev-arrow-${revision.revision}" class="icon-plus"></i>

                        </a>


                        <span class="revision-number"
                              title="<@trans key="thub.nodes.revisions.revision" /> ${revision.revision}">${revision.revision}</span>
                    </div>

                    <div class="span5">

                        <div class="summary"><span>${revision.summary?html}</span></div>
                        <div id="rev-body-${revision.revision}" class="diff body rev-body well" style="display:none">
                            <h3>
                                <#if revision_has_next>
                        <@diff base="${(revisions[revision_index+1].title)!}" new="${(revision.title?html)!}"/>
                    <#else>
                                ${(revision.title!"")?html}
                                </#if>
                            </h3>

                            <div class="text">
                                <#if revision_has_next>
                        <@diff base="${revisions[revision_index+1].bodyAsHTML()}" new="${revision.bodyAsHTML()}"/>
                    <#else>
                                ${revision.bodyAsHTML()}
                                </#if>
                            </div>
                            <#if revision.tagnames??>
                            <div>
                                <b><@trans key="label.topics"/>:</b> ${revision.tagnames}</div>
                            </#if>
                        </div>
                    </div>
                    <div class="span2">

                        <div class="revision-mark">
                            <div class='post-update-info'>
                                <p style="line-height:12px;">
                                    <strong><@dateSince date=revision.revisionDate /> </strong>
                                </p>
                                <@teamhub.showUserInfo revision.author true true/>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>


        <hr>

    </#list>    </div>
</div>


</body>


<#--<content tag="tail"><@teamhub.paginate questionPager /></content>-->


</html>
