function editUserProfile() {
    enableProfileFormFields();
    changePanel($("div#userInfoTab")[0]);
}
function enableProfileFormFields() {
    $.each($('.sensitiveField'), function() {
        $(this).show();
    });

    $.each($("div.profileFormField"), function() {
        if(!$(this).hasClass("noneditable")){
            $(this).children()[1].disabled=false;
        }
    });

    $("div#cancelEditUserProfileButton").show();
    $("div#submitEditUserProfileButton").show();
    $("div#editUserProfileButton").hide();
}
function disableProfileFormFields() {
    $('.sensitiveField').each(function() {
        $(this).hide();
    });

    $("div.profileFormField").each(function() {
        $(this).children()[1].disabled=true;
        $(this).children()[1].value = profileUser[$(this).children()[1].name];
    });

    $("div#cancelEditUserProfileButton").hide();
    $("div#submitEditUserProfileButton").hide();
    $("div#editUserProfileButton").show();

    $('.fieldError').each(function() {
        this.innerHTML = "";
    });
}
function sendProfileForm(){
    $.each($("div.profileFormField"), function() {
        $(this).children()[1].disabled=false;
    });
    $("#userProfileEditForm").submit();
}

