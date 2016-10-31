
<div id="post-header">
    <div class="container">
        <div class="row">
            <div class="span8">
            <ul class="nav nav-pills" id="id_nav_container">
            <li class="<#if !currentSpace??>active</#if>"><a class="main-nav" href="<@url name="index" />"><@trans key="thub.subnav.home" /></a></li>
            <#assign printedParent = false/>
            <@listSpaces excludeDefaults=false childrenOpening='<ul class="dropdown-menu">' childrenClosing='</ul></li>'; space, has_role, depth>
                <#if space.name != 'Default'>
                    <li class="<#if space.subSpaces?size &gt; 0>dropdown</#if> <#if currentSpace?? && (currentSpace.name=space.name || currentSpace.parent.name == space.name)>active</#if>">
                        <#if space.subSpaces?size &gt; 0><a href="#"
                                                            class="dropdown-toggle pull-left"
                                                            data-toggle="dropdown">${space.name} <b class="caret"></b>
                        </a>
                            <#if depth != 0>
                                <#if !printedParent>
                                    <#assign printedParent = true/>
                                    <li>
                                        <a href="<@url name="spaces:index" space=space.parent plug="index"/>"><@trans key="thub.subnav.viewSpace" default="View Space"/></a>
                                    </li>
                                </#if>
                                <li class="<#if currentSpace?? && currentSpace.name=space.name>active</#if>">
                                    <a href="<@url name="spaces:index" space=space plug="index"/>">${space.name}</a>
                                </li>
                           <#else>
                               <#assign printedParent = false />
                           </#if>
                    <#else>
                        <a <#if depth=0>class="main-nav"</#if> href="<@url name="spaces:index" space=space plug="index"/>">${space.name}</a>
                    </#if>
                </#if>
            </@listSpaces>
            <#--<li class="dropdown">-->
                <#--<a class="dropdown-toggle"-->
                   <#--data-toggle="dropdown"-->
                   <#--href="#">-->
                    <#--More-->
                    <#--<b class="caret"></b>-->
                <#--</a>-->
                <#--<ul class="dropdown-menu">-->
                    <#--links &ndash;&gt;-->
                <#--</ul>-->
            <#--</li>-->
        </ul>
        </div>
        <div class="span4">
            <a class=" ask-btn btn btn-primary pull-right" href="<@url name="questions:ask"/><#if currentSpace??>?space=${currentSpace}</#if>"><@trans key="thub.label.askAQuestion" /></a>
        </div>
    </div>

</div>

<script>
    $(document).ready(function () {
        var moreText = "<@trans key="label.more" />";
        $("#id_nav_container").find(".dropdown-menu.hover-menu").each(function (i, item) {
            var parent = $(item).parent();
            if (!parent.hasClass("dropdown")) {
                parent.addClass("dropdown");
                dropper = $("<a data-toggle='dropdown'><b class='caret'></b></a>");
                $(parent.find("a")[0]).append(dropper);


            }

        });
        var item_max_menus = 10;
        if ($("a.main-nav").length > item_max_menus) {
            var move_them = new Array();
            for (var itt = item_max_menus; itt < $("a.main-nav").length; itt++) {
                move_them[move_them.length] = $($("a.main-nav")[itt]).parent();
            }

            var new_more = $('<li class="dropdown"><a data-toggle="dropdown">' + moreText + ' <b class="caret"></b></a></a><ul class="dropdown-menu hover-menu"></ul>            </li>');
            $("#id_nav_container").append(new_more);

            for (rm in move_them) {
                try {
                    move_them[rm].remove();

                    new_more.find("ul").append(move_them[rm]);

                    if (move_them[rm].hasClass("dropdown")) {
                        move_them[rm].removeClass("dropdown");
                        move_them[rm].addClass("dropdown-submenu");
                        move_them[rm].find(".caret").remove();

                    }
                }
                catch (err) {
                }
            }
        }
    });
</script>