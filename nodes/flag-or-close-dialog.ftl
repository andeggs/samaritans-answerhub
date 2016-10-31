<script type="text/x-jquery-tmpl" id="flag-or-close-post-dialog">
<#noparse>
    ${description}
    <select name="sample" class="prompt-examples">
        {{each(i, hint) reportHints }}
        <option value="${hint}">${hint}</option>
        {{/each}}
    </select>
    <textarea name="prompt">${reportHints[0]}</textarea>
</#noparse>
</script>