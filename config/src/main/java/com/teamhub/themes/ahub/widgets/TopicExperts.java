package com.teamhub.themes.ahub.widgets;

import com.teamhub.infrastructure.plugins.widget.AbstractWidgetContextProvider;
import com.teamhub.infrastructure.plugins.widget.DataModelWrapper;
import com.teamhub.infrastructure.spring.RequestInfo;
import com.teamhub.managers.TeamHubManager;
import com.teamhub.managers.action.impl.ActionManagerImpl;
import com.teamhub.managers.generic.DirectQueryManager;
import com.teamhub.managers.node.NodeManager;
import com.teamhub.managers.node.TopicManager;
import com.teamhub.managers.social.SocialManager;
import com.teamhub.models.node.Topic;
import com.teamhub.models.user.User;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.Integer;
import java.lang.String;
import java.util.List;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

public class TopicExperts extends AbstractWidgetContextProvider {

    @Autowired
    RequestInfo requestInfo;

    @Autowired
    SocialManager socialManager;

    @Autowired
    TopicManager topicManager;

    @Autowired
    DirectQueryManager queryManager;

    Map<String,String> userMap;

    @Override
    public Map<String, Object> getContextMap(DataModelWrapper model) {
        Map<String, Object> context = new HashMap<String, Object>();
        final Topic topic = (Topic)model.get("topic");
        List<Topic> topics = new ArrayList<Topic>();
        topics.add(topic);

        List<User> users = socialManager.findExpertsForTopics(topics);
        Map<String, Object> queryArgs = null;
        Map<String, String> userPointsMap = new HashMap<String, String>();
        double highestTopicExpertPoints = 0.0;
        for(User u: users)
        {
            queryArgs = new HashMap<String, Object>();
            queryArgs.put("topic", topic);
            queryArgs.put("user", u);
            List<Long> repList =  queryManager.<Long>runSelect("select sum(r.value) from ActionReputation r join " +
                    "r.action.node.originalParent.topics t where t = :topic and r.user = :user", queryArgs, 5);
            if(repList.get(0) != null && repList.get(0) > highestTopicExpertPoints)
            {
                highestTopicExpertPoints = repList.get(0);
            }
            userPointsMap.put(String.valueOf(u.getId()),String.valueOf(repList.get(0) == null?0:repList.get(0)));
        }

        userPointsMap = sortByComparator(userPointsMap);
        Map<String, String> topExpertsMap = new LinkedHashMap<String, String>();

        List<User> sortedUsers = new ArrayList<User>();
        Iterator it = userPointsMap.entrySet().iterator();
        int count = 0;
        while (it.hasNext()) {
            Map.Entry<String,String> pairs = (Map.Entry<String,String>)it.next();
            if(count <= 10)
            {
                topExpertsMap.put(pairs.getKey(),pairs.getValue());
                for(User u: users)
                {
                    if(u.getId() == Integer.parseInt(pairs.getKey()))
                    {
                        sortedUsers.add(u);
                    }
                }
            }
            ++count;
        }

        Iterator iterator = users.iterator();
        while(iterator.hasNext())
        {
            User u = (User)iterator.next();
            if(!topExpertsMap.containsKey(String.valueOf(u.getId())))
            {
                iterator.remove();
            }
        }



        context.put("experts", sortedUsers);
        context.put("expertsMap", topExpertsMap);
        return context;
    }

    private Map<String, String> sortByComparator(Map<String, String> unsortedMap)
    {

        List<Entry<String, String>> list = new LinkedList<Entry<String, String>>(unsortedMap.entrySet());

        // Sorting the list based on values
        Collections.sort(list, new Comparator<Entry<String, String>>()
        {
            public int compare(Entry<String, String> o1,
                               Entry<String, String> o2)
            {
                if(Integer.parseInt(o1.getValue()) == Integer.parseInt(o2.getValue()))
                    return 0;

                return Integer.parseInt(o1.getValue()) < Integer.parseInt(o2.getValue()) ? 1 : -1;
            }
        });

        // Maintaining insertion order with the help of LinkedList
        Map<String, String> sortedMap = new LinkedHashMap<String, String>();
        for (Entry<String, String> entry : list)
        {
            sortedMap.put(entry.getKey(), entry.getValue());
        }

        return sortedMap;
    }
}