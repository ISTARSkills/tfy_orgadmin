<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
   import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
   import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.istarindia.android.pojo.*"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   
   String url = request.getRequestURL().toString();
   String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
   		+ request.getContextPath() + "/";
   
   IstarUser user = (IstarUser)request.getSession().getAttribute("user");
   RestClient rc = new RestClient();
   ComplexObject cp = rc.getComplexObject(user.getId());
   request.setAttribute("cp", cp);
   ArrayList<FeedbackPojo> feedbackPojoArrayList;
      feedbackPojoArrayList = new ArrayList<>();
      feedbackPojoArrayList.add(new FeedbackPojo("Noise", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Attendance", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Sick", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Content", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Assignment", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Internals", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Internet", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Electricity", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Time", "5"));
      feedbackPojoArrayList.add(new FeedbackPojo("Projector", "5"));
   %>
<body class="top-navigation student_pages" id="new_feedback">
   <div id="wrapper">
      <div id="page-wrapper" class="gray-bg">
         <jsp:include page="inc/navbar.jsp" />
         <div class="wrapper wrapper-content animated fadeInRight" style="padding: 10px;" id='equalheight'>
            <div class="row">
               <div class="col-lg-12">
                  <div class="ibox">
                     <div class="ibox-title">
                        <h5>Feedback for the class</h5>
                     </div>
                     <div class="ibox-content">
                        <div class="row">
                           <div class="col-xs-12 col-md-12">
                              <% 
                                 for(FeedbackPojo feebackpojo:feedbackPojoArrayList){ %>
                              <div class="col-xs-12 col-md-6">
                                 <div class="row no-padding no-margin">
                                    <div class="col-xs-5 no-padding no-margin">
                                       <h3 class="text-right no-padding no-margin"><%=feebackpojo.getName() %> :</h3>
                                    </div>
                                    <div class="col-xs-7">
                                       <div class="feedback_rateYo" data-star_rating="<%=feebackpojo.getRating()%>" data-name="<%=feebackpojo.getName() %>"></div>
                                    </div>
                                 </div>
                              </div>
                              <%} %>
                           </div>
                           <div class="col-xs-12 col-md-12 text-center">
                              <div class="form-group">
                                 <label for="feedbackTextarea" style="margin-top:35px;margin-bottom:20px;">What would make this course better ?</label>
                                 <textarea class="form-control" id="feedbackTextarea" rows="5" style="max-width:500px;    margin: 0 auto;float: none;"></textarea>
                              </div>
                           </div>
                           <div class="col-xs-12 col-md-12 text-center">
                              <button type="button" class="btn btn-w-m btn-primary " id="feedback-submit-button">Submit</button>							  
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <jsp:include page="inc/foot.jsp"></jsp:include>
</body>
</html>