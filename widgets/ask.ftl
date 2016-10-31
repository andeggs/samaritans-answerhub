<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />

<div class="widget ask-widget">
    <div class="widget-header">
        <i class="icon-pencil"></i>

        <h3>Ask a Question</h3>
    </div>
    <div class="widget-content">
        <div class="ask-widget-avatar">
        <@teamhub.avatar currentUser 50 />
        </div>
        <div class="ask-widget-form">
            <form>
                <input placeholder="Type your question here..." value="" type="text"
                       style="width: 100%; min-height: 28px;">

                <div class="ask-widget-form-toggle">
                    <textarea placeholder="Add some details..." rows="3" style="width:100%"></textarea>

                    <select data-placeholder="Select topics" class="topic-select chzn-select" multiple>
                        <option value=""></option>
                        <optgroup label="Science">
                            <option>Physics</option>
                            <option>Physics</option>
                            <option>Physics</option>
                            <option>Physics</option>
                            <option>Physics</option>
                            <option>Physics</option>
                        </optgroup>
                    </select>

                    <select data-placeholder="Post question in..." multiple class="chzn-select">
                        <option value="Special">Special</option>
                        <option value="Dafault">Default</option>

                    </select>


                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary pull-right">Submit question</button>
                        <span class="btn pull-right cancel">Cancel</span>
                    </div>
                </div>
            </form>
        </div>
    </div>

</div>
<!-- 
<script type="text/javascript"> $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({allow_single_deselect:true}); </script>

 -->
<script type="text/javascript">
    $(document).ready(function () {
        $(".ask-widget").click(function () {
            $(this).find(".ask-widget-form-toggle").show("slow")
        });
        $(".ask-widget-form .form-actions .cancel").click(function (e) {
            e.stopPropagation()
            $(this).parents(".ask-widget-form-toggle").hide("slow")
        });
    });
</script>

<style type="text/css">
    .ask-widget .chzn-container-multi .chzn-choices .search-field input {
        min-height: 28px;
    }

    .ask-widget .ask-widget-avatar {
        float: left;
        width: 7%;
    }

    .ask-widget .ask-widget-form {
        width: 91%;
        margin: 0 0 0 2%;
        float: left;
    }

    .ask-widget .cancel {
        margin: 0 10px 0 0;
    }

    .ask-widget .chzn-container {
        margin: 0 0 5px 0;
    }

    .ask-widget-form-toggle {
        display: none;
    }
</style>