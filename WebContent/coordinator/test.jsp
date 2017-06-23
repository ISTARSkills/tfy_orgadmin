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
   boolean flag = false;
   %>
<body class="top-navigation student_pages" id="orgadmin_dashboard">
   <div id="wrapper">
      <div id="page-wrapper" class="gray-bg">
         <jsp:include page="inc/navbar.jsp" />
         <div class="wrapper wrapper-content animated fadeInRight" style="padding: 10px;" id='equalheight'>
            <div class="row">
               <!-- First card of profile with Course level -->
               <div class="col-lg-4">
                  <div class="contact-box">
                     <div class="col-sm-4">
                        <div class="text-center">
                           <img style= "    width: 80px !important;    height: 80px !important; " alt="image" class="img-circle m-t-xs img-responsive" src="https://s-media-cache-ak0.pinimg.com/736x/d4/e4/ea/d4e4ea4504747a5207814334b8232fcd.jpg">
                        </div>
                     </div>
                     <div class="col-sm-8">
                        <h3><strong>Vinay Sharma</strong></h3>
                        <p><i class="fa fa-envelope"></i>&nbsp; vinay@istarindia.com</p>
                        <address>
                           <p><i class="fa fa-phone"></i>&nbsp; 8871552138</p>
                        </address>
                     </div>
                     <table class="table table-bordered">
                        <thead>
                           <tr>
                              <th>Course </th>
                              <th>Level 1</th>
                              <th>Level 2</th>
                              <th>Level 3</th>
                              <th>Level 4</th>
                           </tr>
                        </thead>
                        <tbody>
                           <tr>
                              <td>12/35 &nbsp; <i class="fa fa-check text-navy"></i></td>
                              <td>12/36  &nbsp;  <i class="fa fa-times"></i></td>
                              <td>12/33  &nbsp; <i class="fa fa-check text-navy"></i></td>
                              <td>38  &nbsp; <i class="fa fa-times"></i></td>
                              <td>40  &nbsp; <i class="fa fa-check text-navy"></i></td>
                           </tr>
                        </tbody>
                     </table>
                     <div class="row">
                        <div class="col-lg-12">
                           <h5>Slots:</h5>
                           <button class="btn btn-white btn-xs" type="button">Mon 10:00 - 12:00 AM</button>
                           <button class="btn btn-white btn-xs" type="button">Tue 10:00 - 12:00 AM</button>
                           <button class="btn btn-white btn-xs" type="button">Wed 10:00 - 12:00 AM</button>
                           <button class="btn btn-white btn-xs" type="button">Thur 10:00 - 12:00 AM</button>
                           <button class="btn btn-white btn-xs" type="button">Fri 10:00 - 12:00 AM</button>
                           <button class="btn btn-white btn-xs" type="button">Sat 10:00 - 12:00 AM</button>
                        </div>
                     </div>
                     <div class="row">
                        <div class="col-lg-12">
                           <h5>Cities:</h5>
                           <button class="btn btn-white btn-xs" type="button">Karnataka</button>
                           <button class="btn btn-white btn-xs" type="button">Bangalore</button>
                           <button class="btn btn-white btn-xs" type="button">Assam</button>
                        </div>
                     </div>
                     <div class="row">
                        <div class="col-lg-12">
                           <h5>Cluster:</h5>
                           <button class="btn btn-white btn-xs" type="button">Cluster 1</button>
                           <button class="btn btn-white btn-xs" type="button">Cluster 2</button>
                           <button class="btn btn-white btn-xs" type="button">Cluster 3</button>
                        </div>
                     </div>
                  </div>
               </div>
               <!-- End of first card with profile and end level -->
               <div class="col-lg-4">
                  <div id="card">
                     <div class="front">
                        <div class="ibox-content" id="ibox-content">
                           <div id="vertical-timeline" class="vertical-container dark-timeline ">
                              <div class="vertical-timeline-block">
                                 <div class="vertical-timeline-icon blue-bg">
                                    <i class="fa fa-file-text"></i>
                                 </div>
                                 <div class="vertical-timeline-content">
                                    <h2>Send documents to Mike</h2>
                                    <span class="vertical-date">
                                    Today <br>
                                    <small>Dec 24</small>
                                    </span>
                                 </div>
                              </div>
                              <div class="vertical-timeline-block">
                                 <div class="vertical-timeline-icon blue-bg">
                                    <i class="fa fa-file-text"></i>
                                 </div>
                                 <div class="vertical-timeline-content">
                                    <h2>Send documents to Mike</h2>
                                    <span class="vertical-date">
                                    Today <br>
                                    <small>Dec 24</small>
                                    </span>
                                 </div>
                              </div>
                              <div class="vertical-timeline-block">
                                 <div class="vertical-timeline-icon blue-bg">
                                    <i class="fa fa-file-text"></i>
                                 </div>
                                 <div class="vertical-timeline-content">
                                    <h2>Send documents to Mike</h2>
                                    <span class="vertical-date">
                                    Today <br>
                                    <small>Dec 24</small>
                                    </span>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                     <div class="back">
                        <div class="ibox-content" id="ibox-content">
                           Back content
                             
                           <div id="rateYo"></div>
                           <textarea rows="4" cols="50">
At w3schools.com you will learn how to make a website. We offer free tutorials in all web development technologies.
</textarea>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <jsp:include page="inc/foot.jsp"></jsp:include>
   <script type="text/javascript">
      $(document).ready(function() {
      	 $("#rateYo").rateYo({
      		    rating: 3.6
      		  });
      });
   </script>
</body>
</html>