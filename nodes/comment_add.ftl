<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />

<#assign childType = parent />
<#if !childType.attachmentsEnabled>
<script>
    $(function(){removePluginFromConfig("upload", "${childType.typeName}")});
</script>
</#if>

<div id="comment-${parent.id}-form-container" class="clearfix well comment-form-container">
    <form id="comment-${parent.id}-form" action="<@url name="comments:add.json" parent=parent.id  />" method="POST"
          accept-charset="utf-8">
        <div class="comment-form-widgets-container">
        <#if comment_alterego??><b><@trans key="thub.comment.as" default="Commenting as"/>
            <@teamhub.objectLink comment_alterego userUtils.displayName(comment_alterego)/></b></#if>
            <div class="comment-form-textarea-container">
                <textarea name="body" class="commentBox" data-type="comment"></textarea>
            </div>
            <div class="comment-form-buttons">
                <span id="comment-{{ post.id }}-chars-left" class="comment-chars-left">
                    <span class="comments-char-left-count warn"><@teamhub.setting "site.comment.minBodyLength"/>
                        |<@teamhub.setting "site.comment.maxBodyLength"/></span>
                    <span class="comments-chars-togo-msg"><@trans key="thub.comment.charsneeded" /></span>
                    <span class="comments-chars-left-msg"><@trans key="thub.comment.charsleft" /></span>
                    <span class="comments-chars-exceeded-msg"><@trans key="thub.comment.charsexceeded" /></span>
                </span>

                <div class="comment-form-buttons-container">
                    <input type="submit" class="btn btn-primary comment-submit"
                           value="<@trans key="thub.comment.add.submit" />"/>
                    <input type="submit" class="btn comment-cancel" value="<@trans key="thub.comment.add.cancel" />"/>
                </div>
                <div class="dropdown comment-recipient-container">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">▼</a>
                    <ul class="dropdown-menu context-menu-dropdown-comments" role="menu" aria-labelledby="dLabel">
                        <li class="item"><a href="#" class="comment-recipients-selector"
                                            value="full"><@trans key="thub.comment.visible.toEveryone"  /></a></li>
                        <#if rel.canSetViewableByOriginalPoster() >
                        	<li class="item"><a href="#" class="comment-recipients-selector"
                                            value="op"><@trans key="thub.comment.visible.toOriginalPoster"  /></a></li>
						</#if>
                        <li class="item"><a href="#" class="comment-recipients-selector"
                                            value="mod"><@trans key="thub.comment.visible.toModeration"  /></a></li>
                        <li class="item"><a href="#" class="comment-recipients-selector"
                                            value="opAndMod"><@trans key="thub.comment.visible.toOpAndMod"  /></a></li>
                    <li class="item"><a href="#" class="comment-recipients-selector" value="recipient"><@trans key="thub.comment.visible.toOther"  /></a></li>
                    </ul>
                    <span class="comment-recipients-label"><@trans key="thub.comment.visible.toEveryone"  /></span>
                </div>
            </div>
            <div style="clear:both;"></div>
        </div>
        <input type="hidden" name="parent" value="${parent.id}"/>
        <input type="hidden" name="visibility" value="full"/>

        <div style="display: none" class="comment-form-extra-inputs"></div>
    </form>
</div>
