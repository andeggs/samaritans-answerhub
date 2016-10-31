<#import "/macros/thub.ftl" as teamhub />

<head>
    <!-- Use the .htaccess and remove these lines to avoid edge case issues. More info: h5bp.com/i/378 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="utf-8">

    <title><@teamhub.clean title/> - ${(currentSite.name)!"TeamHub server"}</title>
    <meta name="description" content="<@teamhub.setting 'site.meta.description'/>">

    <!-- Mobile viewport optimized: h5bp.com/viewport -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#include "canonical.ftl" />


    <#include "js_var_init.ftl"/>

        <!--[if lte IE 10]>
    <script src="<@url path='/scripts/compatibility/indexOf.js'/>" type="text/javascript"></script>
    <![endif]-->
    <!--[if lt IE 9]>
    <script src="<@url path='/scripts/compatibility/document.getSelection.js'/>" type="text/javascript"></script>
    <script src="<@url path='/scripts/compatibility/ierange-m2-packed.js'/>" type="text/javascript"></script>
    <style type="text/css">
        input[type="password"] {
            font-family: Arial;
        }
    </style>
    <![endif]-->
<@pack.script>
    <src>/scripts/jquery-1.10.1.min.js</src>
    <src>/scripts/jquery-migrate-1.2.1.js</src>
    <src>/scripts/date.js</src>
    <src>/scripts/teamhub.commands.js</src>
    <src>/scripts/bootstrap-tagautocomplete-deps/rangy-core.js</src>
    <src>/scripts/bootstrap-tagautocomplete-deps/caret-position.js</src>
    <src>/scripts/redactor/redactor.js</src>
    <src>/scripts/redactor/upload.js</src>
    <src>/scripts/select2/select2.min.js</src>
    <src>/scripts/jquery.expander.js</src>
    <src>/scripts/ahub.pops.js</src>
    <src>/scripts/tooltipster/js/jquery.tooltipster.min.js</src>
    <src>/scripts/qtip/jquery.qtip.min.js</src>
    <src>/scripts/jsmime.js</src>
    <src>/scripts/jquery.storageapi.js</src>
    <src>/resources/bootstrap/js/bootstrap-dropdown.js</src>
    <src>/resources/bootstrap/js/bootstrap-collapse.js</src>
    <src>/resources/bootstrap/js/bootstrap-tab.js</src>
    <src>/resources/bootstrap/js/bootstrap-tooltip.js</src>
    <src>/resources/bootstrap/js/bootstrap-popover.js</src>
    <src>/resources/bootstrap/js/bootstrap-modal.js</src>
    <src>/resources/bootstrap/js/bootstrap-alert.js</src>
    <src>/scripts/jquery-ui/js/jquery-ui-1.10.4.custom.js</src>
    <src>/scripts/prettify/prettify.js</src>
    <src>/scripts/sidr/jquery.sidr.min.js</src>
    <#--Placeholders in older browsers, mainly ie<10-->
    <src>/scripts/compatibility/placeholders.min.js</src>
    <src>/scripts/teamhub.node.commands.js</src>
    <src>/scripts/ahub.viewquestion.js</src>
    <src>/scripts/rangy-saverestore-selection.js</src>
    <src>/scripts/redactor/redactor.init.js</src>
    <#if page.properties['page.packJS']??>
    ${page.properties['page.packJS']}
    <#--<src>/scripts/jquery.tmpl.js</src>-->
    </#if>


</@pack.script>
    <#include "js_var_extend.ftl"/>

    <script src="<@url path="/scripts/jquery.tmpl.js"/>" type="text/javascript"></script>
    <link rel="shortcut icon" href="<@url path="/images/favicon.ico"/>"/>

    <!-- Core Bootstrap css + Kickstrap styles -->
<@pack.style>
<#--<src>/custom-css/base-admin-responsive.css</src>-->
    <src>/scripts/select2/select2.css</src>
    <src>/scripts/redactor/redactor.css</src>
    <src>/scripts/tooltipster/css/tooltipster.css</src>
    <src>/scripts/tooltipster/css/themes/tooltipster-shadow.css</src>
    <src>/scripts/prettify/prettify.css</src>
    <src>/scripts/qtip/jquery.qtip.min.css</src>
    <src>/scripts/jquery-ui/css/smoothness/jquery-ui.css</src>
    <src>/scripts/sidr/stylesheets/jquery.sidr.dark.css</src>
    <#if page.properties['page.packCSS']??>
    ${page.properties['page.packCSS']}
    </#if>
</@pack.style>
<@pack.style>
    <src>/less/answerhub.less</src>
</@pack.style>

    <!--[if lt IE 9]>
    <script type="text/javascript">
        $(document).ready(function() {
            var $style;
            $style = $('<style type="text/css">:before,:after{content:none !important}</style>');
            $('head').append($style);
            return setTimeout((function() {
                return $style.remove();
            }), 0);
        });
    </script>
    <![endif]-->

<@teamhub.widgets location="system.head/after" nocontainer=true />

<#if currentSpace??>
    <style type="text/css">
            ${teamhub.getSettingForContainer("space.additionalCss", currentSpace)!""}
        </style>
</#if>

    <script type="text/javascript">
        $(document).ready(function(){pageContext.options.commentsAttachmentsEnabled = ${(teamhub.getSetting("attachments.comment.enable")!false)?string}});
    </script>

${head}
</head>
