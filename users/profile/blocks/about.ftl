<#if (profileUser.about?? && profileUser.about != "" && profileUser.about != "<p><br></p>") || security.hasPermission("edit" profileUser)>
<div id="${profileUser.id}-about-block" class="widget about-block" xmlns="http://www.w3.org/1999/html">
    <div class="widget-header">
        <h3><#if currentUser?? && currentUser == profileUser><@trans key="thub.users.profile.blocks.about.aboutMe" /><#else><@trans key="thub.users.profile.blocks.about.aboutUser" params=[userUtils.displayName(profileUser)] /></#if></h3>
        <@security.access permission="edit" object=profileUser><span class="btn edit-btn"><i class="icon-pencil show"></i> <@trans key="thub.users.profile.blocks.about.editButton" default="Edit"/></span></@security.access>
    </div>
    <div class="widget-content">

        <div class="about">
            <#if profileUser.about?? && profileUser.about != "" && profileUser.about != "<p><br></p>">
            ${profileUser.aboutAsHTML()}
            <#else>
            <a class="edit-link" href="#"><i class="icon-pencil show"></i> <@trans key="thub.users.profile.blocks.about.noAbout" /></a>
            </#if>
        </div>

        <@security.access permission="edit" object=profileUser>
        <div style="display:none;" class="input-wrapper">
            <textarea id="body" class="edit-input"></textarea>
            <div class="actions" style="display:none"><a class="btn save-btn btn-primary pull-right"><@trans key="label.save" /></a><a class="btn cancel-btn pull-right"><@trans key="label.cancel" /></a></div>
        </div>
        </@security.access>
    </div>
</div>

<script type="text/javascript" >
    $(document).ready(function(){
        var $aboutBlock = $("#${profileUser.id}-about-block");
        var noAbout    = '<a class="edit-link" href="#"><i class="icon-pencil show"></i> <@trans key="thub.users.profile.blocks.about.noAbout" /></a>';
        $aboutBlock.find(".about").expander({
            expandText: "<@trans key="thub.expander.more" />",
            userCollapseText: "<@trans key="thub.expander.less" />"
        });
    <@security.access permission="edit" object=profileUser>
        var originalText = "${profileUser.about!?js_string}";
        var $input       = $aboutBlock.find(".edit-input");
        var $inputWrapper       = $aboutBlock.find(".input-wrapper");
        var $editLinks   = $aboutBlock.find(".edit-btn, .edit-link");
        var $actions     = $aboutBlock.find(".actions");
        var $cancel      = $aboutBlock.find(".cancel-btn");
        var $save        = $aboutBlock.find(".save-btn");

        var showAboutEdit = function(){
            $aboutBlock.find(".about").hide();
            if ($input.redactor) {
                $input.redactor({ toolbar : false }).redactor('set', originalText);
            } else {
                $input.val(originalText);
            }
            $inputWrapper.show();
            $actions.show();
        };

        var hideAboutEdit = function(){
            if ($input.redactor) {
                $input.redactor('destroy');
            }
            $inputWrapper.hide();
            $aboutBlock.find(".about").show();
            $actions.hide();
        };

        $editLinks.click(function(){
            showAboutEdit();
        });

        $cancel.click(function(){
            hideAboutEdit();
        });

        $save.click(function() {
            $.post("<@url name="users:profile:updateAbout.json" user=profileUser />", {about: $input.val()}, function(data) {
                if (data.success) {
                    $aboutBlock.find(".about").show();
                    hideAboutEdit();
                    $input.val(data.result.about);
                    if(data.result.about != "" && data.result.about != "<p><br></p>"){
                        $aboutBlock.find(".about").html(data.result.aboutAsHtml);
                    } else {
                        $aboutBlock.find(".about").html(noAbout);
                        $aboutBlock.find(".edit-link").click(function(){
                            showAboutEdit();
                        });
                    }
                    originalText = data.result.about;
                    $aboutBlock.find(".about").expander({
                        expandText: "<@trans key="thub.expander.more" />",
                        userCollapseText: "<@trans key="thub.expander.less" />"
                    });
                } else {
                // TODO should show errors
                }
            });
            return false;
        });

        $cancel.click(function() {
            $input.val(originalText);
            hideAboutEdit();
            return false;
        });
    </@security.access>
    });
</script>
</#if>