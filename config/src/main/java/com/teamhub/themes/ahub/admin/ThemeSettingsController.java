package com.teamhub.themes.ahub.admin;

import com.teamhub.infrastructure.security.RolesManager;
import com.teamhub.infrastructure.store.SiteStore;
import com.teamhub.infrastructure.url.TeamHubUrl;
import org.apache.commons.collections.list.TreeList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.*;

@Controller
@RequestMapping("/admin/site/theme/thub")
@TeamHubUrl("themes:thub")
public class ThemeSettingsController {

    @Autowired
    SiteStore siteStore;

    @Secured(RolesManager.EDIT_SETTINGS)
    @TeamHubUrl(value = "settings")
    @RequestMapping(value = "/settings/editLessVars.html", method = RequestMethod.GET)
    public String editLessVars(Model model) {
        List<Map> tabsList = new TreeList();
        for(String curName: new String[]{"baseColors", "general", "text", "components", "inputs"}){
            Map<String,Object> curMap = new TreeMap<String, Object>();
            curMap.put("name",curName);

            List<Map> curSubGroupsList = new TreeList();
            for (String subGroupKey: siteStore.getSubGroupsForTreeNode("plugin.lcl." + curName)){
                Map subGroupProps = new HashMap();
                String fullKey = "plugin.lcl." + curName + "." + subGroupKey;
                String fullKeyDash = fullKey.replace(".","-");
                Object form = siteStore.getFormForTreeNode(fullKey, true);
                subGroupProps.put("form",form);
                subGroupProps.put("formName",fullKeyDash);
                subGroupProps.put("key",fullKey);

                model.addAttribute(fullKeyDash + "Setting", fullKeyDash);
                model.addAttribute(fullKeyDash + "Form", form);
                curSubGroupsList.add(subGroupProps);
            }
            curMap.put("subgroups",curSubGroupsList);
            tabsList.add(curMap);
        }

        model.addAttribute("tabsList",tabsList);

        return "admin/thubThemeLessSettings";
    }
}
