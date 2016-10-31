<script type="text/javascript">
    var searchItemMouseDown = false;
    var $searchAuto = $("#search-query").autocomplete({
        open: function () {
            $searchAuto.addClass("open");
            $("#searchResultsAutoComplete").find("a").mousedown(function (e) {
                searchItemMouseDown = true;
            });
        },
        close: function (e) {
            $searchAuto.removeClass("open");
        },
        appendTo: '#searchResultsAutoComplete',
        autoFocus: false,
        highlight: function (match, keywords) {
            keywords = keywords.split(' ').join('|');
            return match.replace(new RegExp("(" + keywords + ")", "gi"), '<b>$1</b>');
        },
        source: function (request, response) {
            var query = request.term;
            var labelText = $('<div/>').text(request.term).html();

            if (!/\s$/.test(query)) {
                query += "*";
            }

            $.ajax({
                url: '<@url name="search.json" />',
                dataType: 'json',
                minLength: 0,
                delay: 30,
                data: { q: query, page: 1, pageSize: 7, type: "object", compact: 'true' },
                success: function (data) {
                    var $results = $.map(data.searchResults.results, function (item, index) {
                        if (item != null) {
                            if (item.username){
                                var name = item.username;
                                if(item.realname){
                                    name += " | " + item.realname;
                                }
                                return {

                                    label: name.replace(
                                            new RegExp(
                                                            "(?![^&;]+;)(?!<[^<>]*)(" +
                                                            $.ui.autocomplete.escapeRegex(request.term) +
                                                            ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                            ), "<strong>$1</strong>"),
                                    url: "<@url name="users:profile" user="{id}" plug="{plug}" />", //item.id
                                    value: name,
                                    id: item.id,
                                    plug: item.plug,
                                    type: "User",
                                    emailHash: item.emailHash
                                };
                            }
                            switch (item.type) {
                                case 'topic':
                                    return {
                                        label: item.name.replace(
                                                new RegExp(
                                                        "(?![^&;]+;)(?!<[^<>]*)(" +
                                                                $.ui.autocomplete.escapeRegex(request.term) +
                                                                ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                                ), "<strong>$1</strong>"),
                                        url: "<@url name="topics:view" topics="{id}" />", //item.id
                                        value: item.name,
                                        id: item.name,
                                        plug: item.plug,
                                        type: "Topic"
                                    };
                                case 'user':
                                    var name = item.username;
                                    if(item.realname){
                                        name += " | " + item.realname;
                                    }
                                    return {

                                        label: name.replace(
                                                new RegExp(
                                                        "(?![^&;]+;)(?!<[^<>]*)(" +
                                                                $.ui.autocomplete.escapeRegex(request.term) +
                                                                ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                                ), "<strong>$1</strong>"),
                                        url: "<@url name="users:profile" user="{id}" plug="{plug}" />", //item.id
                                        value: name,
                                        id: item.id,
                                        plug: item.plug,
                                        type: "User",
                                        emailHash: item.emailHash
                                    };
                                case 'question':
                                    return {
                                        label: item.title.replace(
                                                new RegExp(
                                                        "(?![^&;]+;)(?!<[^<>]*)(" +
                                                                $.ui.autocomplete.escapeRegex(request.term) +
                                                                ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                                ), "<strong>$1</strong>"),
                                        url: "<@url name="questions:view" question="{id}" plug="{plug}" />", //item.id
                                        value: item.title,
                                        id: item.id,
                                        plug: item.plug,
                                        type: item.type
                                    };
                                default:
                                    return {
                                        label: item.title.replace(
                                                new RegExp(
                                                        "(?![^&;]+;)(?!<[^<>]*)(" +
                                                                $.ui.autocomplete.escapeRegex(request.term) +
                                                                ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                                ), "<strong>$1</strong>"),
                                        url: "<@url name="content:view" type="{type}" node="{id}" plug="{plug}" />", //item.id
                                        value: item.title,
                                        id: item.id,
                                        plug: item.plug,
                                        type: item.type
                                    };
                            }
                        }
                    });
                    $results.push({
                        label: "<@trans key="label.search"/>: " + "\"" + $.trim(labelText) + "\"",
                        url: "<@url name="search"/>?q={query}",
                        query: request.term,
                        value: request.term
                    });
                    $results.push({
                        label: "${trans("thub.search.autocomplete.ask")?js_string}".replace("$q", $.trim(labelText)),
                        url: "<@url name="questions:ask"/>?a=true&q={query}<#if currentSpace??>&space=${currentSpace}</#if>",
                        query: request.term,
                        value: request.term
                    });

                    response($results);
                }
            });
        },
        select: function (event, ui) {
            var url = ui.item.url.replace("%7Bid%7D", ui.item.id);
            url = url.replace("%7Bplug%7D", ui.item.plug);
            url = url.replace("{query}", ui.item.query);
            url = url.replace("%7Btype%7D", ui.item.type);
            window.location = url;
            return false;
        }
    }).keydown(function () {
                $(this).css('color', '#000');
            });

    if ($searchAuto.length) {
        $searchAuto.data("uiAutocomplete")._renderItem = function (ul, item) {
            var type_str = "";
            if (item.type == "Topic")
                    type_str = "<span class='autocomplete-type'>" + "<@trans key="node.type.topic"/>" + "</span>";
            return $("<li></li>")
                    .data("item.autocomplete", item)
                    .append("<a>" + (item.type == 'User' ? '<img class="gravatar" align="left" width="16" height="16" style="margin-right: 5px;" src="http://www.gravatar.com/avatar/'
                            + item.emailHash + '?s=16&amp;d=identicon&amp;r=PG"/>' : '') + " " + item.label + " " + type_str + "</a>")
                    .appendTo(ul);
        };
    }
</script>