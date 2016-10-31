$(document).ready(function(){


    $("#space_select").select2({
        placeholder: "Select a space"
    });

    var select2Options = {
        selectOnBlur: true,
        placeholder: "Enter topics...",
        minimumInputLength: 1,
        maximumSelectionSize: pageContext.options.maxTopics,
        ajax: {
            url: jsonTopicSearch,
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term
                };
            },
            results: function (data, page) {
                for (var i = 0; i<data.topics.length; i++){
                    data.topics[i].text = data.topics[i].name;
                    data.topics[i].id = data.topics[i].name;
                }
                return {results: data.topics};
            }
        },
        minimumInputLength: 1,
        tokenSeparators: [","],
        tags:true,
        createSearchChoice: function(term){
            return {id: term, text: term};
        },
        formatResult: function (item, container, query, escapeMarkup){
            return escapeMarkup(item.text);
        },
        formatSelection: function(item,container, escapeMarkup) {
            return escapeMarkup(item.text);
        },
        initSelection : function (element, callback) {
            var data = [];
            $(element.val().split(",")).each(function () {
                data.push({id: this, text: this});
            });
            callback(data);
        }
    };

    if (!pageContext.currentUser.canCreateTopics) {
        select2Options.createSearchChoice = function(term, data) {}
    }

    $("#topics").select2(select2Options);

    var loadTagSuggestions = function() {
        var titleText = $('#title').val();
        var bodyText = $('#body').val();

        if (titleText || bodyText) {
            $.post(pageContext.url.extractKeywords, {
                title: titleText,
                body: bodyText
            }, function(data) {
                $('#suggested-topics-list').html('');

                function toggleToTags(tagname) {
                    var $topics = $("#topics");
                    $topics.val($topics.val() + ($topics.val() === "" ? "" : ",") + tagname).trigger("change");
                }

                for (var i = 0; i <  data.result.keywords.length; i++) {
                    var tagname = data.result.keywords[i];

                    $('#suggested-topics-list').append(
                        $("<span class=\"tag\">" + tagname + "</span>").click(function() {
                            toggleToTags($(this).text());
                        })
                    );
                }

                if($('#suggested-topics-list').html() !== ''){
                    $('#suggested-topics').slideDown();
                } else {
                    $('#suggested-topics').slideUp();
                }
            });
        } else {
            $('#suggested-topics').slideUp();
        }
    }

    $('#topics').on('open', loadTagSuggestions);
    $('#title').blur(loadTagSuggestions);
    $("[contenteditable]").bind("blur",loadTagSuggestions);
    $("#fmask").on("submit", function(e){
        $("#submit-question").attr("disabled", "disabled");
    });
});