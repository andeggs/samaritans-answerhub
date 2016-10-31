$(document).ready(function () {
    var hour  = 60 * 60 * 1000,
        day   = hour * 24,
        week  = day * 7,
        month = day * new Date(new Date().getYear(), new Date().getMonth(), 0).getDate(),
        year  = day * 365.25,
        $searchFilters     = $("#search-filters"),
        $searchDatePickers = $(".search-datepicker"),
        $searchStart       = $(".search-start"),
        $searchEnd         = $(".search-end"),
        $searchDates       = $(".search-dates"),
        $searchDateSelect  = $(".search-date-select"),
        $searchInput       = $("#search-query"),
        $authorInput       = $("#author-input"),
        $topicInput        = $("#topic-input"),
        $searchTypes       = $("#search-types"),
        $searchSort        = $("#search-sort"),
        $searchTypeLinks   = $(".search-type-links a"),
        $searchSortLinks   = $(".search-sort-links li"),
        searchPatterns     = {
            tagsPattern : /\[([^\]]+)\]/g,
            phrasesPattern : /"([^"]+)"/g,
            shouldContainSplitter : /\s+/g,
            mustContain : /\+([^\s]+)/g,
            mustNotContain : /(?:^|\s)\-([^\s]+)/g,
            fieldQueries : /(\w+):"([^"]+)"/g,
            cleanup : /\+|\-|&&|\|\||!|\(|\)|\{|}|\[|]|\^|"|~|:|\\/g,
            cleanupFull : /[^\w]/g,
            dateRangePattern : /(\d{4}-\d{2}-\d{2})\s+TO\s+(\d{4}-\d{2}-\d{2})/g,
            timestampRangePattern : /(\d{8,12})\s+TO\s+(\d{8,12})/g,
            rangePattern : /(\w+)\s+TO\s+(\w+)/g,
            datePattern : /\d{4}-\d{2}-\d{2}/g
        };
    $searchDateSelect.select2();
    $searchDatePickers.datepicker();
    $searchDatePickers.datepicker("option", "dateFormat", "yy-mm-dd");

    function getFieldQueries(input) {
        if (!input) {
            input = $searchInput;
        } else {
            input = $(input);
        }
        var ret = {},
            match = searchPatterns.fieldQueries.exec(input.val());
        while (match) {
            ret[match[1]] = {value: match[2], input: match[0]};
            match = searchPatterns.fieldQueries.exec(input.val());
        }
        return ret;
    }

    function setDate(start, end) {
        var dateField = getFieldQueries().date;
        if (dateField) {
            $searchInput.val($searchInput.val().replace(dateField.input, dateField.input.replace(dateField.value, start + " TO " + end)));
        } else {
            $searchInput.val($searchInput.val().trim() + " date:\"" + start + " TO " + end + "\"");
        }
    }

    function shortISODate(date) {
        searchPatterns.datePattern.lastIndex = 0;
        return searchPatterns.datePattern.exec(date.toISOString());
    }

    function updateDate() {
        var now = new Date();
        switch ($searchDateSelect.val()) {
            case "none":
                $searchDates.slideUp();
                $searchInput.val($searchInput.val().replace(getFieldQueries().date.input, ""));
                break;
            case "hour":
                $searchDates.slideUp();
                setDate(now.getTime() - hour, now.getTime());
                break;
            case "day":
                $searchDates.slideUp();
                var dayAgo = shortISODate(new Date(now.getTime() - day));
                setDate(dayAgo, shortISODate(now));
                break;
            case "week":
                $searchDates.slideUp();
                var weekAgo = shortISODate(new Date(now.getTime() - week));
                setDate(weekAgo, shortISODate(now));
                break;
            case "month":
                var monthAgo = shortISODate(new Date(now.getTime() - month));
                setDate(monthAgo, shortISODate(now));
                $searchDates.slideUp();
                break;
            case "year":
                var yearAgo = shortISODate(new Date(now.getTime() - year));
                setDate(yearAgo, shortISODate(now));
                $searchDates.slideUp();
                break;
            case "custom":
                $searchDates.slideDown();
                setDate($searchStart.val(), $searchEnd.val());
                break;
        }
    }

    $searchDatePickers.on("change", function () {
        updateDate();
    });

    $searchDateSelect.on("change", function () {
        updateDate();
    });

    $searchSortLinks.each(function (i, elem) {
        if ($searchSort.val().indexOf($(this).attr("data-search-sort")) !== -1) {
            $(this).addClass("active");
        }
    });

    $searchSortLinks.on("click", function () {
        if (!$(this).hasClass("disabled")) {
            $searchSortLinks.removeClass("active");
            $(this).addClass("active");
            $searchSort.val($(this).attr("data-search-sort"));
            $(".navbar-search").submit();
        }
    });

    $searchTypeLinks.each(function (i, elem) {
        if(typeof $searchTypes === 'undefined' || typeof $searchTypes.val !== 'function' || $searchTypes.val() === null){
            return;
        }
        if ($searchTypes.val().split(' ').indexOf($(this).attr("data-search-type")) !== -1) {
            $(this).addClass("active");
        }
    });

    $searchTypeLinks.on("click", function () {
        $(this).toggleClass("active");
        $searchTypes.val("");
        var types = $searchTypeLinks.filter(".active").map(function() { return $(this).attr("data-search-type")}).get().toString().replace(",", " OR ");
        $searchTypes.val(types);
    });

    if (authorNames = getFieldQueries($searchFilters).author) {
        $authorInput.val(authorNames.value.replace(/\s/g, ","));
    }

    $authorInput.select2({
        escapeMarkup: function (m) { return m; },
        placeholder: "start typing a name...",
        minimumInputLength: 1,
        ajax: {
            url: pageContext.url.searchJson,
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term += "*",
                    type: "user"
                };
            },
            results: function (data, page) {
                results = data.searchResults.results;
                for(i=0; i<results.length; i++){
                    results[i].id = results[i].username;
                }
                return {results: results};
            }
        },
        multiple: true,
        tokenSeparators: [","],
        dropdownCssClass: "authorsDropdown",
        formatResult: function (item, container, query) {
            var context = {};
            if (item.name) {
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
            $.ajax({
                url: pageContext.url.usersLookup,
                data: {
                    usernames: $authorInput.val()
                },
                dataType: "json",
                success: function (data, page) {
                    results = data.users;
                    for(i=0; i<results.length; i++){
                        results[i].id = results[i].username;
                    }
                    callback(results);
                }
            });
        }
    });

    $authorInput.on("change", function(){
        var fieldQueries = getFieldQueries($searchFilters);

        if(!fieldQueries.author){
            $searchFilters.val(($searchFilters.val() + "author:\"" + $authorInput.val().replace(/,/g," ") +"\"").trim());
        } else if(fieldQueries.author.value && fieldQueries.author.value != $authorInput.val().replace(","," ")){
            $searchFilters.val($searchFilters.val().replace(fieldQueries.author.input, $authorInput.val() == "" ? "" : "author:\"" + $authorInput.val().replace(/,/g," ") + "\""))
        }
    });

    //topics
    var updateTopicInput = function(){
        if(topics = $searchInput.val().match(searchPatterns.tagsPattern)){
            $topicInput.val(topics.toString().replace(/(<([^>]+)>)/ig,"").replace(/[\[\]]/g,""));
        }
    };

    updateTopicInput();

    $topicInput.select2({
        selectOnBlur: true,
        placeholder: "Enter topics...",
        minimumInputLength: 1,
        ajax: {
            url: pageContext.url.topicSearch,
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
        tokenSeparators: [","],
        tags:true,
        formatResult: function (item, container, query){
            return  item.text;
        },
        formatSelection: function(item,container) {
            return item.text;
        },
        initSelection : function (element, callback) {
            var data = [];
            $(element.val().split(",")).each(function () {
                data.push({id: this, text: this});
            });
            callback(data);
        }
    });

    $topicInput.on("change", function(){
        var newVal = $searchInput.val().replace(searchPatterns.tagsPattern,"").trim();
        if($topicInput.val() != ""){
            var topics = $topicInput.val().split(",");
            for(i = 0; i<topics.length; i++){
                newVal = newVal + " [" + topics[i] + "]";
            }
        }
        $searchInput.val(newVal);
    });

    $(".btn-search").on("click", function(){
    	var searchTypes = $searchTypes.val() !== '' ? $searchTypes.val() : (typeof listableTypes!=='undefined'?listableTypes.join(' OR '):'question');
    	$searchTypes.val(searchTypes);
        $(".navbar-search").submit();
    });

    $(".suggested-users>li").on("click", function(){
        var newVal = $authorInput.select2("val");
        newVal.push($(this).find(".username").text());
        $authorInput.select2("val", newVal);
        $authorInput.trigger("change");
    });
});