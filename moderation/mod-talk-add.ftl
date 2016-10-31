<#import "/spring.ftl" as spring />
<#import "/macros/teamhub.ftl" as teamhub />

<div id="comment-${parent.id}-form-container" class="comment-form-container">
    <form id="comment-${parent.id}-form" action="<@url name="comments:add.json" parent=parent.id  />" method="POST" accept-charset="utf-8">
        <div class="comment-form-widgets-container">
            <textarea name="body" class="commentBox"></textarea>
            <span id="comment-{{ post.id }}-chars-left" class="comment-chars-left" style="display: none;">
                    <span class="comments-char-left-count"><@teamhub.setting "site.comment.minBodyLength"/>|<@teamhub.setting "site.comment.maxBodyLength"/></span>
                </span>
            <div class="comment-form-buttons">
                <input type="hidden" name="modTalk" value="true" />
                <input type="submit" class="comment-submit" value="<@trans key="osqa.mod-talk.add.submit" default="send" />" />
                <input type="submit" class="comment-cancel" value="<@trans key="osqa.comment.add.cancel" />" />
            </div>
            <div style="clear:both;"></div>
        </div>

        <input type="hidden" name="parent" value="${parent.id}" />
    </form>
</div>

