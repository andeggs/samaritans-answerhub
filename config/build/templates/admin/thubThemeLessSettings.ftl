<#import "/macros/teamhub.ftl" as teamhub />
<#import "/admin/macros.ftl" as adminUtils />

<#macro formTab tabId subgroups>
<div id="${tabId}">

        <div class="ajax-settings-multi-form-container">
        <#list subgroups as subgroup>
            <div class="ajax-settings-multi-form-wrapper">
                <div class="form-header">
                    <h2><@trans key=subgroup.key default=":explodeLast" /></h2><span class="more">+</span><span class="less">-</span>
                </div>
                <form action="" method="POST" class="standardForm ajax-settings-multi-form">
                    <input type="hidden" name="key" value="${subgroup.form.settingsPath}" />
                    <@adminUtils.generateForm subgroup.form.settingsPath subgroup.formName + "Form" subgroup.form />
                </form>
            </div>
        </#list>
            <input type="submit" id="save-less-settings" value="<@trans key="label.save" />" class="ajax-settings-multi-form-save" />
        </div>

</div>
</#macro>

<html>
<head>
    <title><@trans key="admin.style-settings" /></title>

    <script type="text/javascript">
        $(function() {
            $(document).ajaxComplete(function(event, xhr, settings) {
                if (/saveSettings\.json$/.test(settings.url)) {
                    $.get("<@url name="less:clearCompiled.json" />");
                }
            });
        });
    </script>

    <style type="text/css">
        .less{
            display:none;
        }

        .form-header{
            float:left;
            width: 100%;
        }

        .form-header h2{
            float:left;
        }

        .less, .more{
            font-size: 18px;
            padding: 18px 10px 9px 10px;
            float:right;
            cursor: pointer;
            font-weight: bold;
        }

        .ajax-settings-multi-form-container form{
            display: none;
        }

        .ajax-settings-multi-form-save{
            margin-top:10px;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function(){
            $(".form-header").click(function(){
                var $container = $(this).parent();
                $container.find(".more").toggle();
                $container.find(".less").toggle();
                $container.find("form").slideToggle();
            });
        });
    </script>

</head>
<body>
<#include "/admin/site/sidebar.ftl" />

<h1><@trans key="admin.style-settings" /></h1>

<div class="tabs">
    <ul>
    <#list tabsList as tab>
        <li><a href="#${tab.name!("tabs-" + tab_index)}"><@trans key="plugin.lcl." + tab.name default=":explodeLast" /></a></li>
    </#list>
    </ul>

    <#list tabsList as tab>
        <@formTab tab.name!("tabs-" + tab_index) tab.subgroups />
    </#list>

</div>
</body>