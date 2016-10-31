package com.teamhub.themes.ahub.widgets;

import com.teamhub.infrastructure.plugins.widget.AbstractWidgetContextProvider;
import com.teamhub.infrastructure.plugins.widget.DataModelWrapper;
import com.teamhub.infrastructure.spring.RequestInfo;
import com.teamhub.managers.TeamHubManager;
import com.teamhub.managers.node.NodeManager;
import com.teamhub.managers.node.TopicManager;
import com.teamhub.managers.social.SocialManager;
import com.teamhub.models.node.Node;
import com.teamhub.models.node.Topic;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModelException;
import org.springframework.beans.factory.annotation.Autowired;
import com.teamhub.models.site.smart.FiltersExecutor;
import com.teamhub.managers.node.NodeQueryPlanner;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TopicContext extends AbstractWidgetContextProvider {
    @Autowired
    RequestInfo requestInfo;

    @Autowired
    private TeamHubManager teamHubManager;

    @Autowired
    SocialManager socialManager;

    @Autowired
    NodeManager nodeManager;

    @Autowired
    TopicManager topicManager;

    @Override
    public Map<String, Object> getContextMap(DataModelWrapper model) {
        Map<String, Object> context = new HashMap<String, Object>();
        final Topic topic = (Topic)model.get("topic");
        context.put("currentSite", requestInfo.getSite());
        context.put("node", model.get("topic"));
        context.put("teamHubManager", teamHubManager);
        context.put("followerCount", socialManager.getFollowerCount(topic));

        NodeQueryPlanner p;

        if (requestInfo.getSmartSpace() != null) {

            FiltersExecutor executor = requestInfo.getSmartSpace().getFilters();

            p = executor.getQueryPlanner();
        } else {
           p = nodeManager.getQueryPlanner(Node.class);
        }

        context.put("postCount", p.applyAclProtection().withTopic(topic).getCount());
        context.put("userCount", topicManager.countUsers(topic));
        context.put("followers", socialManager.getFollowers(topic));
        context.put("relatedTopics", new TemplateMethodModelEx() {
            public Object exec(List list) throws TemplateModelException {
                return topicManager.getRelatedTopics(topic, 25);
            }
        });



        return context;
    }
}
