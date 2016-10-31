
        <div id="reply-container-${reply.id}" class="post-container reply-container clearfix <#if reply.status.accepted??> accepted-reply"</#if>" nodeid="${reply.id}">
<div id="reply-${reply.id}" class="reply clearfix post">
    <#assign node = reply />
    <#include "node_left.ftl" />
    <#assign authorLink>
        <@teamhub.objectLink reply.author userUtils.displayName(reply.author)/>
        <#if reply.author.tagline?? && reply.author.tagline != "">, ${reply.author.tagline}</#if>
    </#assign>
    <#assign controlNode = reply />
    <@reply.include path="/nodes/includes/controls_block.ftl" />
    <div class="labels">
        <#if reply.marked><span class="label label-success"><@trans key="thub.node.reply.bestreply" /></span></#if>
        <#if reply.isWiki()><span class="label label-info label-wiki"><@trans key="label.wiki" /></span></#if>
    </div>
    <p class="muted author-info">
        <@trans key=".${reply.typeName}.label.replied" params=[authorLink] /> <span class="post-info muted">&middot;
        <#--<#if (currentUser?? && answerhub.get_node_real_author(reply) =  currentUser) || (security.hasRole('ROLE_USE_ANY_ALTEREGO'))  >-->
            <#--<#if !answerhub.is_node_real_author(reply)>-->
                <#--(-->
                <#--<#assign realUser=answerhub.get_node_real_author(reply) />-->
                <#--<@teamhub.avatar realUser 12 true/>-->
                <#--<@teamhub.objectLink realUser userUtils.displayName(realUser)/>-->
                <#--)-->
            <#--</#if>-->
        <#--</#if>-->
        <@dateSince date=reply.creationDate />
                    </span></p>
    <div class="reply-body">
    ${reply.asHTML()}
    </div>

    <div class="comment-tools hidden"><span class="add-comment-link "><a href="#" ><@trans key="thub.nodes.view.add-new-comment"/></a></span></div>
    <@teamhub.controlBar reply childRel />
    <#assign parent = reply />
    <#include "../comment_add.ftl" />
        <div class="comments-container" id="comments-container-${reply.id}" nodeid="${reply.id}">
        <@commentMacros.listComments reply />
</div>

</div>
<script type="text/javascript">
    $(function() {setupComments($('#reply-container-${reply.id}'), true, <#if reply.status.locked??>true<#else>false</#if>, croles)});
    $(document).ready(function(){
        var $reply = $("#reply-container-${reply.id}");
        var $replyLink = $reply.find(".reply-link");
        $replyLink.click(function(e){
            e.preventDefault();
            $reply.find(".add-comment-link").click();
        });
    });
</script>
</div>
