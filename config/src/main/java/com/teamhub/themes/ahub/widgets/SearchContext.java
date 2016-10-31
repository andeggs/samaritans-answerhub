package com.teamhub.themes.ahub.widgets;

import com.teamhub.infrastructure.plugins.widget.AbstractWidgetContextProvider;
import com.teamhub.infrastructure.plugins.widget.DataModelWrapper;

import java.util.HashMap;
import java.util.Map;

public class SearchContext extends AbstractWidgetContextProvider {
    @Override
    public Map<String, Object> getContextMap(DataModelWrapper model) {
        Map<String, Object> context = new HashMap<String, Object>();

        context.put("space", model.get("space"));
        context.put("searchResults", model.get("searchResults"));
        context.put("dateSelections", model.get("dateSelections"));
        context.put("selectedItem", model.get("selectedItem"));
        return context;
    }
}
