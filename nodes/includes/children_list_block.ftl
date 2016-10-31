<div class="widget widget-nopad answer-list">
    <div class="widget-header">
        <h3><@trans key=".${contentType}.label.replies" params=[content.defaultChildrenCount] /></h3> &middot; <a href="#reply-form"><@trans key="thub.question.addYourAnswer" /></a>
    </div>

<div class="widget-content reply-list">
<#list rel.visibleReplies as reply>
    <@relate node=reply; childRel>
    <@content.include path="/nodes/includes/child_view_block.ftl" />
    </@relate>
</#list>

<#if replyPager??>
    <@teamhub.paginate pager=replyPager showPageSizer=false />
</#if>

</div>
</div>