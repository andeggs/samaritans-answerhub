<#import "/macros/security.ftl" as security />
<#import "/macros/thub.ftl" as teamhub />
<#macro cr role>${security.hasRole(role, false)?string}</#macro>
<#assign nsc = teamhub.getSetting("site.comment.newStyleComments")!false />

    window.croles = {
        u: <@cr "ROLE_USE_PRIVATE_COMMENTS" />, op: <@cr "ROLE_SEND_PRIV_COMMENTS_OP" />, m: <@cr "ROLE_SEND_PRIV_COMMENTS_MOD" />,
        og: <@cr "ROLE_SEND_PRIV_COMMENTS_OG" />, as: <@cr "ROLE_SEND_PRIV_COMMENTS_ASG" />, ag: <@cr "ROLE_SEND_PRIV_COMMENTS_AG" />,
        dc: <@cr "ROLE_DELETE_COMMENT"/>, doc: <@cr "ROLE_DELETE_OWN_COMMENT"/>, eo: <@cr "ROLE_EDIT_OWN_COMMENT"/>, ea: <@cr "ROLE_EDIT_COMMENT"/>
    };

    tools.init({
        q: {
            e: <@cr "ROLE_EDIT_QUESTION" />, ew: <@cr "ROLE_EDIT_WIKI_QUESTION" />, eo: <@cr "ROLE_EDIT_OWN_QUESTION" />,
            r: <@cr "ROLE_RETAG_QUESTION" />, ro: <@cr "ROLE_RETAG_OWN_QUESTION" />,
            d: <@cr "ROLE_DELETE_QUESTION" />, dow: <@cr "ROLE_DELETE_OWN_QUESTION" />, fv: <@cr "ROLE_FAVORITE" />,
            c: <@cr "ROLE_CLOSE_QUESTION" />, co: <@cr "ROLE_CLOSE_OWN_QUESTION" />,
            p: <@cr "ROLE_PUBLISH_OTHERS_QUESTION" />, tm: <@cr "ROLE_SEND_QUESTION_TO_MOD" />
        <#if teamhub.getSetting("site.navigation.spaces.activateInTheme")!false>
            , ms: <@cr "ROLE_MOVE_QUESTION_TO_SPACE" />, mos: <@cr "ROLE_MOVE_OWN_QUESTION_TO_SPACE" />
        </#if>
        },
        n: {
            f: <@cr "ROLE_FLAG_NODE" />, vf: <@cr "ROLE_VIEW_REPORTS" />, vfo: <@cr "ROLE_VIEW_REPORTS_OWN_POST" />,
            vr: <@cr "ROLE_VIEW_REVISIONS" />, vro: <@cr "ROLE_VIEW_OWN_REVISIONS" />,
            c: <@cr "ROLE_COMMENT" />, co: <@cr "ROLE_COMMENT_OWN_POST" />,
            vu: <@cr "ROLE_VOTE_UP" />, vd: <@cr "ROLE_VOTE_DOWN" />,
            w: <@cr "ROLE_WIKIFY" />, wo: <@cr "ROLE_WIKIFY_OWN_POST" />,
            l: <@cr "ROLE_LOCK_NODE" />
        },
        c: {
            e: <@cr "ROLE_EDIT_COMMENT" />, eo: <@cr "ROLE_EDIT_OWN_COMMENT" />,
            d: <@cr "ROLE_DELETE_COMMENT" />, dow: <@cr "ROLE_DELETE_OWN_COMMENT" />,
            ta: <@cr "CNV_ROLE_COMMENT_TO_ANSWER" />, tao: <@cr "CNV_ROLE_OWN_COMMENT_TO_ANSWER" />,
            l: <@cr "ROLE_LIKE_COMMENT" />
        },
        a: {
            e: <@cr "ROLE_EDIT_ANSWER" />, ew: <@cr "ROLE_EDIT_WIKI_ANSWER" />, eo: <@cr "ROLE_EDIT_OWN_ANSWER" />,
            d: <@cr "ROLE_DELETE_ANSWER" />, dow: <@cr "ROLE_DELETE_OWN_ANSWER" />,
            a: <@cr "ROLE_ACCEPT_ANSWER" />, aoq: <@cr "ROLE_ACCEPT_ANSWER_OWN_QUESTION" />, ao: <@cr "ROLE_ACCEPT_OWN_ANSWER" />,
            tc: <@cr "CNV_ROLE_ANSWER_TO_COMMENT" />, tco: <@cr "CNV_ROLE_OWN_ANSWER_TO_COMMENT" />,
            p: <@cr "ROLE_PUBLISH_OTHERS_ANSWER" />, tm: <@cr "ROLE_SEND_ANSWER_TO_MOD" />
        },
        pc: croles
    }, {
        tc: ${(teamhub.getSetting("site.comment.enableThreadedComments")?string)!"false"},
        nsc: ${nsc?string}
    });
