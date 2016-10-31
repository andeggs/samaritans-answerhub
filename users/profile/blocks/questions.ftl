<div id="${profileUser.id}-activity-block" class="widget activity-block">
    <div class="widget-header">
        <h3><#if currentUser?? && currentUser == profileUser><@trans key="thub.users.profile.blocks.activity.yourActivity" /><#else><@trans key="thub.users.profile.blocks.activity.usersActivity" params=[userUtils.displayName(profileUser)]/></#if></h3>
    </div>
    <div class="widget-content stream">
    </div>
    <div class="widget-content actions"><i style="display:none" class="spinner icon-spinner icon-spin icon-2x"></i><a class="more"><@trans key="label.showMore" /></a></div>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        var $activityBlock = $("#${profileUser.id}-activity-block");
        var $activityBlockContent = $activityBlock.children(".widget-content.stream");
        var $actions = $activityBlock.children(".actions");
        var pageSize = 10;
        var pages = {
            activity:  0,
            questions: 0,
            answers:   0,
            comments:  0,
            edits:     0
        };
        var pagerUrls = {
            activity:  "<@url name="users:profile:userActivity" user=profileUser />",
            questions: "<@url name="users:profile:userQuestions" user=profileUser />",
            answers:   "<@url name="users:profile:userAnswers" user=profileUser />",
            comments:  "<@url name="users:profile:userComments" user=profileUser />",
            edits:     "<@url name="users:profile:userEdits" user=profileUser />"
        };
        var loadPage = function(tab){
            pages[tab]++;
            $actions.children(".more").hide();
            $actions.children(".spinner").show();
            $.get( pagerUrls[tab] + "?" + tab + "Page=" + pages[tab] + "&" + tab + "PageSize=" + pageSize, function(data){
                $activityBlockContent.append($(data).hide());
                if($(data).children("div").size() >= pageSize){
                    $actions.children(".more").show();
                }
                $activityBlockContent.children("div:hidden").show("blind", {}, 500);
                $actions.children(".spinner").hide();
            });
        };
        $actions.children(".more").click(function(){
            loadPage("activity")
        });
        loadPage("activity");
    });
</script>