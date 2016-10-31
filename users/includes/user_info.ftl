<#import "../../macros/security.ftl" as security />
<#import "/spring.ftl" as spring />
<@spring.bind 'userForm.*' />
<h3><@trans key="thub.users.profile.tabs.profile" /></h3>
    <#--<#if profileUser.id == currentUser.id>
        <form id="userForm" action="" method="POST" class="light-form tight">
            <div>
                <label class="long"><@trans key="profileUser.label.currentStatus"/></label><br/>
                <input class="long" type="text" value="" name="currentStatus" id="currentStatusEntry" maxlength="200"/>
            </div>
        </form>
    </#if>-->
    
	<form id="userProfileEditForm" class="profile" method="POST" class="light-form" action="<@url name="users:profile:edit" user=profileUser />">
        <div class="noneditable profileFormField">
            <label for="username"><@trans key="thub.users.profile.tabs.profile.username" /></label>
            <@spring.formInput 'userForm.username' /><@spring.showErrors '<br>', 'fieldError' />
        </div>

        <div class="profileFormField">
            <label for="email"><@trans key="thub.users.profile.tabs.profile.email" /></label>
            <@spring.formInput 'userForm.email' /><@spring.showErrors '<br>', 'fieldError' />
        </div>

        <div class="profileFormField">
            <label for="realname"><@trans key="thub.users.profile.tabs.profile.realname" /></label>
            <@spring.formInput 'userForm.realname' /><@spring.showErrors '<br>', 'fieldError' />
        </div>

        <@security.access permission="edit" object=profileUser>
            <div class="profileFormField sensitiveField">
                <label for="password1"><@trans key="thub.users.profile.tabs.profile.password" /></label>
                <@spring.formPasswordInput 'userForm.password1' /><@spring.showErrors '<br>', 'fieldError' />
            </div>
            <div class="profileFormField sensitiveField">
                <label for="password2"><@trans key="thub.users.profile.tabs.profile.confirm" /></label>
                <@spring.formPasswordInput 'userForm.password2' /><@spring.showErrors '<br>', 'fieldError' />
            </div>
        </@security.access>

        <@security.access permission="edit" object=profileUser>
            <div id="cancelEditUserProfileButton" class="userProfileButton"  onclick="disableProfileFormFields(); return false;" style="float:left"><button class="btn btn-black btn-small"><@trans key="label.cancel" /></button></div>
            <div id="submitEditUserProfileButton" class="userProfileButton" style="float:left;padding-left:20px" onclick='sendProfileForm();' ><button class="btn btn-primary"><@trans key="label.submit" /></button></div>
        <br clear="all"/>
        </@security.access>
            
    </form>
        
    <script type="text/javascript">
            <#if edit??>
                enableProfileFormFields();
            <#else>
                disableProfileFormFields();
            </#if>
    </script>