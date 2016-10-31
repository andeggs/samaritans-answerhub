<#import "/macros/thub.ftl" as teamhub />
<#if !currentUser?? || currentUser.id != profileUser.id>
<h3><@trans key="thub.users.profile.tabs.favorites.personalized" params=[profileUser.username] /></h3>
<#else>
<h3><@trans key="thub.users.profile.tabs.favorites" /></h3>
</#if>
<br/>
<#if favoritePager.listCount == 0>
<p><@trans key="thub.users.profile.tabs.favorites.noFavorites" params=[profileUser.username]/></p>
</#if>
<#list favoritePager.list as node>
    <@node.include path="/nodes/list-includes/node_item_block.ftl" />
</#list>

