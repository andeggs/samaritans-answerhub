<#import "/spring.ftl" as spring />

<script>
    $(function() {
        $('.egoField').each(function() {
            var $this = $(this);
            var $radios = $this.find("input[type='radio']");
            var $asInput = $this.find(".userSelectorRadio");

            var $labelContainer = $this.find(".userSelectorLabelContainer");
            var $labelLink = $this.find(".userSelectorChange");
            var $label = $this.find(".userSelectorLabel");

            var $selectorContainer = $this.find('.userSelectorContainer');
            var $selector = $this.find('.userSelector');
            var $selectorCancel = $this.find('.userSelectorCancel');

            function showSelector() {
                $labelContainer.fadeOut('fast', function() {
                    $selectorContainer.fadeIn('fast', function() {
                        $selector.focus();
                    });
                });
            }

            function showLabel() {
                $selectorContainer.fadeOut('fast', function() {
                    $labelContainer.fadeIn('fast');
                });
            }

            $radios.change(function() {
                if (!$asInput.attr('checked')) {
                    showLabel();
                } else {
                    if ($asInput.val().trim() == "") {
                        showSelector();
                    }
                }
            });


            $labelLink.click(function() {
                if (!$asInput.attr('checked')) {
                    $asInput.attr('checked', 'checked');
                }
                showSelector();
                return false;
            });

            $selector.autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: '<@url name="users:alterego.json" />',
                        dataType: 'json',
                        data: { q: request.term },
                        success: function(data) {
                            response($.map(data.result, function(item) {
//                                console.log(item);
                                return {
                                    label: item.username,
                                    value: item.id
                                };
                            }));
                        }
                    });
                },
                minLength: 1,
                select: function(e, ui) {
                    $label.html(ui.item.label);
                    $asInput.val(ui.item.value);
                    $labelLink.html('<@trans key="thub.users.preferences.tabs.alteregos.change" />');
                    $selector.val('');
                    $asInput.attr("checked", "checked");
                    showLabel();
                    return false;
                }
            });

            $selectorCancel.click(function() {
                if ($asInput.val().trim() == "") {
                    $this.find("input[type='radio'][value='same']").attr('checked', 'checked');
                }
                showLabel();
            });
        });


    });
</script>
<style>
    .userSelectorLabelContainer, .userSelectorContainer {
        position: relative;
        top: 0px;
        left: 0px;
    }

    .userSelectorContainer {
        display: none;
    }

    .egoField {
        margin-bottom: 1em;
    }

    .userSelectorCancel {
        cursor: pointer;
    }

    .egoField ul {
        margin-left: 0;
    }

    .egoField li {
        list-style: none;
    }
</style>
<div class="tab-pane" id="alteregosPanel">

<p><@trans key="thub.users.preferences.tabs.alteregos.desc" /></p>


<form action="" method="POST">
    <input type="hidden" name="tab" value="alteregos" />
        <ul style="list-style:none; margin-left: 2px;">
            <#assign askingAs><@trans key="thub.users.preferences.tabs.alteregos.askingAs" /></#assign>
            <#assign answeringAs><@trans key="thub.users.preferences.tabs.alteregos.answeringAs" /></#assign>
            <#assign commentingAs><@trans key="thub.users.preferences.tabs.alteregos.commentingAs" /></#assign>
            <#assign editingAs><@trans key="thub.users.preferences.tabs.alteregos.editingAs" /></#assign>
            <#list [
                {"type": "ask", "label": askingAs},
                {"type": "answer", "label": answeringAs},
                {"type": "comment", "label": commentingAs},
                {"type": "edit", "label": editingAs}
            ] as ego>
            <#assign value=(egosForm.egos[ego.type])!"same">
            <li class="egoField">
                <h4>${ego.label}:</h4>
                <ul>
                    <li><input type="radio" name="egos[${ego.type}]" value="same" <#if value?? && value=="same">checked="checked"</#if> /> <@trans key="thub.users.preferences.tabs.alteregos.yourself" /></li>
                    <#if ego.type == "edit">
                    <li><input type="radio" name="egos[${ego.type}]" value="author" <#if value?? && value=="author">checked="checked"</#if> /> <@trans key="thub.users.preferences.tabs.alteregos.originalAuthor" /></li>
                    <li><input type="radio" name="egos[${ego.type}]" value="others" <#if value?? && value=="others">checked="checked"</#if> /> <@trans key="thub.users.preferences.tabs.alteregos.sameAsAskAnswerComment" /></li>
                    </#if>
                    <li>
                        <@loadEgo form=egosForm type=ego.type; user>
                        <input type="radio" name="egos[${ego.type}]" class="userSelectorRadio" value="<#if user??>${user.id}</#if>" <#if user??>checked="checked"</#if> />
                        <span>
                            <span class="userSelectorLabelContainer">
                                <span class="userSelectorLabel"><#if user?? && user.username??>${user.username}<#else><@trans key="thub.users.preferences.tabs.alteregos.user" /></#if></span>
                                <a class="userSelectorChange" href="#"><#if user?? ><@trans key="thub.users.preferences.tabs.alteregos.change" /><#else><@trans key="thub.users.preferences.tabs.alteregos.select" /></#if></a>
                            </span>
                            <span class="userSelectorContainer"><input class="userSelector" /> <a class="userSelectorCancel"><@trans key="label.cancel" /></a></span>
                        </span>
                        </@loadEgo>
                    </li>
                </ul>
            </li>
            </#list>
            <li>
            </li>
        </ul>
        <input type="submit" value="<@trans key="thub.users.preferences.tabs.alteregos.saveSettings" />" class="btn btn-primary"/>
</form>
</div>

