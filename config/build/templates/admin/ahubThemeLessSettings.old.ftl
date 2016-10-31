<#import "/spring.ftl" as spring/>
<#--<content tag="breadcrumbs">-->
    <#--<li><a href="<@url name="admin:index"/>">Dashboard</a></li>-->
<#--</content>-->
<html>
<head>
    <title>Theme Configuration</title>

    <style type="text/css">
        .settingsBlock{
            float:left;
            clear:none;
            width:100%;
        }

        .settingsBlockHeader{
            height: 40px;
            line-height: 40px;
            background: #EFEFEF;
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #FAFAFA), color-stop(100%, #EFEFEF));
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#fafafa, endColorstr={@widgetHeaderBackground});
            -ms-filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#efefef, endColorstr=#efefef);
            border: 1px solid #D5D5D5;
            -webkit-border-top-left-radius: 4px;
            -webkit-border-top-right-radius: 4px;
            -moz-border-radius-topleft: 4px;
            -moz-border-radius-topright: 4px;
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
            -webkit-background-clip: padding-box;
        }

        .settingsBlockHeader h2{
            position: relative;
            top: 2px;
            left: 10px;
            display: inline-block;
            margin-right: 3em;
            font-size: 14px;
            font-weight: 800;
            color: #555;
            line-height: 18px;
            text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.5);
        }

        .settingsBlockSection{
            padding: 20px 15px 15px;
            background: white;
            border: 1px solid #D5D5D5;
            -moz-border-radius: 0 0 5px 5px;
            -webkit-border-radius: 0 0 5px 5px;
            border-radius: 0 0 5px 5px;
        }

        .settingsBlockSectionHeader{
            clear:both;
            width:100%;
            float:left;
        }

        .settingsBlockSectionHeader h3{
            float:left;
        }

        .settingsBlockSectionHeader .more, .settingsBlockSectionHeader .less{
            float:right;
        }

        .settingsBlockSectionHeader .less{
            display:none
        }

        .settingsBlockSectionBody{
            display:none;
        }

        .settingsContainerRight{
            width:333px;
            float:right;
            clear:none;
        }
        .settingsContainerLeft{
            float:left;
            width:333px;
            margin-right: 5px;
            clear:none;
        }
    </style>

        <script type="text/javascript">
         $(document).ready(function() {
            $(".more").click(function(){
                $(this).parent().parent().find(".settingsBlockSectionBody").slideToggle();
                $(this).hide();
                $(this).siblings(".less").show();
            });

            $(".less").click(function(){
                $(this).parent().parent().find(".settingsBlockSectionBody").slideToggle();
                $(this).hide();
                $(this).siblings(".more").show();
            });
        });
    </script>​
</head>

<body>
<#include "/admin/site/sidebar.ftl"/>

<#if flash?? && flash['success']??>
<div class="successBox">${flash['success']}</div>
</#if>

<h1>Theme Configuration</h1>

<div class="standardForm">
<@spring.bind 'form.*' />

<#if error??>
    <div class="errorBox">${error}</div>
</#if>

    <form name="settingsForm" action="" method="POST">
        <input type="hidden" name="submit" value="true"/>

        <div class="settingsContainerLeft">
            <div class="settingsBlock">
                <div class="settingsBlockHeader">
                    <h2>Base Colors</h2>
                </div>
                <div class="settingsBlockSection">
                    <#--grays-->
                    <div class="settingsBlockSectionContainer">
                        <div class="settingsBlockSectionHeader">
                            <h3>Grays</h3><span class="more">+</span><span class="less">-</span>
                        </div>
                        <hr/>
                        <div class="settingsBlockSectionBody">
                            <label for="black">black</label>
                            <@spring.formInput 'form.black' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="greyDarker">greyDarker</label>
                            <@spring.formInput 'form.greyDarker' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="grayDark">grayDark</label>
                            <@spring.formInput 'form.grayDark' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="gray">gray</label>
                            <@spring.formInput 'form.gray' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="grayLight">grayLight</label>
                            <@spring.formInput 'form.grayLight' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="grayLighter">grayLighter</label>
                            <@spring.formInput 'form.grayLighter' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="white">white</label>
                            <@spring.formInput 'form.white' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />
                        </div>
                    </div>

                    <#--accent colors-->
                    <div class="settingsBlockSectionContainer">
                        <div class="settingsBlockSectionHeader">
                            <h3>Accent Colors</h3><span class="more">+</span><span class="less">-</span>
                        </div>
                        <hr/>
                        <div class="settingsBlockSectionBody">
                            <label for="blue">blue</label>
                            <@spring.formInput 'form.blue' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="blueDark">blueDark</label>
                            <@spring.formInput 'form.blueDark' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="green">green</label>
                            <@spring.formInput 'form.green' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="red">red</label>
                            <@spring.formInput 'form.red' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="yellow">yellow</label>
                            <@spring.formInput 'form.yellow' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="orange">orange</label>
                            <@spring.formInput 'form.orange' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="pink">pink</label>
                            <@spring.formInput 'form.pink' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />

                            <label for="purple">purple</label>
                            <@spring.formInput 'form.purple' 'class="color{hash:true,adjust:false}"' /><br/>
                            <@spring.showErrors '',  'formError' />
                        </div>
                    </div>
                </div>
            </div>

            <#--text-->
            <div class="settingsBlock">
                <label for="bodyBackground">bodyBackground</label>
                <@spring.formInput 'form.bodyBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="textColor">textColor</label>
                <@spring.formInput 'form.textColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="linkColor">linkColor</label>
                <@spring.formInput 'form.linkColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="linkColorHover">linkColorHover</label>
                <@spring.formInput 'form.linkColorHover' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="sansFontFamily">sansFontFamily</label>
                <@spring.formInput 'form.sansFontFamily' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="serifFontFamily">serifFontFamily</label>
                <@spring.formInput 'form.serifFontFamily' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="monoFontFamily">monoFontFamily</label>
                <@spring.formInput 'form.monoFontFamily' '' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="baseFontSize">baseFontSize</label>
                <@spring.formInput 'form.baseFontSize' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="baseFontFamily">baseFontFamily</label>
                <@spring.formInput 'form.baseFontFamily' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="baseLineHeight">baseLineHeight</label>
                <@spring.formInput 'form.baseLineHeight' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="altFontFamily">altFontFamily</label>
                <@spring.formInput 'form.altFontFamily' '' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="headingsFontFamily">headingsFontFamily</label>
                <@spring.formInput 'form.headingsFontFamily' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="headingsFontWeight">headingsFontWeight</label>
                <@spring.formInput 'form.headingsFontWeight' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="headingsColor">headingsColor</label>
                <@spring.formInput 'form.headingsColor' '' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--tables-->
            <div class="settingsBlock">
                <!--Tables-->
                <label for="tableHeaderBackground">tableHeaderBackground</label>
                <@spring.formInput 'form.tableHeaderBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="tableHeaderBackgroundHighlight">tableHeaderBackgroundHighlight</label>
                <@spring.formInput 'form.tableHeaderBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="tableHeaderColor">tableHeaderColor</label>
                <@spring.formInput 'form.tableHeaderColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="tableBackground">tableBackground</label>
                <@spring.formInput 'form.tableBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="tableBackgroundAccent">tableBackgroundAccent</label>
                <@spring.formInput 'form.tableBackgroundAccent' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="tableBackgroundHover">tableBackgroundHover</label>
                <@spring.formInput 'form.tableBackgroundHover' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="tableBorder">tableBorder</label>
                <@spring.formInput 'form.tableBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--buttons-->
            <div class="settingsBlock">
                <label for="btnBackground">btnBackground</label>
                <@spring.formInput 'form.btnBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnBackgroundHighlight">btnBackgroundHighlight</label>
                <@spring.formInput 'form.btnBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnBorder">btnBorder</label>
                <@spring.formInput 'form.btnBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="btnPrimaryBackground">btnPrimaryBackground</label>
                <@spring.formInput 'form.btnPrimaryBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnPrimaryBackgroundHighlight">btnPrimaryBackgroundHighlight</label>
                <@spring.formInput 'form.btnPrimaryBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="btnInfoBackground">btnInfoBackground</label>
                <@spring.formInput 'form.btnInfoBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnInfoBackgroundHighlight">btnInfoBackgroundHighlight</label>
                <@spring.formInput 'form.btnInfoBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="btnSuccessBackground">btnSuccessBackground</label>
                <@spring.formInput 'form.btnSuccessBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnSuccessBackgroundHighlight">btnSuccessBackgroundHighlight</label>
                <@spring.formInput 'form.btnSuccessBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="btnWarningBackground">btnWarningBackground</label>
                <@spring.formInput 'form.btnWarningBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnWarningBackgroundHighlight">btnWarningBackgroundHighlight</label>
                <@spring.formInput 'form.btnWarningBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="btnDangerBackground">btnDangerBackground</label>
                <@spring.formInput 'form.btnDangerBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnDangerBachgroundHighlight">btnDangerBachgroundHighlight</label>
                <@spring.formInput 'form.btnDangerBachgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="btnInverseBackground">btnInverseBackground</label>
                <@spring.formInput 'form.btnInverseBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="btnInverseBackgroundHighlight">btnInverseBackgroundHighlight</label>
                <@spring.formInput 'form.btnInverseBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>
        </div>


        <div class="settingsContainerRight">
            <#--inputs-->
            <div class="settingsBlock">
                <label for="inputBackground">inputBackground</label>
                <@spring.formInput 'form.inputBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="inputBorder">inputBorder</label>
                <@spring.formInput 'form.inputBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="inputBorderRadius">inputBorderRadius</label>
                <@spring.formInput 'form.inputBorderRadius' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="inputDisabledBackground">inputDisabledBackground</label>
                <@spring.formInput 'form.inputDisabledBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="formActionsBackground">formActionsBackground</label>
                <@spring.formInput 'form.formActionsBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="placeholderText">placeholderText</label>
                <@spring.formInput 'form.placeholderText' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--dropdowns-->
            <div class="settingsBlock">
                <label for="dropdownBackground">dropdownBackground</label>
                <@spring.formInput 'form.dropdownBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="dropdownBorder">dropdownBorder</label>
                <@spring.formInput 'form.dropdownBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="dropdownLinkColor">dropdownLinkColor</label>
                <@spring.formInput 'form.dropdownLinkColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="dropdownLinkColorHover">dropdownLinkColorHover</label>
                <@spring.formInput 'form.dropdownLinkColorHover' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="dropdownLinkBackgroundHover">dropdownLinkBackgroundHover</label>
                <@spring.formInput 'form.dropdownLinkBackgroundHover' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--zindices-->
            <div class="settingsBlock">
                <label for="zindexDropdown">zindexDropdown</label>
                <@spring.formInput 'form.zindexDropdown' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="zindexPopover">zindexPopover</label>
                <@spring.formInput 'form.zindexPopover' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="zindexTooltip">zindexTooltip</label>
                <@spring.formInput 'form.zindexTooltip' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="zindexFixedNavbar">zindexFixedNavbar</label>
                <@spring.formInput 'form.zindexFixedNavbar' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="zindexModelBackdrop">zindexModelBackdrop</label>
                <@spring.formInput 'form.zindexModelBackdrop' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="zindexModel">zindexModel</label>
                <@spring.formInput 'form.zindexModel' '' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--icons-->
            <div class="settingsBlock">
                <label for="iconSpritePath">iconSpritePath</label>
                <@spring.formInput 'form.iconSpritePath' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="iconWhiteSpritePath">iconWhiteSpritePath</label>
                <@spring.formInput 'form.iconWhiteSpritePath' '' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--navbar-->
            <div class="settingsBlock">
                <label for="navbarHeight">navbarHeight</label>
                <@spring.formInput 'form.navbarHeight' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarBackground">navbarBackground</label>
                <@spring.formInput 'form.navbarBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarBackgroundHighlight">navbarBackgroundHighlight</label>
                <@spring.formInput 'form.navbarBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="navbarText">navbarText</label>
                <@spring.formInput 'form.navbarText' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarLinkColor">navbarLinkColor</label>
                <@spring.formInput 'form.navbarLinkColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarLinkColorHover">navbarLinkColorHover</label>
                <@spring.formInput 'form.navbarLinkColorHover' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarLinkColorActive">navbarLinkColorActive</label>
                <@spring.formInput 'form.navbarLinkColorActive' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarLinkBackgroundHover">navbarLinkBackgroundHover</label>
                <@spring.formInput 'form.navbarLinkBackgroundHover' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarLinkBackgroundActive">navbarLinkBackgroundActive</label>
                <@spring.formInput 'form.navbarLinkBackgroundActive' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="navbarSearchBackground">navbarSearchBackground</label>
                <@spring.formInput 'form.navbarSearchBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarSearchBackgroundFocus">navbarSearchBackgroundFocus</label>
                <@spring.formInput 'form.navbarSearchBackgroundFocus' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarSearchBorder">navbarSearchBorder</label>
                <@spring.formInput 'form.navbarSearchBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarSearchPlaceholderColor">navbarSearchPlaceholderColor</label>
                <@spring.formInput 'form.navbarSearchPlaceholderColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="navbarBrandColor">navbarBrandColor</label>
                <@spring.formInput 'form.navbarBrandColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--hero unit-->
            <div class="settingsBlock">
                <label for="heroUnitBackground">heroUnitBackground</label>
                <@spring.formInput 'form.heroUnitBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="heroUnitHeadingColor">heroUnitHeadingColor</label>
                <@spring.formInput 'form.heroUnitHeadingColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="heroUnitLeadColor">heroUnitLeadColor</label>
                <@spring.formInput 'form.heroUnitLeadColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--messages-->
            <div class="settingsBlock">
                <label for="warningText">warningText</label>
                <@spring.formInput 'form.warningText' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="warningBackground">warningBackground</label>
                <@spring.formInput 'form.warningBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="warningBorder">warningBorder</label>
                <@spring.formInput 'form.warningBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="errorText">errorText</label>
                <@spring.formInput 'form.errorText' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="errorBackground">errorBackground</label>
                <@spring.formInput 'form.errorBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="errorBorder">errorBorder</label>
                <@spring.formInput 'form.errorBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="successText">successText</label>
                <@spring.formInput 'form.successText' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="successBackground">successBackground</label>
                <@spring.formInput 'form.successBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="successBorder">successBorder</label>
                <@spring.formInput 'form.successBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="infoText">infoText</label>
                <@spring.formInput 'form.infoText' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="infoBackground">infoBackground</label>
                <@spring.formInput 'form.infoBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="infoBorder">infoBorder</label>
                <@spring.formInput 'form.infoBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--grid settings-->
            <div class="settingsBlock">
                <label for="gridColumns">gridColumns</label>
                <@spring.formInput 'form.gridColumns' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="gridColumnsWidth">gridColumnsWidth</label>
                <@spring.formInput 'form.gridColumnsWidth' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="gridGutterWidth">gridGutterWidth</label>
                <@spring.formInput 'form.gridGutterWidth' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="gridRowWidth">gridRowWidth</label>
                <@spring.formInput 'form.gridRowWidth' '' /><br/>
                <@spring.showErrors '',  'formError' />


                <label for="fluidGridColumnWidth">fluidGridColumnWidth</label>
                <@spring.formInput 'form.fluidGridColumnWidth' '' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="fluidGridGutterWidth">fluidGridGutterWidth</label>
                <@spring.formInput 'form.fluidGridGutterWidth' '' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--tags-->
            <div class="settingsBlock">
                <label for="tagBackground">tagBackground</label>
                <@spring.formInput 'form.tagBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="tagBackgroundHover">tagBackgroundHover</label>
                <@spring.formInput 'form.tagBackgroundHover' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>


            <!--ahub settings-->

            <!--post-header-->
            <div class="settingsBlock">
                <label for="postHeaderBackground">postHeaderBackground</label>
                <@spring.formInput 'form.postHeaderBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>


            <!--extra-section-->
            <div class="settingsBlock">
                <label for="extraBackground">extraBackground</label>
                <@spring.formInput 'form.extraBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="extraColor">extraColor</label>
                <@spring.formInput 'form.extraColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="extraLinkColor">extraLinkColor</label>
                <@spring.formInput 'form.extraLinkColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>


            <!--footer-->
            <div class="settingsBlock">
                <label for="footerLinkColor">footerLinkColor</label>
                <@spring.formInput 'form.footerLinkColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="footerColor">footerColor</label>
                <@spring.formInput 'form.footerColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="footerBackground">footerBackground</label>
                <@spring.formInput 'form.footerBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>


            <!--widgets-->
            <div class="settingsBlock">
                <label for="widgetHeaderBackground">widgetHeaderBackground</label>
                <@spring.formInput 'form.widgetHeaderBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="widgetHeaderBackgroundHighlight">widgetHeaderBackgroundHighlight</label>
                <@spring.formInput 'form.widgetHeaderBackgroundHighlight' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="widgetHeaderBorder">widgetHeaderBorder</label>
                <@spring.formInput 'form.widgetHeaderBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="widgetHeaderColor">widgetHeaderColor</label>
                <@spring.formInput 'form.widgetHeaderColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="widgetHeaderIconColor">widgetHeaderIconColor</label>
                <@spring.formInput 'form.widgetHeaderIconColor' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="widgetBorder">widgetBorder</label>
                <@spring.formInput 'form.widgetBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="widgetContentBackground">widgetContentBackground</label>
                <@spring.formInput 'form.widgetContentBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>


            <!--Login/register-->
            <div class="settingsBlock">
                <label for="accountContainerBackground">accountContainerBackground</label>
                <@spring.formInput 'form.accountContainerBackground' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="accountContainerBorder">accountContainerBorder</label>
                <@spring.formInput 'form.accountContainerBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="accountContainerH1Color">accountContainerH1Color</label>
                <@spring.formInput 'form.accountContainerH1Color' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />

                <label for="registerH1">registerH1</label>
                <@spring.formInput 'form.registerH1' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>

            <#--misc-->
            <div class="settingsBlock">
                <label for="hrBorder">hrBorder</label>
                <@spring.formInput 'form.hrBorder' 'class="color{hash:true,adjust:false}"' /><br/>
                <@spring.showErrors '',  'formError' />
            </div>
        </div>

        <input value="Save" style="float:left; clear:both" type="submit" />

    </form>
</div>
</body>
</html>