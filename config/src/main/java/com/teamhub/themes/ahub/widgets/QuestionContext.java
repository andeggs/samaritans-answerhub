package com.teamhub.themes.ahub.widgets;

import com.teamhub.infrastructure.plugins.widget.AbstractWidgetContextProvider;
import com.teamhub.infrastructure.plugins.widget.DataModelWrapper;
import com.teamhub.infrastructure.security.SecurityCheckerFactory;
import com.teamhub.infrastructure.spring.RequestInfo;
import com.teamhub.managers.TeamHubManager;
import org.springframework.beans.factory.annotation.Autowired;


import java.util.*;

public class QuestionContext extends AbstractWidgetContextProvider {
    @Autowired
    RequestInfo requestInfo;

    @Autowired
    private TeamHubManager teamHubManager;

    @Autowired
    SecurityCheckerFactory checkerFactory;

    @Override
    public Map<String, Object> getContextMap(DataModelWrapper model) {
        Map<String, Object> context = new HashMap<String, Object>();
        context.put("requestInfo", requestInfo);
        context.put("currentSite", requestInfo.getSite());
        context.put("node", model.get("question"));
        context.put("canAskToAnswer", checkerFactory.create().hasPermission(model.get("question"), "asktoanswer"));
        context.put("teamHubManager", teamHubManager);
        context.put("relatedQuestions", model.get("relatedQuestions"));

        return context;
    }
}