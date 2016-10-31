<#import "/macros/answerhub.ftl" as answerhub />
<#if canAskToAnswer>

    <#assign question=node />
    <#assign experts = teamHubManager.socialManager.findExpertsForNode(question)/>
    
<head>
    <#assign askToAnswerId=question.id />
    <script type="text/javascript">
            <#assign askedToAnswerCount=teamHubManager.relationManager.countStatesForNode(question, "asked to answer")>
    </script>

</head>

<div class="widget ask-to-answer-widget">
    <div class="widget-header">
        <i class="icon-hand-right"></i>
        <a class="btn btn-success pull-right widget-action" href="#askToAnswerModal" role="button" data-toggle="modal"><i class="icon-bullhorn"></i> <@trans key="thub.label.askToAnswer" /></a>
        <h3><@trans key="thub.questions.askToAnswer.title" /></h3>
    </div>
    <div class="ask-to-answer-container widget-content">
        <p><@trans key="thub.questions.askToAnswer.description" /></p>
        <div id="ask-to-answer-list-${askToAnswerId}" class="ask-to-answer-list"></div>
    </div>
</div>

<div id="askToAnswerModal" class="modal hide fade">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3><@trans key="thub.questions.askToAnswer.modal" default="Ask an Expert To Answer"/></h3>
    </div>
    <div class="modal-body">
        <div class="form-container">
            <input type="hidden" class="askToAnswerUsersInput" id="askToAnswerUsersInput">
            <textarea placeholder="<@trans key="thub.questions.askToAnswer.message" />" class="askToAnswerMessage" rows="4"></textarea>
        </div>
        <#if experts?has_content>
            <div class="expert-list-container" id="ask-to-answer">
                <h4><@trans key="thub.questions.askToAnswer.topicExperts" /></h4>
                <ul class="nav nav-pills  expert-list">
                    <#list experts as expert>
                        <li>
                            <a href="#" data-user-id="${expert.id}">
                                <div>
                                    <#if expert.avatar?has_content>
                                        <@answerhub.avatar expert 20/>
                                    <#else>
                                        <i class="icon-group"></i>
                                    </#if>
                                    <@answerhub.showUserName expert/>
                                </div>
                            </a>
                        </li>
                    </#list>
                </ul>
            </div>
        </#if>

    </div>
    <div class="modal-footer">
        <label class="pull-left checkbox" for="sendMeACopy"><input id="sendMeACopy" type="checkbox"> <@trans key="thub.questions.askToAnswer.sendMeACopy" /></label>
        <a href="#" data-dismiss="modal" class="btn"><@trans key="label.close" /></a>
        <a href="#" class="submit btn btn-primary"><@trans key="label.submit" /></a>
    </div>
</div>



<script type="text/javascript">
	function buildExpertsList(){
		var result = [
		<#list experts as expert>
			{
				"id": "${expert.id}",
				"username":"${expert.username}",
				"avatar":"${expert.avatar}"
			},
		</#list>
		];
		return result;
	}

    $(document).ready(function(){
        var askedCount;
        reloadList();
		var experts = buildExpertsList();
        $("#askToAnswerUsersInput").select2({
            escapeMarkup: function (m) { return m; },
            placeholder: "<@trans key="thub.questions.askToAnswer.users" default="Add user names..."/>",
            minimumInputLength: 1,
            ajax: {
                url: "<@url name="questions:possibleAnswerers.json" />",
                dataType: 'json',
                data: function (term, page) {
                    return {
                        q: term,
                        question: "${node}",
                        includeGroups: true
                    };
                },
                results: function (data, page) {
                    return {results: data.result.users};
                }
            },
            multiple: true,
            tokenSeparators: [","],
            dropdownCssClass: "askToAnswerSearchDropdown",
            formatResult: function (item, container, query){
                var context = {};
                if(item.name){
                    context.name = item.name;
                } else {
                    context.name = pageContext.userRealName && item.realname ? item.realname : item.username;
                }
                context.user = item;
                return commandUtils.renderTemplate("user-search-template",context).html();
            },
            formatSelection: function(item,container) {
                var context = {};
                if(item.name){
                    context.name = item.name;
                } else {
                    context.name = pageContext.userRealName && item.realname ? item.realname : item.username;
                }
                context.user = item;
                return commandUtils.renderTemplate("user-search-template",context).html();
            },
            initSelection : function (element, callback) {
                var data = [];
                $(element.val().split(",")).each(function () {
                    data.push({id: this, text: this});
                });
                callback(data);
            }
        });
        
        if(experts.length > 0) {
	        $("#askToAnswerModal").on("change", function(event){
	    		if(event.added){
	    			var userId = event.added.id;
	    			var selectedNodeExpr = "[data-user-id='"+userId+"']";
	    			$(".expert-list "+selectedNodeExpr).parent("li").toggleClass("active");
	    		}
	    		else if(event.removed){  			
	    			var userId = event.removed.id;
	        		var selectedNodeExpr = "[data-user-id='"+userId+"']";
	        		$(".expert-list "+selectedNodeExpr).parent("li").toggleClass("active");
	    		}
	    	});
    	}
        
        $("#askToAnswerModal").on("shown", function(){
            $("#askToAnswerModal").appendTo($(document.body));
            $("#askToAnswerUsersInput").val("");
            $("#askToAnswerUsersInput").change();
            
            if(experts.length > 0) {
	        	$(".expert-list").find("a").click(function(event){
	        		//Toggle logic
	        		if($(this).parent("li").hasClass('active')) {
	        			//This is what happens when we deselect user from the experts list
	        			var data = $("#askToAnswerUsersInput").select2("data");
	        			//Remove user from select2 element list
	        			var userId = $(this).attr("data-user-id");
	        			data = $.grep(data, function(value) {
						  return value.id != userId;
						});
	        			$("#askToAnswerUsersInput").select2("data",data);
	        		}
	        		else {
	        			//This is what happens when we select user from the experts list
						var userId = $(this).attr("data-user-id");
						var user = $.grep(experts, function(value) {
						  return value.id == userId;
						});
						var data = $("#askToAnswerUsersInput").select2("data");
						data.push(user[0]);
		        		$("#askToAnswerUsersInput").select2("data",data);
	        		}
	        		//Toggle class
	        		$(this).parent("li").toggleClass('active');
	        	});
        	}
            
            $(this).find(".submit").click(function(e){
                e.preventDefault();
                $.ajax({
                    url: "<@url name="questions:advancedAskToAnswer.json" question=node />",
                    data: {
                        askedToAnswer: $("#askToAnswerUsersInput").val().split(","),
                        message: $(".askToAnswerMessage").val().trim(),
                        sendMeACopy: typeof $("#sendMeACopy").attr("checked") !== 'undefined' && $("#sendMeACopy").attr("checked") !== false
                    },
                    dataType: "json",
                    success: function(data){
                        if(data.error){
                            $("#askToAnswerModal").find(".alert").remove();
                            $("#askToAnswerModal").find(".modal-body").prepend("<div class='alert alert-error'>" + data.error + "</div>");
                            return;
                        }
                        if(!askedCount || data.askToAnswerCount != askedCount){
                            reloadList();
                            askedCount = data.askToAnswerCount;
                        }
                        $(".ask-to-answer-container .alert-success").hide();
                        $(".ask-to-answer-container").prepend($("#ask-to-answer-success").html());
                        $("#askToAnswerModal").modal("hide");
                    },
                    type: "POST"
                })
            });
        });

        $("#askToAnswerModal").on("hide", function(){
            cleanUpAskToAnswerModal();
        });

        var cleanUpAskToAnswerModal = function(){
            $("#askToAnswerModal").find(".alert").remove();
            $("#askToAnswerModal").find(".active").removeClass('active');
            $(".askToAnswerMessage").val("");
            $("#sendMeACopy").removeAttr("checked");
            $("#askToAnswerUsersInput").val("");
            $("#askToAnswerUsersInput").change();
            $("#askToAnswerModal").find(".submit").unbind("click");
        }

    });

    var reloadList = function() {
        $.ajax({
            url : "<@url name="questions:askedToAnswerList" question=question />?unstyled=true",
            dataType : 'html',
            success : function(data) {
                $("div.ask-to-answer-list").each(function() {
                    $list = $(this);
                    $list.empty().html(data);
                    $list.find("a[id*=ask-to-answer-user-remove-link]").each(function() {
                        $(this).click(function() {
                            user = $(this).attr("id").replace("ask-to-answer-user-remove-link-", "");
                            _askToAnswer.removeAsk(user);
                        });
                    });
                });
            }
        });
    };

    var removeAsk = function(user) {
        $.ajax({
            url : "<@url name="questions:removeAskToAnswer.json" askedToAnswer="{askedToAnswer}" question="${question.id}" />".replace("%7BaskedToAnswer%7D", user),
            type : 'POST',
            dataType : 'json',
            success : function(data) {
                reloadList();
            }
        });
    };
</script>

<script type="text/x-jquery-tmpl" id="user-search-template">
    <#--div is there so we can use .html and get what we need from the template-->
    <#noparse>
    <div>
        {{if user.avatar}}<img class="gravatar" src="${user.avatar}">{{else}}<i class="icon-group"></i>{{/if}} ${name}
    </div>
    </#noparse>
</script>
<div class="hidden" id="ask-to-answer-success">
    <div class="alert alert-success">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <strong><@trans key="thub.label.success" default="Success!"/></strong> <@trans key="thub.questions.askToAnswer.success" />
    </div>
</div>
</#if>
