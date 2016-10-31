<div id="${profileUser.id}-activity-block" class="widget activity-block">
    <div class="widget-header">
        <h3><#if currentUser?? && currentUser == profileUser><@trans key="thub.users.profile.blocks.activity.yourActivity" /><#else><@trans key="thub.users.profile.blocks.activity.usersActivity" params=[userUtils.displayName(profileUser)]/></#if></h3>
    </div>
    <div class="widget-content stream">
    </div>
    <div class="widget-content actions"><i style="display:none" class="spinner icon-spinner icon-spin icon-2x"></i><a class="more"><@trans key="label.showMore" /></a></div>
</div>

<script type="text/javascript">
    var loadPage;
    var currentPage;

        var $activityBlock = $("#${profileUser.id}-activity-block");
        var $activityBlockContent = $activityBlock.children(".widget-content.stream");
        var $actions = $activityBlock.children(".actions");
        var pageSize = 5;
        var pages = {
            activity:  0,
            questions: 0,
            answers:   0,
            comments:  0,
            favorite:  0
        };
        var pagerUrls = {
            activity:  "<@url name="users:profile:userActivity" user=profileUser />",
            questions: "<@url name="users:profile:userQuestions" user=profileUser />",
            answers:   "<@url name="users:profile:userAnswers" user=profileUser />",
            comments:  "<@url name="users:profile:userComments" user=profileUser />",
            favorite: "<@url name="users:profile:userFavorites" user=profileUser />"
        };
    var clearActivityContent = false;
    $(document).ready(function(){
        loadPage  = function(tab){

            if(currentPage != tab)
            {
                clearActivityContent = true;
                pages[tab] = 0;
            }
            else
                clearActivityContent = false;

            currentPage = tab;
            pages[tab]++;
            $actions.children(".more").hide();
            $actions.children(".spinner").show();
            var pageParamname;
            if(tab == "questions")
            {
                pageParamname = "page";
                paramPageSize = "pageSize"   ;
            }
            else
            {
                pageParamname = tab + "Page";
                paramPageSize = tab + "PageSize";

            }
            $.get( pagerUrls[tab] + "?" + pageParamname + "=" + pages[tab] + "&" + paramPageSize+"=" + pageSize + "&t=${.now?long}", function(data){
                if(clearActivityContent)
                    $activityBlockContent.html("");

                $activityBlockContent.append($(data).hide());
                if($(data).siblings("div").size() >= pageSize){
                    $actions.children(".more").show();
                }
                $activityBlockContent.children("div:hidden").show("blind", {}, 500);
                $actions.children(".spinner").hide();
            });
        };
        $actions.children(".more").click(function(){
            loadPage(currentPage)
        });
        loadPage("activity");
    });
</script>