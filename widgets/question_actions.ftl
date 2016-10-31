<#import "/macros/teamhub.ftl" as teamhub />

<div class="widget advanced-search-widget">
    <div class="widget-header">
        <i class="icon-tags"></i>

        <h3><@trans key="osqa.widgets.questionactions.title" default="Question Actions Stream" /></h3>
    </div>
    <div class="widget-content ">
        <span>
        Use this widget to see the actions stream for the question.<br/>
            <script>
                function getQuestionActionsStream() {

                    $.get("<@url name="questions:questionActions.html" />?q=${question.id}",function(data){
                        $("#question-actions").html(data);
                    });
                    $('#question-actions').toggle();
                    $(this).parent().getQuestionActionsStreamhide();
                    return false;
                }
            </script>
        <a href="#" onclick="getQuestionActionsStream();$(this).hide();return false;">Get actions</a>
       </span>
        <div id="question-actions" style="display:none">

     </div>
</div>