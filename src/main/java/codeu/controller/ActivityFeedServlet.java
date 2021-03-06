package codeu.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import codeu.model.data.Activity;
import codeu.model.data.Activity.ActivityType;
import codeu.model.store.basic.ActivityStore;

/** Servlet class for the activity feed */
public class ActivityFeedServlet extends HttpServlet {

  private ActivityStore activityStore;

  @Override
  public void init() throws ServletException {
    super.init();
    setActivityStore(activityStore.getInstance());
  }

  void setActivityStore(ActivityStore activityStore) {
    this.activityStore = activityStore;
  }

  @Override
  public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws IOException, ServletException {
    List<Activity> activities = activityStore.getActivities();
    request.setAttribute("activities", activities);
    request.getRequestDispatcher("/WEB-INF/view/activityfeed.jsp")
           .forward(request, response);
  }
}
