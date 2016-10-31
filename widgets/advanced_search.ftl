<#import "/macros/thub.ftl" as teamhub />

<script type="text/javascript">
    $('document').ready(function(){
        $('.select2-choices').on("click", function(){
            $this.removeAtr('placeholder');
        });
    });
    var listableTypes = [];
	<#list cTypes.listableTypes as type>
	listableTypes.push('${type.simpleName}');
	</#list>
</script>
<div class="widget advanced-search-widget">
    <div class="widget-header">
        <h3><@trans key="thub.widgets.advancedSearch.header" /></h3>
    </div>
    <div class="widget-body">
        <form>
            <fieldset>
                <#--<label>Sort by</label>-->
                <#--<div class="btn-group search-sort-links">-->
                    <#--<a href="#"  data-search-sort="relevance" class="btn"><@trans key="node.sort.relevance" /></a>-->
                    <#--<a href="#"  data-search-sort="newest" class="btn"><@trans key="node.sort.newest" /></a>-->
                <#--</div>-->
                <label><@trans key="thub.widgets.advancedSearch.field.posted" /></label>
                <select class="search-date-select">
                    <#list dateSelections as ds>
                        <#if selectedItem??>
                            <#if selectedItem == ds[0]>
                                <option value="${ds[0]}" selected><@trans key="${ds[1]}" /></option>
                            <#else>
                                <option value="${ds[0]}"><@trans key="${ds[1]}" /></option>
                            </#if>
                        <#else>
                            <option value="${ds[0]}"><@trans key="${ds[1]}" /></option>
                        </#if>
                    </#list>
                </select>

                <div class="search-dates" style="display:none;">
                    <label><@trans key="thub.widgets.advancedSearch.field.posted.custom.start" /></label>
                    <input type="text" placeholder="<@trans key="thub.widgets.advancedSearch.field.posted.custom.placeholder" />" class="search-datepicker search-start">
                    <label><@trans key="thub.widgets.advancedSearch.field.posted.custom.end" /></label>
                    <input type="text" placeholder="<@trans key="thub.widgets.advancedSearch.field.posted.custom.placeholder" />" class="search-datepicker search-end">
                </div>
                <label><@trans key="thub.widgets.advancedSearch.field.author" /></label>
                <input id="author-input" type="hidden" placeholder="<@trans key="thub.widgets.advancedSearch.field.author.placeholder" />" />
                <ul class="suggested-users"><#if searchResults?? && searchResults.topAuthors?? && searchResults.topAuthors?size &gt; 1><#list searchResults.topAuthors as item>
                    <li><a href="javascript:void(0)"><span class="username">${item.value1.username}</span> (${item.value2})</a></li>
                </#list></#if></ul>
                <label><@trans key="thub.widgets.advancedSearch.field.topics" /></label>
                <input id="topic-input" type="hidden" placeholder="<@trans key="thub.widgets.advancedSearch.field.topics.placeholder" />" />
                <#assign listableTypes = cTypes.listableTypes>
                <#if listableTypes?size &gt; 1>
                <label><@trans key="thub.widgets.advancedSearch.field.types" /></label>
                <div class="btn-group search-type-links">
                <#list cTypes.listableTypes as type>
                <a href="javascript:void(0);" data-search-type="${type.simpleName}" class="btn"><@trans key=".label.${type.simpleName}s" /></a>
                </#list>
                </div>
                </#if>
                <div class="actions">
                    <a href="javascript:void(0);" type="submit" class="btn btn-search"><@trans key="thub.widgets.advancedSearch.submitButton" default="Submit" /></a>
                </div>
            </fieldset>
        </form>
    </div>
</div>

<script type="text/x-jquery-tmpl" id="user-search-template">
<#--div is there so we can use .html and get what we need from the template-->
<#noparse>
    <div>
        <img class="gravatar" src="${user.avatar}"> ${name}
    </div>
</#noparse>
</script>