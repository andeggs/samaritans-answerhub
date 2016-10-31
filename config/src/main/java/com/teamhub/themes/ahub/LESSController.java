package com.teamhub.themes.ahub;

import com.teamhub.infrastructure.security.RolesManager;
import com.teamhub.infrastructure.service.ServiceResponse;
import com.teamhub.infrastructure.themes.ThemeFileResolver;
import com.teamhub.infrastructure.themes.less.LessCompiler;
import com.teamhub.infrastructure.url.TeamHubUrl;
import com.teamhub.infrastructure.url.UrlService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.teamhub.infrastructure.spring.FlashScope;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.String;

@RequestMapping(value = "/less")
@TeamHubUrl("less")
@Controller
public class LESSController {

    @Autowired
    ThemeFileResolver fileResolver;

    @Autowired
    UrlService urlService;

    @Autowired
    LessCompiler lessCompiler;

    @Autowired
    FlashScope flashScope;



    @TeamHubUrl("compile")
    @RequestMapping(value = "/compiled/{less}.html", method = RequestMethod.GET)
    public String compileLESS(@PathVariable String less, HttpServletRequest request, HttpServletResponse response) {

        return "redirect:" + fileResolver.resolveWebPath("/less/" + less + ".less");
    }

    @Secured(RolesManager.EDIT_SETTINGS)
    @TeamHubUrl(value = "clearCompiled", linkLabel = "admin.clearCompiledLess", linkSection = "admin.sidebar/site/theme/after", weight = 55)
    @RequestMapping(value = "/clearCompiled.html", method = RequestMethod.GET)
    public String clearCompiledLESS() {
        lessCompiler.requestRecompile("/less/answerhub.less");
        flashScope.add("success", "A LESS recompilation has been requested.  Please check your site in a few seconds.");
        return urlService.redirectResolve("admin:site:theme");
    }

    @Secured(RolesManager.EDIT_SETTINGS)
    @TeamHubUrl(value = "clearCompiled.json")
    @RequestMapping(value = "/clearCompiled.json", method = RequestMethod.GET)
    public @ResponseBody
    ServiceResponse clearCompiledLESSJson() {
        lessCompiler.requestRecompile("/less/answerhub.less");
        return new ServiceResponse();
    }

}
