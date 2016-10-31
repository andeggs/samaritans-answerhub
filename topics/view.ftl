<#import "/macros/thub.ftl" as teamhub />
<#import "../macros/security.ftl" as security />
<#assign pack=JspTaglibs["/WEB-INF/teamhubpacktag.tld"] />

<head>
    <title><@teamhub.clean topic.name /></title>

<#if mixed?? && mixed>
    <#list listedTypes as listedType>
        <@cTypes.forType(listedType).include path="/nodes/list-includes/head_block.ftl" />
    </#list>
<#elseif listType??>
    <@listType.include path="/nodes/list-includes/head_block.ftl" />
</#if>
</head>
<body>
<div class="widget topic-top">
    <div class="widget-content">
        <div class="topic-header clearfix">
            <div class="topicImg topic-icon">
                <img src="<@url name="topics:icon" topic=topic />?t=<#if topic.activeRevision??>${topic.activeRevision.id?long}<#else>0</#if>"
                     id="topicIconImg" class="gravatar"/>
            <#if security.hasRole("ADD_TOPIC_ICON")>
                <div class="topicIconEditLink">
                    <a href="#" command="editTopicIcon" <#if topic.withIcon>class="on"</#if>><i
                            class="icon-edit"></i></a>
                </div>
            </#if>
            </div>
            <h1 id="nameContainer"><span
                    id="name"><@teamhub.clean topic.name?capitalize /></span><#if security.hasRole("EDIT_TOPIC")><a
                    href="#" id="editNameOn" class="edit"> <i class="icon-pencil"></i></a></#if></h1>
            <span style="display: none" id="editName"><input type="text" id="editNameInput"
                                                             value="<@teamhub.clean topic.name />"/> <button
                    id="editNameUpdate" class="btn btn-primary"><@trans key="label.update"/></button> <a href="#"
                                                                                                         id="cancelNameEdit"><@trans key="label.cancel"/></a></span>
        <#if currentUser??><a
                class="btn btn-follow <#if teamHubManager.socialManager.isUserFollowing(topic, currentUser)??>on btn-info</#if>"
                command="follow" data-node-type="topic" nodeId="${topic.name}"></a></#if>
        </div>
        <div class="about-container">
            <span <#if !topic.body??>style="display:none"</#if>
                  class="about-value"><@teamhub.clean topic.body!"" /></span> <#if security.hasRole("EDIT_TOPIC")><a
            <#if !topic.body??>style="display:none"</#if> href="#" class="edit about-edit-link"><i
                class="icon-pencil"></i></a></#if>
        <#assign topicNameAsHtml><@teamhub.clean topic.name?capitalize /></#assign>
            <a <#if topic.body??>style="display:none"</#if> href="#"
               class="about-add-link"><@trans key="thub.topics.view.about.add" params=[topicNameAsHtml] /></a>

            <div style="display: none;" class="about-edit">
                <input type="hidden" name="topic" value="${topic.id}"/>
                <textarea id="body" class="body-wmd" name="about"><#if topic.body??>${topic.body!""}</#if></textarea>
                <textarea id="body" class="body-normal" name="about"><@teamhub.clean topic.body!""/></textarea>
                <br/>

                <div class="actions">
                    <a href="#" class="about-cancel-link"><@trans key="label.cancel"/></a>
                    <button class="btn btn-primary about-update-button"><@trans key="label.update"/></button>
                </div>
            </div>
        </div>
    </div>
</div>

<#if listPager??>
    <#assign toList = listPager />
<#else>
    <#assign toList = questionPager />
</#if>

<div class="widget">
    <div class="widget-header">
        <#if mixed?? && mixed >
            <#if toList.list?size != 0>
                <h3><@trans key="thub.node.list.title" default="All Posts"/></h3>
            </#if>
        <#else>
        <div class="pull-left dropdown">
            <a class="pull-left dropdown-toggle" data-toggle="dropdown" href="#"><h3><#if filter == "unanswered"><@trans key="question.unanswered.title" /><#else><@trans key="question.list.title"/></#if> <i class="icon-caret-down"></i></h3></a>
            <ul class="dropdown-menu">
            <#if filter == "unanswered" >
                <li><a href="<@url name="topics:view" topics=topic.title filter="all" />"><@trans key="question.list.title"/></a></li>
            <#else>
                <li><a href="<@url name="topics:view" topics=topic.title filter="unanswered" />"><@trans key="question.unanswered.title" /></a></li>
            </#if>
            </ul>
        </div>
        </#if>
        <#if toList.list?size != 0>
            <a class="feed-icon" href="<@url name="feed:topic" topic=topic />" title="<@trans key="thub.topics.view.feed" default="Subscribe to this topic's RSS feed"/>"><img src="<@url path="/images/rss.png"/>" height="18" width="18"/></a>
            <@teamhub.sortBar toList />
        <#elseif !filter?? || filter != "unanswered">
            <#include "/includes/pager/list_sort_bar_empty.ftl" />
        </#if>
</div>
    <div class="widget-content" id="id_topic_content">
    <#if toList.list?size != 0>
        <#list toList.list as node>
            <@node.include path="/nodes/list-includes/node_item_block.ftl" />
        </#list>
    <#elseif filter?? && filter == "unanswered">
        <p><@trans key="thub.guide.unanswered.topic.noResultsFound"/></p>
    <#else>
        <#include "/nodes/list_empty.ftl" />
    </#if>

    <@teamhub.paginate toList />

    </div>
</div>

<content tag="sidebarOneWidgets">ahub.topic.sidebar</content>
<content tag="sidebarTwoWidgets">ahub.topic.sidebar</content>
<content tag="postMainContentWidgets">ahub.topic.postMainContent</content>

<script type="text/javascript">
    $(document).ready(function () {
        var ran = ['about', Date.now()].join('-');

        if(typeof(Attacklab) !== 'undefined' && typeof(Attacklab.wmd) !== 'undefined'){
            var $about = $('.about-container .about-value'); 
            $about.hide();
            $('.about-edit textarea.body-normal').remove();

            Attacklab.previewManager.onMarkupUpdated = function(out){
                $about.html(out);

                if(!$('.about-edit textarea#body').is(':visible')){
                    $about.show();
                }
            };
        }else{
            $('.about-edit textarea.body-wmd').remove();
        }

        register_command('editTopicIcon', {
            execute: function (evt) {

                var parser = this;

                commandUtils.showUploadDialog(evt, {
                    //tpl: 'edit-topic-icon',
                    authorizeUrl: parser.getParsedUrl('authorizeUrl'),
                    onSuccess: function (trackingId, data) {
                        $.ajax({
                            type: 'POST',
                            url: parser.getUrl(),
                            data: {file: data.fileId},
                            success: function (data) {
                                if (data.success) {
                                    $('#topicIconImg').attr('src', parser.getParsedUrl('topic.icon') + '?bypassCache=' + (Math.floor(Math.random() * 1001)));
                                } else {

                                }
                            },
                            dataType: 'json'
                        })
                    },
                    previewDialogOptions: {
                        forceSquare: true
                    },
                    dialogContext: {
                        iconUrl: this.getUrl('topic.icon')
                    }
                });
            }
        });

        commands.editTopicIcon.setUrl('authorizeUrl', '<@url name="authorizeTopicIconUpload.json" />');
        commands.editTopicIcon.setUrl('click', '<@url name="topics:saveIcon" topic=topic />');
        commands.editTopicIcon.setUrl('topic.icon', '<@url name="topics:icon" topic=topic />');

        $(".about-edit-link").click(function () {
            var $container = $(this).closest(".about-container");

            if(typeof(Attacklab) !== 'undefined' && typeof(Attacklab.wmd) !== 'undefined'){
                window[ran] = {};
                window[ran]['${topic.name}'] = $('.about-edit textarea.body-wmd').val();
            }

            $container.find(".about-edit-link").hide();
            $container.find(".about-value").hide();
            $container.find(".about-edit").show();
        });

        $(".about-add-link").click(function () {
            var $container = $(this).closest(".about-container");
            $container.find(".about-add-link").hide();
            $container.find(".about-value").hide();
            $container.find(".about-edit").show();
        });


        $(".about-cancel-link").click(function () {
            var $container = $(this).closest(".about-container");
            $edit = $container.find(".about-edit");
            $value = $container.find(".about-value");
            var txtValue = $value.text();

            if(typeof(Attacklab) !== 'undefined' && typeof(Attacklab.wmd) !== 'undefined'){
                $('.about-edit textarea.body-wmd').val(window[ran]['${topic.name}']);
                txtValue = $edit.find("textarea[name=about]").val();
            }

            if ($.trim(txtValue).length == 0) {
                $container.find(".about-add-link").show();
                $textarea = $edit.find("textarea[name=about]");
            } else {
                $value.show();
                $container.find(".about-edit-link").show();
            }
            $edit.hide();

        });

        $(".about-update-button").click(function () {
            var $container = $(this).closest(".about-container");
            var topic = $container.find("input[name=topic]").val();
            var url = '<@url name="topics:updateAbout.json" topic='{topic}' />'.replace("%7Btopic%7D", topic);
            if ($container.find("textarea[name=about]").val().length > 255) {
                alert("<@trans key="thub.topic.description.error.too_long"/>");
                return false;
            }
            var data = {about: $container.find("textarea[name=about]").val()};
            $.post(url, data, function (data) {
                if (data.success) {
                    $value = $container.find(".about-value");
                    $value.html(data.result.aboutAsHtml);
                    $edit = $container.find(".about-edit");
                    if (data.result.about != null) {
                        $container.find(".about-edit-link").show();
                        $value.show();
                        $edit.find("textarea[name=about]").text(data.result.about);
                    } else {
                        $container.find(".about-add-link").show();
                        $value.hide();
                        $edit.find("textarea[name=about]").val("");
                    }
                    $edit.hide();
                } else {
                    // TODO show errors
                }
            });
        });

        $("#editNameUpdate").click(function () {

            $.post("<@url name="topics:updateName.json" topic=topic />", {name: $("#editNameInput").val()}, function (data) {
                if (data.success) {
                    $("#nameContainer").show();
                    $("#editName").hide();
                    $("#editNameInput").val(data.result.name);
                    $("#name").html(data.result.name);
                    $("#nameContainer").effect("highlight", {}, 3000);
                } else {
                    if (data.result.error) {
                        $("#editName").find(".error").remove();
                        $("#editName").prepend("<div class='alert alert-error error'>" + data.result.error + "</div>");
                        $("#editName .alert").css("margin-left", "50px");
                        $("#editNameInput").css("margin-left", "50px");
                    }
                }
            });
        });
        $("#editNameOn").click(function () {
            $("#nameContainer").hide();
            $("#editName").find(".error").remove();
            $("#editName").show();
        });

        $("#cancelNameEdit").click(function () {
            $("#nameContainer").show();
            $("#editName").hide();
            $("#editNameInput").val($("#name").text());
            $("#editNameInput").css("margin-left", "10px"); // Back to the default
        })
    });
</script>

</body>