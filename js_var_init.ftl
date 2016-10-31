<#import "/spring.ftl" as spring />
<#import "/macros/thub.ftl" as teamhub />
<#import "/macros/security.ftl" as security />

<#assign attachmentTypes><@teamhub.setting key="attachments.authorizedTypes" /></#assign>
<#if contentType??>
    <#if (cTypes.forType(contentType).maxTopics)??>
        <#assign maxTopics = cTypes.forType(contentType).maxTopics/>
    <#else>
        <#assign maxTopics><@teamhub.setting key="site.question.maxTopics" /></#assign>
    </#if>

    <#if (cTypes.forType(contentType).attachmentsMaxSizeBytes)??>
        <#assign maxAttachmentsSizeBytes = cTypes.forType(contentType).attachmentsMaxSizeBytes?c/>
    <#else>
        <#assign maxAttachmentsSizeBytes>${teamHubManager.siteStore.getSetting("attachments.question.maxSizeBytes")?c}</#assign>
    </#if>

    <#if (cTypes.forType(contentType).attachmentsMaxSizeBytesTotal)??>
        <#assign maxAttachmentsSizeBytesTotal = cTypes.forType(contentType).attachmentsMaxSizeBytesTotal?c/>
    <#else>
        <#assign maxAttachmentsSizeBytesTotal>${teamHubManager.siteStore.getSetting("attachments.question.maxSizeBytesTotal")?c}</#assign>
    </#if>
<#else>
    <#assign maxTopics><@teamhub.setting key="site.question.maxTopics" /></#assign>
    <#assign maxAttachmentsSizeBytes>${teamHubManager.siteStore.getSetting("attachments.question.maxSizeBytes")?c}</#assign>
    <#assign maxAttachmentsSizeBytesTotal>${teamHubManager.siteStore.getSetting("attachments.question.maxSizeBytesTotal")?c}</#assign>
</#if>
<#assign imageTypes><@teamhub.setting key="attachments.imageAuthorizedTypes" /></#assign>
<script type="text/javascript">
    var askFormURL = '<@url name="questions:ask"/>';
    var logoutURL = '<@spring.url "/users/logout.html"/>';
    var voteUpJsonURL = '<@url name="commands:voteUp.json" node=0 />';
    var voteDownJsonURL = '<@url name="commands:voteDown.json" node=0 />';
    var getVotesJsonUrl = '<@url name="getVotes.json" node="{node}" />';
    var related_questions_url = '<@url name="search.json" />';
    var emailCheckerURL = '<@url name="users:dupsUserEmailCheck"/>';

    var authorizedFileTypes = '${attachmentTypes}'.split(",");
    var authorizedImageTypes = '${imageTypes}'.split(",");

    var flashMessages = [];

    var pageContext = {
        currentUser: {
            id: '<#if currentUser??>${currentUser.id?c}<#else></#if>',
            username: '<#if currentUser??>${(currentUser.username?html)?js_string}<#else>Anonymous</#if>',
            url: '<#if currentUser??><@url obj=currentUser /><#else>#</#if>',
            avatar: '<#if currentUser??>${currentUser.avatar}<#else></#if>',
            reputation: '<#if currentUser??>${userUtils.stats(currentUser).reputation}<#else></#if>',
            follows: null,
            canCreateTopics: ${security.hasRole("ROLE_CREATE_TOPIC")?string}
        },
        attachments: {
            maxSizeBytes: ${maxAttachmentsSizeBytes},
            maxSizeBytesTotal: ${maxAttachmentsSizeBytesTotal}
        },
    <@cache key="page_context_vars_${requestInfo.locale?string}" subkey=requestInfo.contextPath!"">
        i18n: {
            confirm: "<@trans key="label.confirmPrompt" />",
            yes: "<@trans key="label.yes" />",
            no: "<@trans key="label.no" />",
            save: "<@trans key="label.save" />",
            cancel: "<@trans key="label.cancel" />",
            close: "<@trans key="label.close" />",
            edit: "<@trans key="label.edit" default="edit" />",
            insert: "<@trans key="label.insert" default="insert" />",
            upload: "<@trans key="label.upload" default="upload" />",
            download: "<@trans key="label.download" default="download" />",
            choose: "<@trans key="label.choose" default="choose" />",
            deleted: "<@trans key="label.deleted" default="deleted" />",
            ok: "<@trans key="label.ok" />",
            by: "<@trans key="label.by" />",
            word: "<@trans key="label.word" />",
            words: "<@trans key="label.words" />",
            character: "<@trans key="label.character" />",
            characters: "<@trans key="label.characters" />",
            login: "<@trans key="label.login" />",
            register: "<@trans key="label.register" />",
            timeAgo: "<@trans key="time.ago" params=["{0}"] />",
            timeAt: "<@trans key="time.at" default="at" />",
            day: "<@trans key="label.day.short" />",
            days: "<@trans key="label.days.short" default="days" />",
            hour: "<@trans key="label.hour.short" />",
            hours: "<@trans key="label.hours.short" default="hours" />",
            minute: "<@trans key="label.minute.short" />",
            minutes: "<@trans key="label.minutes.short" default="minutes" />",
            second: "<@trans key="label.second.short" />",
            seconds: "<@trans key="label.seconds.short" default="seconds" />",
            justNow: "<@trans key="comment.time.justNow" />",
            retag: "<@trans key="label.retag" default="retag" />",
            comment: "<@trans key="label.comment" />",
            comments: "<@trans key="label.comments" />",
            showOneComment: "<@trans key="thub.questions.view.show-n-comments.1" />",
            hideOneComment: "<@trans key="thub.questions.view.hide-n-comments.1" />",
            showNComments: "<@trans key="thub.questions.view.show-n-comments" params=["$n"] />",
            hideNComments: "<@trans key="thub.questions.view.hide-n-comments" params=["$n"] />",
            question: "<@trans key="label.question" />",
            questions: "<@trans key="label.questions" />",
            answer: "<@trans key="label.answer" />",
            answers: "<@trans key="label.answers" />",
            posts: "<@trans key="label.posts" />",
            wiki: "<@trans key="label.wiki" />",
            reputation: "<@trans key="label.reputation" />",
            unlike: "<@trans key="label.unlike" />",
            like: "<@trans key="label.like" />",
            likes: "<@trans key="label.likes" />",
            follow: "<@trans key="label.follow.start" />",
            unfollow: "<@trans key="label.follow.stop" />",
            following: "<@trans key="label.follow.on" />",
            followers: "<@trans key="label.followers" />",
            awarded: "<@trans key="label.awarded" />",
            completedBy: "<@trans key="label.completedBy" />",
            joined: "<@trans key="label.joined" />",
            authorizedTypes: "<@trans key="thub.uploadDialog.allowedTypes" params=[teamHubManager.siteStore.getSetting("attachments.authorizedTypes")?string,teamHubManager.siteStore.getSetting("attachments.imageAuthorizedTypes")?string] />",
            uploadDialog: {
                uploadFile: "<@trans key="label.uploadDialog.uploadFile" />",
                doUpload: "<@trans key="label.uploadDialog.upload" />",
                fileTooBig: "<@trans key="label.uploadDialog.warning.fileTooBig" params=["$size"]/>",
                invalidAttachmentType: "<@trans key="label.uploadDialog.warning.invalidAttachmentType" params=[attachmentTypes] />",
                invalidImageType: "<@trans key="label.uploadDialog.warning.invalidImageType" params=[imageTypes] />"
            },
            previewAndCropDialog: {
                previewAndResize: "<@trans key="label.previewAndCropDialog.previewAndResize" />",
                accept: "<@trans key="label.previewAndCropDialog.accept" />"
            },

            closeQuestionTitle: "<@trans key="thub.question.close.title" />",
            lockPostModalTitle: "<@trans key="thub.question.lock.title" />",
            reportQuestionModalTitle: "<@trans key="thub.question.report.title" />",
            confirmModalTitle: "<@trans key="thub.question.modal.confirm.title" />",
            convertToAnswerText: "<@trans key="thub.question.modal.convertToAnswer.text" />",
            unlockPostModalText: "<@trans key="thub.question.modal.unlockPost.text" />",
            cancelReportModalText: "<@trans key="thub.question.modal.cancelReport.text" />",

            reportSuccessText: "<@trans key="thub.reportSuccess.text" />",
            reportCancelText: "<@trans key="thub.cancelReport.text" />",

            commandsMoveToSpace: "<@trans key="commands.moveToSpace" />",
            commandsGiveReputation: "<@trans key="label.giveReputation" />",
            commandsGiveReputationSuccess: "<@trans key="label.giveReputation.success" default="Points awarded successfully" />",
            commandsConvertToCommentTitle: "<@trans key="label.convertToComment.title" default="Select comment location" />",
            uploadProfilePictureSelectButton: "<@trans key="thub.profile.blocks.info.uploadProfilePicture.button" default="Select photo from your computer" />",
            changeAvatarSelectButton: "<@trans key="thub.profile.blocks.info.uploadProfilePicture.button" default="Select photo from your computer" />",
            changeAvatarSelectNoPhoto: "<@trans key="thub.profile.blocks.info.uploadProfilePicture.noPhoto" default="No photo selected" />",
            postControlsRedirectTitle: "<@trans key="thub.nodes.post_controls.redirect" default="Redirect" />",

            WMDImageDialogText: "<@trans key="osqa.wmd.dialog.image.text" default="Enter image url" />",
            WMDLinkDialogText: "<@trans key="osqa.wmd.dialog.link.text" default="Enter url" />",
            WMDUploadImage: "<@trans key="osqa.wmd.dialog.uploadImage" default="upload image"/>",
            WMDBold: "<@trans key="osqa.wmd.button.title.bold" default="Strong <strong> Ctrl+B" />",
            WMDItalic: "<@trans key="osqa.wmd.button.title.italic" default="Emphasis <em> Ctrl+I" />",
            WMDLink: "<@trans key="osqa.wmd.button.title.link" default="Hyperlink <a> Ctrl+L" />",
            WMDQuote: "<@trans key="osqa.wmd.button.title.quote" default="Blockquote <blockquote> Ctrl+Q" />",
            WMDCode: "<@trans key="osqa.wmd.button.title.code" default="Code Sample <pre><code> Ctrl+K" />",
            WMDImage: "<@trans key="osqa.wmd.button.title.image" default="Image <img> Ctrl+G" />",
            WMDAttachment: "<@trans key="osqa.wmd.button.title.attachment" default="Attachment Ctrl+U" />",
            WMDOrderedList: "<@trans key="osqa.wmd.button.title.orderedList" default="Numbered List <ol> Ctrl+O" />",
            WMDUnorderedList: "<@trans key="osqa.wmd.button.title.unorderedList" default="Bulleted List <ul> Ctrl+U" />",
            WMDHeading: "<@trans key="osqa.wmd.button.title.heading" default="Heading <h1>/<h2> Ctrl+H" />",
            WMDHorizontalRule: "<@trans key="osqa.wmd.button.title.horizontalRule" default="Horizontal Rule <hr> Ctrl+R" />",
            WMDUndo: "<@trans key="osqa.wmd.button.title.undo" default="Undo - Ctrl+Z" />",
            WMDRedoWin: "<@trans key="osqa.wmd.button.title.redo.win" default="Redo - Ctrl+Y" />",
            WMDRedoOther: "<@trans key="osqa.wmd.button.title.redo.other" default="Redo - Ctrl+Shift+Z" />",
            WMDHelp: "<@trans key="osqa.wmd.button.title.help" default="Markdown Help" />",

            draftMessage: "<@trans key="label.draftMessage" default="We noticed that you were previously working on {0}. What would you like to do now?" params=['TYPO'] />",
            draftSaveMessage: "<@trans key="label.draftSaving" default="Saving Draft" />",
            draftLoadButton: "<@trans key="label.draftLoad" default="Load Draft" />",
            draftDeleteButton: "<@trans key="label.draftDelete" default="Delete Draft" />",

            linkMenuInsertLink: "<@trans key="thub.editToolbar.label.link.insertLink" default="Insert Link" />",
            linkMenuEditLink: "<@trans key="thub.editToolbar.label.link.editLink" default="Edit Link" />",
            linkMenuUnlink: "<@trans key="thub.editToolbar.label.link.unlink" default="Unlink" />",
            linkMenuAnchor: "<@trans key="thub.editToolbar.label.link.anchor" default="Anchor" />",
            linkMenuMailto: "<@trans key="thub.editToolbar.label.link.mailto" default="Email" />",
            inputTextPrompt: "<@trans key="thub.editToolbar.inputForm.text.label" default="Text" />",
            inputWebPrompt: "<@trans key="thub.editToolbar.inputForm.web.label" default="URL" />",
            inputLinkNewTab: "<@trans key="thub.editToolbar.inputForm.linkNewTab" default="Open link in new tab" />",
            inputImageForm: "<@trans key="thub.editToolbar.inputForm.image.label" default="Image" />",
            inputImageTitle: "<@trans key="thub.editToolbar.inputForm.image.title" default="Title" />",
            inputImagePosition: "<@trans key="thub.editToolbar.inputForm.image.position" default="Position" />",
            inputImagePositionNone: "<@trans key="thub.editToolbar.inputForm.image.positionNone" default="None" />",
            inputImagePositionLeft: "<@trans key="thub.editToolbar.inputForm.image.positionLeft" default="Left" />",
            inputImagePositionRight: "<@trans key="thub.editToolbar.inputForm.image.positionRight" default="Right" />",

            formattingLabel: "<@trans key="thub.editToolbar.formatting.title" default="Formatting" />",
            formattingParagraph: "<@trans key="thub.editToolbar.formatting.paragraph" default="Normal Text" />",
            formattingQuote: "<@trans key="thub.editToolbar.formatting.quote" default="Quote" />",
            formattingCode: "<@trans key="thub.editToolbar.formatting.code" default="Code" />",
            formattingHeader: "<@trans key="thub.editToolbar.formatting.header" default="Header" />",
            formattingBold: "<@trans key="thub.editToolbar.formatting.bold" default="Bold" />",
            formattingItalic: "<@trans key="thub.editToolbar.formatting.italic" default="Italic" />",
            formattingUnderline: "<@trans key="thub.editToolbar.formatting.underline" default="Underline" />",
            formattingFontColor: "<@trans key="thub.editToolbar.formatting.fontColor" default="Font Color" />",
            formattingBackColor: "<@trans key="thub.editToolbar.formatting.backColor" default="Back Color" />",
            formattingIndent: "<@trans key="thub.editToolbar.formatting.indent" default="Indent" />",
            formattingOutdent: "<@trans key="thub.editToolbar.formatting.outdent" default="Outdent" />",
            formattingAlignment: "<@trans key="thub.editToolbar.formatting.alignment" default="Alignment" />",
            formattingAlignLeft: "<@trans key="thub.editToolbar.formatting.alignLeft" default="Align text to the left" />",
            formattingAlignCenter: "<@trans key="thub.editToolbar.formatting.alignCenter" default="Center text" />",
            formattingAlignRight: "<@trans key="thub.editToolbar.formatting.alignRight" default="Align text to the right" />",
            formattingAlignJustify: "<@trans key="thub.editToolbar.formatting.justify" default="Justify text" />",
            formattingHorizontalRule: "<@trans key="thub.editToolbar.formatting.horizontalRule" default="Insert Horizontal Rule" />",

            toolTipsInsertImage: "<@trans key="thub.editToolbar.label.insertImage" default="Insert Image" />",
            toolTipsInsertFile: "<@trans key="thub.editToolbar.label.insertFile" default="Insert File" />",
            toolTipsInsertCode: "<@trans key="thub.editToolbar.label.insertCode" default="Insert Code" />",
            toolTipsInsertVideo: "<@trans key="thub.editToolbar.label.insertVideo" default="Insert Video" />",
            toolTipsInsertTable: "<@trans key="thub.editToolbar.label.insertTable" default="Insert Table" />",
            toolTipsorderedList: "<@trans key="thub.editToolbar.label.orderedList" default="Ordered List" />",
            toolTipsunorderedList: "<@trans key="thub.editToolbar.label.unorderedList" default="Unordered List" />",
            toolTipLink: "<@trans key="thub.editToolbar.label.link" default="Link" />",

            tableInsert: "<@trans key="thub.editToolbar.table.insert" default="Insert Table" />",
            tableRows: "<@trans key="thub.editToolbar.table.rows" default="Rows" />",
            tableColumns: "<@trans key="thub.editToolbar.table.columns" default="Columns" />",
            tableInsertRowAbove: "<@trans key="thub.editToolbar.table.addRowAbove" default="Add Row Above" />",
            tableInsertRowBelow: "<@trans key="thub.editToolbar.table.addRowBelow" default="Add Row Below" />",
            tableInsertColumnLeft: "<@trans key="thub.editToolbar.table.addColumnLeft" default="Add Column Left" />",
            tableInsertColumnRight: "<@trans key="thub.editToolbar.table.addColumnRight" default="Add Column Right" />",
            tableDelete: "<@trans key="thub.editToolbar.table.delete" default="Delete Table" />",
            tableDeleteColumn: "<@trans key="thub.editToolbar.table.deleteColumn" default="Delete Column" />",
            tableDeleteRow: "<@trans key="thub.editToolbar.table.deleteRow" default="Delete Row" />",
            tableAddHead: "<@trans key="thub.editToolbar.table.addHeader" default="Add Header" />",
            tableDeleteHead: "<@trans key="thub.editToolbar.table.deleteHeader" default="Delete Header" />",

            uploadOrChoose: "<@trans key="thub.editToolbar.upload.orChoose" default="or choose" />",
            uploadDropFileHere: "<@trans key="thub.editToolbar.upload.dropFileHere" default="drop file here" />",
            uploadFilenameOptional: "<@trans key="thub.editToolbar.upload.filenameOptional" default="Name (optional)" />",

            emailValidationPrompt: "<@trans key="user.email.validate.prompt.title" default="Resend validation email." />",
            emailValidationPromptBody: "<@trans key="user.email.validate.prompt.descripcion" default="Do you want to resend email validation?" />",
            invalidReputation: "<@trans key="error.giveReputation.invalidEntry" default="You must enter a valid Integer without commas." />"
        },
        url: {
            login: "<@url name="users:login" />",
            register: "<@url name="users:register" />",
            getRevision: "<@url name="revisions:get-revision.json" />",
            getComments: "<@url name="comments:list.json" node="%ID%" />",
            uploadFile: "<@url name="uploadFile" />",
            uploadProgress: "<@url name="uploadProgress" />",
            uploadPreview: "<@url name="uploadPreview" />",
            cropUpload: "<@url name="cropUpload" />",
            cancelUpload: "<@url name="cancelUpload" />",
            markdownHelp: "<@url name="static:markdown:help" />",
            updateMarkdown: "<@url name="commands:updateMarkdown.json" />",
            profile: "<@url name="users:profile" user="{id}" plug="{plug}" safe=true />",
            extractKeywords: "<@url name="extract-keywords.json" />",
            follow: "<@url name="follow.json" objId="{objId}" type="{type}" />",
            unfollow: "<@url name="unfollow.json" objId="{objId}" type="{type}" />",
            getUserFollows: "<@url name="getUserFollows.json" user="{user}"/>",
            condensedProfileUrl: "<@url name="users:condensedProfile.json" user="{user}" />",
            viewTopicJSON: "<@url name="topics:view.json" topic="{topic}" />",
            topicIcon: "<@url name="topics:icon" topic="{topic}" />",
            topic: "<@url name="topics:view" topics="{topic}" />",
            topicSearch: "<@url name="topicsSearch.json" />",
            awardListUrl: "<@url name="award:list.json" awardType="{awardType}" desc="{desc}"/>",
            usersSearch: "<@url name="users:list.json" />",
            usersLookup: "<@url name="users:lookup.json" />",
            mentionsSearch: "<@url name="users:mentionsSearch.json" />",
            searchJson: "<@url name="search.json" />",
            trackJs: "<@url name="static:trackJs" />",
            userAvatar: "<@url name="users:photo" userId="{userId}"/>",
            revisionView: "<@url name="revisions:view" node="{nodeId}" safe=true/>"
        },
        extraScripts: {
            jcrop: {
                js: '<@url path='/scripts/jcrop/js/jquery.Jcrop.js' />',
                css: '<@url path='/scripts/jcrop/css/jquery.Jcrop.css' />'
            }
        },
    </@cache>
        options: {
        	maxTopics: '${maxTopics}'
        },
        additional: <#if additionalPageContext??>${toJson(additionalPageContext)}<#else>{}</#if>,
        useRelativeTime: <@teamhub.setting key="site.useRelativeTime"/>,
        userRealName: <@teamhub.setting key="user.alwaysShowRealName"/>
    };
    pageContext.i18n["delete"] = "<@trans key="label.delete" default="delete" />";
</script>
