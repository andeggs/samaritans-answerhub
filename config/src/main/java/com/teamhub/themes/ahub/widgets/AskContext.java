package com.teamhub.themes.ahub.widgets;

import com.teamhub.infrastructure.plugins.widget.AbstractWidgetContextProvider;
import com.teamhub.infrastructure.plugins.widget.DataModelWrapper;
import com.teamhub.infrastructure.spring.RequestInfo;
import com.teamhub.managers.TeamHubManager;
import com.teamhub.managers.generic.DirectQueryManager;
import com.teamhub.managers.node.TopicManager;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.Map;

public class AskContext extends AbstractWidgetContextProvider {
    @Autowired
    RequestInfo requestInfo;

    @Autowired
    TopicManager topicManager;

    @Autowired
    DirectQueryManager queryManager;

    @Autowired
    private TeamHubManager teamHubManager;


    @Override
    public Map<String, Object> getContextMap(DataModelWrapper model) {
        Map<String, Object> context = new HashMap<String, Object>();

        context.put("currentUser", requestInfo.getUserInfo().getUser());
        context.put("currentSite", requestInfo.getSite());
        context.put("currentSpace", requestInfo.getSpace());
        context.put("question", model.get("question"));
        context.put("space", model.get("space"));
        context.put("topic", model.get("topic"));
        
        context.put("teamHubManager", teamHubManager);

        return context;
    }
}