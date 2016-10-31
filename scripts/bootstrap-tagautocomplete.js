/* =============================================================
 * bootstrap-tagautocomplete.js v0.1
 * http://sandglaz.github.com/bootstrap-tagautocomplete
 * =============================================================
 * Copyright 2013 Sandglaz, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */

!function ($) {

  "use strict"; // jshint ;_;


 /* TAGAUTOCOMPLETE PUBLIC CLASS DEFINITION
  * =============================== */

  var Tagautocomplete = function (element, options) {
    $.fn.typeahead.Constructor.call(this, element, options)
    this.after = this.options.after || this.after
    this.show = this.options.show || this.show
  }

  /* NOTE: TAGAUTOCOMPLETE EXTENDS BOOTSTRAP-TYPEAHEAD.js
     ========================================== */

  Tagautocomplete.prototype = $.extend({}, $.fn.typeahead.Constructor.prototype, {

    constructor: Tagautocomplete

  , select: function (e) {



      var val = this.$menu.find('.active').attr('data-value')

      var offset = this.updater(val).length - this.length_of_query;
      var position = getCaretPosition(this.$element[0]) + offset

    this.node.splitText(this.index_for_split);

    this.node.nextSibling.splitText(this.length_of_query);
    this.node.nextSibling.nodeValue=this.updater(val);


      this.$element.change();

      this.after();

      //if(this.node.nextSibling != null)
//          if( this.isCallingInDown)
//              position = position + offset -1;

        setCaretPosition(this.$element[0], position);
          this.isCallingInDown = false;



          return this.hide()
    }
, keypress: function (e) {
      return;
    }
  , after: function () {

  }   //to avoid getting mixed un in the events of redactor
      // we need to call .select when the enter key goes down.
  , keydown: function (e) {
     if(e.keyCode == 13)
     {
         if (!this.shown) return
         this.isCallingInDown = true;
         this.select()  ;
         e.preventDefault();
     }
     else
         this.move(e);

      }
    , keyup: function (e) {
      switch(e.keyCode) {
          case 40: // down arrow
          case 38: // up arrow
          case 16: // shift
          case 17: // ctrl
          case 18: // alt
              break

          case 9: // tab
          // the default used to call .select here for code 13 // enter
          // but that breaks when using redactor. now we call it in keydown .
          //  also, in order to place the caret correctly, we need to do it after the keyup
          // or it'll always be before the @
          case 13:
              var val = this.$menu.find('.active').attr('data-value')
              var offset = this.updater(val).length - this.length_of_query;
              var position = getCaretPosition(this.$element[0]) + offset
              setCaretPosition(this.$element[0], position);

          case 27: // escape
              if (!this.shown) return
              this.hide()
              break

          default:
              this.lookup()
      }

      }
  , show: function () {
      var pos = this.$element.position();
      var height = this.$element[0].offsetHeight;
      var offset = this.$element.offset();

      this.$menu
        .appendTo('body')
        .show()
        .css({
          position: "absolute",
          top: (offset.top + pos.top - 40) + height + "px",
          left: (offset.left + pos.left)+ "px"
        });

      this.shown = true
      return this
  }

  , extractor: function () {
      var query = this.query;
      var position = getCaretPosition(this.$element[0]);
      query = query.substring(0, position);
      var regex = new RegExp("(^|\\s)([" + this.options.character + "][\\w-]*)$");
      var result = regex.exec(query);
      if(result && result[2])
        return result[2].trim();
      return '';
    }

  , updater: function(item) {
      return item+' ';
  }

  , matcher: function (item) {
      var tquery = this.extractor();
      if(!tquery) return false;

      //setting the values that will be needed by select() here, because mouse clicks can change these values.
      this.length_of_query = tquery.length
      var range = window.getSelection().getRangeAt(0);
      this.index_for_split = range.startOffset - this.length_of_query;

        this.node = range.startContainer



      return ~item.toLowerCase().indexOf(tquery)
    }

  ,  highlighter: function (item) {     
      var query = this.extractor().replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
      return item.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
        return '<strong>' + match + '</strong>'
      })
    }

  })


 /* TAGAUTOCOMPLETE PLUGIN DEFINITION
  * ======================= */

  var old = $.fn.tagautocomplete

  $.fn.tagautocomplete = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tagautocomplete')
        , options = typeof option == 'object' && option
      if (!data) $this.data('tagautocomplete', (data = new Tagautocomplete(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tagautocomplete.Constructor = Tagautocomplete

  $.fn.tagautocomplete.defaults = $.extend($.fn.typeahead.defaults, {
    character: '@'
  })


 /* TAGAUTOCOMPLETE NO CONFLICT
  * =================== */

  $.fn.tagautocomplete.noConflict = function () {
    $.fn.tagautocomplete = old
    return this
  }

}(window.jQuery);
