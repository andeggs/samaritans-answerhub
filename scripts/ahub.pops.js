// Popup for topics
// To identify a "topic" set data-role="topic" in every <a>

function createTopicPopOver(el){
        var $cur = $(el);
        $(el).qtip({
            style: {
                classes: 'qtip-bootstrap topic'
            },
            content: {
                text: '<i class="icon-spinner icon-spin icon-2x"></i>',
                ajax: {
                    url: pageContext.url.viewTopicJSON.replace("%7Btopic%7D",$(el).attr("nodeId")),
                    cache: false,
                    type: 'GET',
                    dataType: 'json',
                    success: function(data) {
                        data.result.topic.icon = pageContext.url.topicIcon.replace("%7Btopic%7D", data.result.topic.id);
                        data.result.topic.url = pageContext.url.topic.replace("%7Btopic%7D", data.result.topic.name);
                        this.set('content.text', commandUtils.renderTemplate("topic-popover",data.result));
                        commandUtils.initializeLabels();
                        $cur.removeAttr("title");
                        $cur.find("img").removeAttr("title");
                    }
                }
            },
            hide: {
                delay: 200,
                fixed: true//,
//                event: 'click' //use this when playing with css
            },
            position: {
                viewport: $(window),
                adjust: {
                    method: 'shift flip'
                },
                corner: {
                    target: 'center'
                }
            },
            show: {
                delay: 500
            }
        });
    }

function createAwardPopOver(el){
	var $cur = $(el);
    $(el).qtip({
        style: {
            classes: 'qtip-bootstrap award'
        },
        content: {
            text: '<i class="icon-spinner icon-spin icon-2x"></i>',
            ajax: {
                url: pageContext.url.awardListUrl.replace("%7BawardType%7D",$(el).attr("awardType")).replace("%7Bdesc%7D",$(el).attr("desc")).concat("?pageSize=5"),
                cache: false,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                	data.awardType.awardIconSrc = $cur.attr("awardIconSrc");
                	data.awardType.awardUrl = pageContext.url.awardListUrl.replace("%7BawardType%7D",$cur.attr("awardType")).replace("%7Bdesc%7D",$(el).attr("desc")).replace("json","html")
//                	console.log(data.awardPager.list);
                    for(i in data.awardPager.list){
                        data.awardPager.list[i].user = {};
                		data.awardPager.list[i].user.profileUrl = pageContext.url.profile.replace("{id}",data.awardPager.list[i].userid).replace("{plug}",data.awardPager.list[i].userplug);
                		data.awardPager.list[i].user.username = data.awardPager.list[i].username;
                		data.awardPager.list[i].user.avatar = pageContext.url.userAvatar.replace("%7BuserId%7D",data.awardPager.list[i].userid);
                        _data = data;
                		/*$.ajax({
                            url: pageContext.url.condensedProfileUrl.replace("%7Buser%7D",data.awardPager.list[i].id),
                            cache: false,
                            dataType: 'json',
                            type: 'GET',
                            async: false,
                            success: function(data) {
                                _data.awardPager.list[i].avatar = data.profileUser.avatar;
                            }
                    	});*/
                	}
                    this.set('content.text', commandUtils.renderTemplate("badge-popover",data));
                }
            }
        },
        hide: {
            delay: 200,
            fixed: true
            //event: 'click' //use this when playing with css
        },
        position: {
            viewport: $(window),
            adjust: {	
                method: 'flip flip'
            },
            corner: {
                target: 'center'
            }
        },
        show: {
            delay: 500,
        }
    });
}

function createUserPopOver(el){
    var $cur = $(el);
    $(el).qtip({
        style: {
            classes: 'qtip-bootstrap user'
        },
        content: {
            text: '<i class="icon-spinner icon-spin icon-2x"></i>',
            ajax: {
                url: pageContext.url.condensedProfileUrl.replace("%7Buser%7D",$(el).attr("nodeId")),
                cache: false,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    data.profileUser.displayName = (pageContext.userRealName && data.profileUser.realname)? data.profileUser.realname : data.profileUser.username;
                    data.profileUser.profileUrl = pageContext.url.profile.replace('{id}',data.profileUser.id).replace('{plug}',data.profileUser.plug);
                    data.profileUser.creationDateObj = new Date(data.profileUser.creationDate);
                    this.set('content.text', commandUtils.renderTemplate("user-popover",data));
                    commandUtils.initializeLabels();
                    $cur.removeAttr("title");
                    $cur.find("img").removeAttr("title");
                }
            }
        },
        hide: {
            delay: 200,
            fixed: true//,
//            event: 'click' //use this when playing with css
        },
        position: {
            viewport: $(window),
            adjust: {
                method: 'shift flip'
            },
            corner: {
                target: 'center'
            }
        },
        show: {
            delay: 500
        }
    });
}

$(function(){
    // getting all the objects
	$(document).ready(function(){
		$("[rel=user]").each(function(){
			createUserPopOver($(this));
		});
		$("[rel=award]").each(function(){
			createAwardPopOver($(this));
		});
		$("[rel=topic]").each(function(){
			createTopicPopOver($(this));
		});
	});
});