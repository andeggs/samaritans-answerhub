<script type="text/x-jquery-tmpl" id="post-wiki-mark">
    <div class="community-wiki">
        <div class="wiki-icon">&nbsp;</div>
        <div class="wiki-text">
            {{if isAnswer }}
        <@trans key="thub.wiki.answer.description" default='This answer is marked "community wiki"' />.
            {{else}}
        <@trans key="thub.wiki.description" default='This question is marked "community wiki"' />.
            {{/if}}

            {{if canEdit }}
            <br /><@trans key="thub.wiki.feel_free" default='Feel free to' /> <#noparse><a href="${editUrl}"></#noparse><@trans key="thub.edit.it" default="edit it" /></a>.
            {{/if}}
        </div>
    </div>
</script>