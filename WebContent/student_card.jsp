<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="tfy.admin.studentmap.pojos.SkillReportPOJO"%>
<%@page import="java.util.List"%>
<%@page import="tfy.admin.services.StudentSkillMapService"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>

</style>
<%

int studentId = Integer.parseInt(request.getParameter("student_id"));
int courseId =0;
StudentSkillMapService reportService = new StudentSkillMapService();
List<HashMap<String,Object>> courses = reportService.getCoursesOfUser(studentId);

if(courses.size()>0)
{
	courseId = 	(int)courses.get(0).get("id");
}
if(request.getParameterMap().containsKey("course_id"))
{
	courseId = Integer.parseInt(request.getParameter("course_id"));
}

IstarUser stu = new IstarUserDAO().findById(studentId);
String profileImage = stu.getUserProfile()!=null ? (stu.getUserProfile().getProfileImage()!=null ?stu.getUserProfile().getProfileImage(): "/users/"+stu.getEmail().toUpperCase().charAt(0)+".png") : "/users/"+stu.getUserProfile().getFirstName().trim().toUpperCase().charAt(0)+".png";
%>
<%
	String path = request.getContextPath();
	String basePath = "http://cdn.talentify.in/";
	

	try {
		Properties properties = new Properties();
		String propertyFileName = "app.properties";
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
		if (inputStream != null) {
			properties.load(inputStream);
			basePath = properties.getProperty("cdn_path");
		}
	} catch (IOException e) {
		e.printStackTrace();
	}
	
	
%>
<link href="<%=basePath%>assets/css/style.css" rel="stylesheet">
<div class="modal-dialog">
	<div class="modal-content animated flipInY">
		<div class="modal-header customcss_studentcard-header">

			<button type="button" class="close" data-dismiss="modal">
				<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
			</button>
			<div class="m-b-md">
				<h2 class="font-bold no-margins">
					<%=stu.getUserProfile().getFirstName()%>
				</h2>

				<div>
					<span class="fa fa-envelope m-r-xs"></span>

					<%=stu.getEmail()%>
					| <span class="fa fa-phone m-r-xs"></span>

					<%=stu.getMobile()%>
				</div>
			</div>
		</div>

		<div class="modal-body customcss_studentcard-body">
			<%
						if(courses.size()>0)
						{
						
												
												%>
			<div class="tabs-container">
				<ul class="nav nav-tabs student-nav">
					<%
                        for(HashMap<String, Object> course: courses)
												{
                        	int courseID = (int) course.get("id");
                        	String courseName = (String)course.get("course_name");
                        	String courseImage = (String)course.get("course_image");
                        	String active="";
                        	if(courseId==courseID)
                        	{
                        		active="active";
                        	}
                        %>
					<li class="<%=active%>"><a data-toggle="tab" class='customcss_studentcard-course' href="#tab-<%=courseID%>"> 
					<img alt="image" class="img-circle customcss_studentcard-img" src="<%=courseImage%>"> 
					<span class="label label-danger customcss_studentcard-label"><%=courseName%> </span>
					</a></li>

					<%
												}
                             %>
				</ul>
				<div class="tab-content">
					<%
                        for(HashMap<String, Object> course: courses)
												{
                        	int courseID = (int) course.get("id");
                        	String courseName = (String)course.get("course_name");
                        	String courseImage = (String)course.get("course_image");
                        	String active="";
                        	if(courseId==courseID)
                        	{
                        		active="active";
                        	}
                        	SkillReportPOJO courseSkill =  reportService.getSkillsReportForCourseOfUser(studentId,courseID);
                        	String rank = reportService.getUserRankInCourse(studentId,courseID);
                        %>
					<div id="tab-<%=courseID %>" class="tab-pane <%=active%>">
						<div class="panel-body">
							<div id="rank_holder" class="widget-head-color-box navy-bg p-lg text-center">

								<div class="row customcss_studentcard-row">
									<div class="col-md-4 customcss_studentcard-col-4">
										<% String batchRank = rank;
                           String pointsEarned = courseSkill.getUserPoints()!=null ? courseSkill.getUserPoints()+"" : "N/A";
                              %>
										<h2 class="font-bold"><%=batchRank%></h2>
										<h3>
											<span> Batch Rank </span>
										</h3>
									</div>
									<div class="col-md-4 customcss_studentcard-profile">
										<img src="http://cdn.talentify.in:9999/<%=profileImage%>" class="img-circle circle-border m-b-md customcss_studentcard-profile_img" alt="profile">

									</div>
									<div class="col-md-4 customcss_studentcard-col-4">
										<h2 class="font-bold"><%=pointsEarned %></h2>
										<h3>
											<span> Points Earned </span>
										</h3>
									</div>
								</div>

							</div>
							
							<!--skill tree starts here  -->
					<%if(courseSkill.getSkills().size()>0)
						{%>		
					<div class="col-lg-12 customcss_p-f-none customcss_p-r-none customcss_skill_holder" id="skill_holder">
                    <!--  -->
                    <div class="ibox ">
                        <div class="ibox-title">
                            <h2>Skill Profile</h2>
                        </div>
                        <div class="ibox-content" >
                        
                        <div class="full-height div-scroll-height-2 customcss_skilllist">
				<div class="full-height-scroll">
		  
		  	
		    <% 
		   
		    for(SkillReportPOJO subSkill:  courseSkill.getSkills()){
		    %>
		        <div class="col-md-12 customcss_p-f-none">
		            <ul class="tree1">
		                <li><%=subSkill.getName()%>
		                    <ul> 
		                    <% double percentagesubSkill=0;
                                            	
                                            	if(subSkill.getPercentage()!=null && subSkill.getPercentage()!=0){
                                                      percentagesubSkill= (subSkill.getPercentage());
                                                      
                                            	}
                                                     %>
		                    <div class="progress customcss_progressbar">
		                                <div style="width: <%=percentagesubSkill%>%; " aria-valuemax="100" aria-valuemin="0" aria-valuenow="<%=percentagesubSkill%>" role="progressbar" class="progress-bar ">
		                                    
		                                </div>
		                            </div>
		                        <p><%=subSkill.getUserPoints() %> / <%=subSkill.getTotalPoints()%> Points.</p>
		                     <%if(subSkill.getSkills().size()>0)
                                        	{%>
                                        	<%for(SkillReportPOJO child : subSkill.getSkills()){ %>
		                        <li><%=child.getName()%>
		                        
		                         <%
                                                     double percentageChild=0;
                                                 	if(child.getPercentage()!=null && child.getPercentage()!=0){
                                                 		percentageChild= child.getPercentage();
                                                 		
                                                 	}
                                                     %>
		                         <div class="progress customcss_progressba" >
		                                <div style="width: <%=percentageChild%>%; " aria-valuemax="100" aria-valuemin="0" aria-valuenow="<%=percentageChild%>" role="progressbar" class="progress-bar">
		                                    
		                                </div>
		                            </div>
		                        
		                        </li>
		                        
		                       <%}
                                        	
		                       } %>
		                           
		                    </ul>
		                </li>
		                
		            </ul>
		        </div>
		        <%} 
		        //Now for the skill that are not scored
		        			        
		        
		        
		        
		        %>            

</div></div>
                        </div>

                    </div>
                </div>
						
						<%
						
						}
					else {
						%>
						<h2>No skills are scored in this course.</h2>
						
						<% 
					}
						%>	
							<!-- skill tree ends here -->
						</div>
					</div>
					<%
												}
                          %>
				</div>
			</div>

			<%
												} // will be visioble if there will be atlest one course
						else{
													
													%>
													 <h2 class='text-center'> No Skill Profile Available.</h2>
													<% 
						}
												%>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>

		</div>

	</div>
</div>
<div id="progress-nos" va="50"></div>
<script src="<%=basePath %>assets/js/circular-custom-plugin.js"></script>
