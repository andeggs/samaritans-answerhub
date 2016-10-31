package com.teamhub.themes.ahub.widgets;

import com.teamhub.infrastructure.plugins.widget.AbstractWidgetContextProvider;
import com.teamhub.infrastructure.plugins.widget.DataModelWrapper;
import com.teamhub.infrastructure.spring.RequestInfo;
import com.teamhub.managers.generic.DirectQueryManager;
import com.teamhub.models.award.Award;
import com.teamhub.infrastructure.security.SecurityCheckerFactory;

import org.springframework.beans.factory.annotation.Autowired;

import java.lang.Override;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RecentAwardsContext extends AbstractWidgetContextProvider {

    @Autowired
    DirectQueryManager queryManager;

    @Autowired
    RequestInfo requestInfo;

    @Autowired
    SecurityCheckerFactory checkerFactory;

    public Map<String, Object> getContextMap(DataModelWrapper model) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("site", requestInfo.getSite());
        params.put("active", true);
        List<Award> awards = queryManager.<Award>runSelect(
                "from Award a where a.site=:site and a.user.active=:active order by a.creationDate desc", params, getMaxResults());

        Map<String, Object> context = new HashMap<String, Object>();
        context.put("awards", awards);
        context.put("requestInfo", requestInfo);
        return context;
    }

    private int getMaxResults() {
        return 10;
    }

    @Override
    public boolean canRender(DataModelWrapper model) {
        return checkerFactory.create().hasRole("ROLE_VIEW_AWARDS");
    }
}
