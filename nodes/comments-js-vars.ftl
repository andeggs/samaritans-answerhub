pageContext.i18n.modTalk = '${trans('thub.questions.view.moderation-talk')?js_string}';
pageContext.i18n.replyToComment = '${trans('thub.questions.view.comment.reply')?js_string}';
pageContext.i18n.modTalkEmpty = '${trans('thub.questions.view.moderation-talk.no-comments')?js_string}';
pageContext.url.getModTalk = "<@url name="comments:listModTalk.json" node="%ID%" />";
pageContext.url.possibleCommentRecipients = "<@url name="comments:possibleRecipients.json" parent="%ID%" safe=true />";
pageContext.url.commentEdit = '<@url name="comments:edit" comment="%ID%"/>';

pageContext.i18n.commentVisibility = {
'full': '${trans('thub.comment.visible.toEveryone')?js_string}',
'op': '${trans('thub.comment.visible.toOriginalPoster')?js_string}',
'mod': '${trans('thub.comment.visible.toModeration')?js_string}',
'opAndMod': '${trans('thub.comment.visible.toOpAndMod')?js_string}',
'other': '${trans('thub.comment.visible.toOther')?js_string}',
'dialogTitle': '${trans('thub.comment.visible.dialogTitle')?js_string}',
'selectGroups': '${trans('thub.comment.visible.selectGroup')?js_string}',
'selectOther': '${trans('thub.comment.visible.selectOther')?js_string}',
'selectOriginalPoster': '${trans('thub.comment.visible.selectOriginalPoster')?js_string}',
'selectModerators': '${trans('thub.comment.visible.selectModerators')?js_string}',
'selectAssignees': '${trans('thub.comment.visible.selectAssignees')?js_string}'
};

pageContext.i18n.commentMenuLabels = {
'comment-edit': '${trans('comments.menu.edit')?js_string}',
'comment-delete': '${trans('comments.menu.delete')?js_string}',
'comment-convert': '${trans('comments.menu.convert')?js_string}'
};