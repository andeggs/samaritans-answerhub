package com.teamhub.themes.ahub;

import com.teamhub.infrastructure.store.SiteStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.regex.Pattern;

public class LayoutInterceptor extends HandlerInterceptorAdapter {

    @Autowired
    SiteStore store;

    final static Pattern[] requestExclusions = new Pattern[] {
            Pattern.compile("^/search.*\\.json$"),
            Pattern.compile("^/dynamic/.*$"),
            Pattern.compile("^.*/icon\\.html$"),
//            Pattern.compile("^.*/users/login.html$"),
//            Pattern.compile("^.*/users/logout.html$"),
            Pattern.compile("^.*/askedToAnswerList.html$"),
            Pattern.compile("^.*/photo/view.html"),
            Pattern.compile("^/admin/.*$")
    };



    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (excludeRequest(request)) {
            return true;
        }

        request.setAttribute("showMainNavbar", (Boolean)store.getSetting("plugin.lc.showMainNavbar"));
        request.setAttribute("showFooter", (Boolean)store.getSetting("plugin.lc.showFooter"));
        request.setAttribute("showMainContent", (Boolean)store.getSetting("plugin.lc.showMainContent"));
        request.setAttribute("showSidebarOne", (Boolean)store.getSetting("plugin.lc.showSidebarOne"));
        request.setAttribute("showSidebarTwo", (Boolean)store.getSetting("plugin.lc.showSidebarTwo"));

        request.setAttribute("mainContentWidth", (Integer)store.getSetting("plugin.lc.mainContentWidth"));
        request.setAttribute("sidebarOneWidth",  (Integer)store.getSetting("plugin.lc.sidebarOneWidth"));
        request.setAttribute("sidebarTwoWidth",  (Integer)store.getSetting("plugin.lc.sidebarTwoWidth"));

        request.setAttribute("midSectionOrder",  (String)store.getSetting("plugin.lc.midSectionOrder"));


        return true;
    }

    private boolean excludeRequest(HttpServletRequest request) {
        String path = request.getServletPath();

        for (Pattern p : requestExclusions) {
            if (p.matcher(path).matches()) {
                return true;
            }
        }

        return false;
    }
}