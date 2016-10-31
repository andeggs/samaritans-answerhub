<#import "/spring.ftl" as spring />
<#import "/macros/teamhub.ftl" as teamhub />

<style type="text/css" xmlns="http://www.w3.org/1999/html">
    .expert-topics-panel.no-topics .with-topics {
        display: none;
    }

    .expert-topics-panel.with-topics .no-topics {
        display: none;
    }
</style>


<#macro expertTopicsPanel title noTopicsText withTopicsText containerId activeTopics topicsList isManualActive=false>

<div class="expert-topics-panel <#if topicsList?size == 0>no-topics<#else>with-topics</#if>">

<h4>${title}:</h4>

    <p class="no-topics"><small>${noTopicsText} <#if isManualActive><@trans key="thub.users.includes.pref_expertise.manual.addNew" default="Use the below search field to add topics." /></#if></small></p>
    <p class="with-topics"><small>${withTopicsText} <#if isManualActive><@trans key="thub.users.includes.pref_expertise.manual.addNew" default="Use the below search field to add topics." /></#if></small></p>
    <#if isManualActive>
	   	<script>
		    var jsonTopicSearch = '<@url name="topicsSearch.json" />';
		    <#--var retagUrl = '<@url name="commands:editQuestionTopics" question=question />';-->
		
		    function submit_retag(topicId,operation) {
		        $.post(commands.expertTopic.urls.click.replace('%25ID%25', '${profileUser.id}'),
		        {
		            topic: topicId,
		            operation: operation
		        }, function(data) {
		            
		        });
		    }
		    
		    function setup_retag() {
		        $("#topics_retag_container").css("display", "inline");
		        $("#id_tags_container").hide();
		        $("#topics_retag").select2({
		            placeholder: "<@trans key="thub.ask.topics.placeholder" default="Enter topics..."/>",
		            minimumInputLength: 1,
		            width: "250px",
		            ajax: {
		                url: jsonTopicSearch,
		                dataType: 'json',
		                data: function (term, page) {
		                    return {
		                        q: term
		                    };
		                },
		                results: function (data, page) {
		                    for (var i = 0; i < data.topics.length; i++) {
		                        data.topics[i].text = data.topics[i].name;
		                        data.topics[i].id = data.topics[i].id;
		                    }
		                    return {results: data.topics};
		                }
		            },
		            tokenSeparators: [","],
		            tags: true,
		            createSearchChoice: function() { return null; },
                    formatResult: function (item, container, query, escapeMarkup){
                        return escapeMarkup(item.text);
                    },
                    formatSelection: function(item,container, escapeMarkup) {
                        return escapeMarkup(item.text);
                    },
		            initSelection: function (element, callback) {
		                var data = [];
		                <#list topicsList as topic>
		                	data.push({id: ${topic.id}, text: '${topic.name}'});
		                </#list>
		                callback(data);
		            }
		        });
				$("#topics_retag").on("change", function(e) {
					if(e.added){
//						console.log(e);
						submit_retag(e.added.id,'add');
					}
					if(e.removed){
//						console.log(e);
						submit_retag(e.removed.id,'remove');
					}
					})
			    }
		    $(document).ready(function () {
		        setup_retag();
		    });
		</script>
	    <p>
	        <form id="topics_retag_container" action="#" onsubmit="return submit_retag(this);">
	            <input type="text" id="topics_retag" name="topics" value="<#list topicsList as topic>${topic.name}<#if topic_has_next>,</#if></#list>"/>
	        </form>
	    </p>
    </#if>
    <#if !isManualActive>
	    <div id="${containerId}">
	        <#list topicsList as topic>
	            <p class="expert-topic-container" nodeId="${profileUser.id}">
	        <span class="tags" style="display: inline; margin-right: 50px;">
	            <a rel="tag" title="<@trans key="thub.user.includes.user_topics.question.topics" default="see other questions under the topic of" /> '${topic.name}' " href="<@url name="questions:topics" topics=topic.name/>">${topic.name}</a>
	            <span class="tag-number">&#215; ${topic.usedCount}</span>
	        </span>
	                <a href="#" command="expertTopic" data-operation="<#if activeTopics>remove<#else>add</#if>" data-topic="${topic.id}" <#if activeTopics>class="on"</#if>></a>
	            </p>
	        </#list>
	    </div>
    </#if>
</div>

</#macro>

<div class="tab-pane" id="expertisePanel">
	<@expertTopicsPanel
    trans("thub.users.includes.pref_expertise.auto.active", "Currently Matched topics")
    trans("thub.users.includes.pref_expertise.auto.active.none", "Currently, no topics have been automatically matched.")
    trans("thub.users.includes.pref_expertise.auto.active.help", "These are the topics the system currently thinks you're an expert on.")
    "auto-expert-topics" true expertTopics.autoActive />

<br />

<@expertTopicsPanel
    trans("thub.users.includes.pref_expertise.manual.active", "Manually added topics")
    trans("thub.users.includes.pref_expertise.manual.active.none", "There are no manually added topics.")
    trans("thub.users.includes.pref_expertise.manual.active.help", "These are the topics you manually added to your skills.")
    "manual-expert-topics" true expertTopics.manualActive true />
</div>

