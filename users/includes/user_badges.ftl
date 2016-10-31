<h3><@trans key="thub.users.profile.tabs.badges" /></h3>

<a name="badges"></a>
<#assign badges = teamHubManager.awardManager.getSiteAndUserAwards(profileUser, currentSite) />
<h2><@trans key="thub.users.profile.tabs.badges.count" params=["<span class=\"count\">" + badges?size + "</span>"] /></h2>
<div class="user-stats-table">
    <#assign badgeCount = 0 />
    <table>
       <#list badges as badge>
            <#if badgeCount == 0 ><tr style="vertical-align:top;padding-right:100px;"></#if>
              <td valign="top" style="padding-right: 20px;">
                <#-- <#assign awardPlug><@trans key=badge[1]/></#assign>
                 <#assign awardPlug = awardPlug?lower_case?replace(" ", "-") />-->
                    <#-- We're duplicating this because we return an array - its probably not the best idea -->
                    <#assign awardPlug><@trans key=badge[1] /></#assign>
                    <#assign awardPlug = awardPlug?lower_case?replace(" ", "-") />
                    <#assign awardIcon = "/images/badges/"+badge[1]?lower_case?replace(" ", "-") +".png" />
                    <#assign awardIconSrc>
                        <@url path=awardIcon/>
                    </#assign>
                    <#assign content>
                        <img src="${awardIconSrc}" alt=""/>
                    </#assign>

                    <a rel="award" nodeId="${award[0]}" awardType="${award[0]}" desc="${awardPlug}" awardIconSrc="${awardIconSrc}" title="<#if award[2]??><@trans key=award[2]/><#else><@trans key="thub.users.profile.tabs.badges.noDesc" /></#if>" href="<@url name="award:list" awardType=award[0] desc=awardPlug/>">
                        <img src="${awardIconSrc}"/>
                    </a>
                    <span class="count">x${award[3]}</span>
              </td>
            <#if badgeCount == 4>
               </tr>
                <#assign badgeCount = 0 />
            <#else>
                <#assign badgeCount = badgeCount + 1 />
            </#if>
        </#list>
    </table>
</div>
