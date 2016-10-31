<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<#import "/macros/security.ftl" as security />


<script type="text/javascript">
(function ($) {
    "use strict";

    $.extend($.fn.select2.defaults, {
        formatNoMatches: function () {
            return '${trans('thub.select.noMatches')?js_string}';
        },
        formatInputTooShort: function (input, min) {
            var n = min - input.length;
            if (n == 1) {
                return '${trans('thub.select.inputTooShort.1')?js_string}';
            }
            else {
                var return_str = "${trans('thub.select.inputTooShort.n')?js_string}";
                return return_str.replace("$n", n.toString());
            }
        },
        formatInputTooLong: function (input, max) {
            var n = input.length - max;
            if (n == 1)
                return '${trans('thub.select.inputTooLong.1')?js_string}';
            else {
                var return_str = '${trans('thub.select.inputTooLong.n')?js_string}';
                return return_str.replace("$n", n.toString());
            }
        },
        formatSelectionTooBig: function (limit) {
            if (limit == 1)
                return '${trans('thub.select.inputTooBig.1')?js_string}';
            else {
                var return_str = '${trans('thub.select.inputTooBig.n')?js_string}';
                return return_str.replace("$n", limit.toString());
            }
        },
        formatLoadMore: function (pageNumber) {
            return '${trans('thub.select.loadMore')?js_string}';
        },
        formatSearching: function () {
            return '${trans('thub.select.searching')?js_string}';
        }
    });
})(jQuery);
</script>
