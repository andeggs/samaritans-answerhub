<script type="text/x-jquery-tmpl" id="redirect-question-dialog">
    <h4><@teamhub.clean question.title/></h4>
    <label class="control-label" style="margin: 18px 0 22px;" for="searchQuestion"><@trans key="thub.nodes.redirect.guideline" /></label>
    <div class="controls">
        <div class="SearchAnswers">
            <input type="text" style="background-image: none;" class="textInput input-block-level" id="searchQuestion" placeholder="<@trans key="thub.nodes.redirect.findQuestion" default="Search for a question"/>" onclick="if(this.value=='Find Question'){this.value = ''}" />
            <div id="results"></div>
            <form class="hidden">
                <input type="hidden" name="to" />
            </form>
        </div>
    </div>
</script>