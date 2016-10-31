package com.teamhub.themes.ahub.interceptors;

import com.teamhub.infrastructure.store.SiteStore;
import com.teamhub.managers.node.NodeManager;
import com.teamhub.managers.node.NodeQueryPlanner;
import com.teamhub.models.node.Question;
import com.teamhub.models.site.Container;
import freemarker.template.*;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.List;
import java.util.regex.Pattern;

public class IndexInterceptor extends HandlerInterceptorAdapter{

    @Autowired
    SiteStore store;

    @Autowired
    NodeManager nodeManager;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String path = request.getServletPath();

        if(!Pattern.compile("^/index.html$").matcher(path).matches()){
            return true;
        }

        request.setAttribute("getTopQuestions", new TemplateMethodModelEx() {
            public Object exec(List list) throws TemplateModelException {
                Object obj = DeepUnwrap.permissiveUnwrap((TemplateModel) list.get(0));
                if (obj instanceof Container) {
                    NodeQueryPlanner<Question> p = nodeManager.getQueryPlanner(Question.class)
                            .fillMetaData()
                            .inContainer((Container)obj)
                            .applyAclProtection()
                            .pageSize(3)
                            .pageNumber(1)
                            .namedSort("active");
                    List<Question> questions = p.execute();
                    return questions;
                } else {
                    return Collections.emptyList();
                }
            }
        });

        request.setAttribute("getQuestionCount", new TemplateMethodModelEx() {
            public Object exec(List list) throws TemplateModelException {
                Object obj = DeepUnwrap.permissiveUnwrap((TemplateModel) list.get(0));
                if (obj instanceof Container) {
                    long count = nodeManager.getQueryPlanner(Question.class)
                            .inContainer((Container)obj)
                            .applyAclProtection()
                            .getCount();
                    return count;
                } else {
                    return 0;
                }
            }
        });



        return true;
    }
}
