<h3>
<#if !currentSpace?? && !listType?? && !topic?? && currentUser?? && currentUser.hasRole('ROLE_SITE_OWNER')>

    <@trans key="thub.guide.welcome" default="Welcome To Your New TeamHub!"/>
<#elseif currentSpace??>
    <@trans key="thub.guide.welcome.anon" default="Welcome to the New Space, {0}" params=[(currentSpace.name)!"TeamHub server"]/>
<#elseif topic??>
    <@trans key="thub.guide.welcome.anon3" default="Welcome to the Topic, {0}" params=[(topic.name)!"TeamHub server"]/>
<#else>
  <@trans key="thub.guide.welcome.anon2" default="Welcome To Your New TeamHub!" params=[(currentSite.name)!"TeamHub server"]/>

</#if>
</h3>
