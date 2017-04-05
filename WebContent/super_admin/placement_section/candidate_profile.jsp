
<%@page import="in.recruiter.service.RecruiterServices"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

int candidateId = 0;

if(request.getParameterMap().containsKey("candidate_id"))
{
	candidateId = Integer.parseInt(request.getParameter("candidate_id"));	
}
DBUTILS util = new DBUTILS();

String candidateDetails ="SELECT 	 	 	\"NameofCandidate\" as nn, 		candidate_id, prev_company, prev_profile, year, remarks, remarks_by  FROM 	candidate_details, candidate_history where candidate_history.candidate_id = candidate_details.id and candidate_details.id = "+candidateId;
List<HashMap<String, Object >> data = util.executeQuery(candidateDetails);

String fname="NA";
if(data.size()>0)
{
	
 fname= data.get(0).get("nn")!=null ?data.get(0).get("nn").toString():" ";
}
RecruiterServices serv = new RecruiterServices();
List<HashMap<String, Object>> skillrating = serv.getStudentRatingPerskill(18);	

%>

<jsp:include page="../inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_analytics">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>
			
			<div class="row animated fadeInRight">
                <div class="col-md-4">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Profile Detail</h5>
                        </div>
                        <div>
                            <div class="ibox-content no-padding border-left-right">
                                <img alt="image" class="img-responsive" style="    width: 120px;" src="http://api.talentify.in/video/android_images/<%=fname.trim().toUpperCase().charAt(0)%>.png">
                            </div>
                            <div class="ibox-content profile-content">
                                <h4><strong><%=fname %></strong></h4>
                             <div class="feed-activity-list">  <%
                               if(data.size()>0)
                               {
                            	   for(HashMap<String,Object> row: data)
                            	   {
                            		   String prof=row.get("prev_profile")!=null ? row.get("prev_profile").toString() : "";
                            		   String comp=row.get("prev_company")!=null ? row.get("prev_company").toString() : "";
                            		   String remark = row.get("remarks")!=null ? row.get("remarks").toString() : "No Remark";
                            		   String remarkBy= row.get("remarks_by")!=null ? row.get("remarks_by").toString() : "No Remark";
                            		   %>
                            		   
                            		    

                                                <div class="feed-element">
                                                    
                                                    <div class="media-body ">
                                                      
                                                       
                                                        <%
                                                        if(!row.get("remarks_by").toString().startsWith("Trainer")){
                                                        	
                                                        
                                                        %>
                                                         <strong><%=row.get("year")%></strong> <%=prof%> <strong>, <%=comp %></strong><br>
                                                        <div class="well">
                                                       <%=remark %>
                                                         </div>
                                                        <div class="pull-right">
                                                            <a class="btn btn-xs btn-white"><%=remarkBy %> </a>
                                                        </div>
                                                        
                                                        <%
                                                        }
                                                        %>
                                                    </div>
                                                </div>
                                                
                                           
                            		   <% 
                            	   }
                               }
                               else
                               {
                            	   
                               }	   
                               %>
                                </div>
                                <h5>
                                    About me
                                </h5>
                                <p>
                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitat.
                                </p>
                                
                            </div>
                    </div>
                </div>
                    </div>
                <div class="col-md-8">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Skill Rating</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                    <i class="fa fa-wrench"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-user">
                                    <li><a href="#">Config option 1</a>
                                    </li>
                                    <li><a href="#">Config option 2</a>
                                    </li>
                                </ul>
                                <a class="close-link">
                                    <i class="fa fa-times"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content " >
                               <div class="user-button">
                                    <div class="row">
                                        <%
                                        if(skillrating.size()==0)
                                        {
                                        	%>
                                        	<h3>Skill Rating Not Available</h3>
                                        	<% 
                                        }
                                        else
                                        {
                                        	for(HashMap<String, Object> row : skillrating)
                                            {
                                            %>
                                            <small><%=(String)row.get("skill_title") %></small>
                                                <div class="stat-percent"><%=(int)row.get("percentile_country")%>% </div>
                                                <div class="progress progress-mini" style="margin-bottom: 11px; ">
                                                    <div style="width: <%=(int)row.get("percentile_country")%>%;" class="progress-bar"></div>
                                                </div>
                                            
                                            <%
                                            }	
                                        }	
                                        
                                        %>
                                    </div>
                                </div>
                            </div>
                    </div>

                </div>
            </div>
			
			
			
			<<%-- div class="row">
				<div
					class="ibox p-xs  b-r-lg border-left-right border-top-bottom border-size-sm gray-bg-admin">
					<div class="ibox float-e-margins" style="overflow-y: scroll; height: 41vh;    overflow-x: hidden;">
                        <div class="ibox-title">
                            <h5>Profile Detail</h5>
                        </div>
                        <div>
                        
                        	<div class="row ">
                        	<div class=" col-md-8">
                                <h4><strong><%=fname %> </strong></h4>
                               
                                <h5>
                                    Interested Domains/Jobs
                                </h5>
                                
                                
                            </div>
                        	 <div class="col-md-4">
                                <img alt="image" class="img-responsive" src="http://api.talentify.in/video/android_images/<%=fname.toUpperCase().charAt(0)%>.png">
                            </div>
                            
                            
                        	</div>
							
							
							<!-- <div class="col-md-4">
                                <div class="ibox float-e-margins">
                                    <div class="ibox-title">
                                        <h5>Your daily feed</h5>
                                        <div class="ibox-tools">
                                            <span class="label label-warning-light pull-right">10 Messages</span>
                                           </div>
                                    </div>
                                    <div class="ibox-content">

                                        <div>
                                            <div class="feed-activity-list">

                                                
                                                <div class="feed-element">
                                                    <a href="profile.html" class="pull-left">
                                                        <img alt="image" class="img-circle" src="img/a5.jpg">
                                                    </a>
                                                    <div class="media-body ">
                                                        <small class="pull-right">2h ago</small>
                                                        <strong>Kim Smith</strong> posted message on <strong>Monica Smith</strong> site. <br>
                                                        <small class="text-muted">Yesterday 5:20 pm - 12.06.2014</small>
                                                        <div class="well">
                                                            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.
                                                            Over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                                                        </div>
                                                        <div class="pull-right">
                                                            <a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> Like </a>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                            </div>

                                            

                                        </div>

                                    </div>
                                </div>

                            </div> -->
							                          
                            <div class="ibox-content " >
                               <div class="user-button">
                                    <div class="row">
                                        <%
                                        if(skillrating.size()==0)
                                        {
                                        	%>
                                        	<h3>Skill Rating Not Available</h3>
                                        	<% 
                                        }
                                        else
                                        {
                                        	for(HashMap<String, Object> row : skillrating)
                                            {
                                            %>
                                            <small><%=(String)row.get("skill_title") %></small>
                                                <div class="stat-percent"><%=(int)row.get("percentile_country")%>% </div>
                                                <div class="progress progress-mini" style="margin-bottom: 11px; ">
                                                    <div style="width: <%=(int)row.get("percentile_country")%>%;" class="progress-bar"></div>
                                                </div>
                                            
                                            <%
                                            }	
                                        }	
                                        
                                        %>
                                    </div>
                                </div>
                            </div>
                    </div>
                </div>
				</div>
			</div> --%>



		</div>
	</div>
	<jsp:include page="../inc/foot.jsp"></jsp:include>
<!-- Mainly scripts -->
</body>
</html>