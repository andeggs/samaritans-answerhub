package com.teamhub.themes.ahub.widgets;

import com.teamhub.infrastructure.plugins.widget.AbstractWidgetContextProvider;
import com.teamhub.infrastructure.plugins.widget.DataModelWrapper;
import com.teamhub.infrastructure.spring.RequestInfo;

import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.Map;

public class SubnavContext extends AbstractWidgetContextProvider{

    @Autowired
    RequestInfo requestInfo;

    @Override
    public Map<String, Object> getContextMap(DataModelWrapper model) {
        Map<String, Object> context = new HashMap<String, Object>();
        context.put("currentSpace", requestInfo.getSpace());
        context.put("topic", model.get("topic"));

        return context;
    }
}

