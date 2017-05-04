<%@page import="tfy.admin.studentmap.pojos.SkillReportPOJO"%>
<%@page import="java.util.List"%>
<%@page import="tfy.admin.services.StudentSkillMapService"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<style>
/*tree related  */
.tree1>li {
	padding: 0 !important;
}

.progress {
	height: 6px;
	margin-bottom: 0px !important;
}

ul>.progress {
	margin-left: 2%;
}

li>.progress {
	
}

ul>p {
	margin-left: 2%;
}

.tree, .tree ul {
	margin: 0;
	padding: 0;
	list-style: none
}

.tree ul {
	margin-left: 5px;
	position: relative
}

.tree ul ul {
	margin-left: .5em
}

.tree ul:before {
	content: "";
	display: block;
	width: 0;
	position: absolute;
	top: 0;
	bottom: 0;
	left: 0;
	border-left: 1px solid
}

.tree li {
	margin: 0;
	padding: 0 33px;
	line-height: 2em;
	font-weight: 700;
	position: relative
}

.tree ul li:before {
	content: "";
	display: block;
	width: 30px;
	height: 0;
	border-top: 1px solid;
	margin-top: -1px;
	position: absolute;
	top: 1em;
	left: 0
}

.tree ul li:last-child:before {
	background: #fff;
	height: auto;
	top: 1em;
	bottom: 0
}

.indicator {
	margin-right: 5px;
}

.tree li a {
	text-decoration: none;
	color: #369;
}

.tree li button, .tree li button:active, .tree li button:focus {
	text-decoration: none;
	color: #369;
	border: none;
	background: transparent;
	margin: 0px 0px 0px 0px;
	padding: 0px 0px 0px 0px;
	outline: 0;
}
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
String profileImage = stu.getUserProfile()!=null ? stu.getUserProfile().getProfileImage() : "video/android_images/"+stu.getUserProfile().getFirstName().toUpperCase().charAt(0)+".png";
%>
<div class="modal-dialog">
	<div class="modal-content animated flipInY">
		<div class="modal-header" style="padding: 13px 18px !important;">

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

		<div class="modal-body" style="padding: 0px 2px 9px 2px !important; background-color: #e8e8e9;">
			<%
						if(courses.size()>0)
						{
						
												
												%>
			<div class="tabs-container">
				<ul class="nav nav-tabs">
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
					<li class="<%=active%>"><a data-toggle="tab" href="#tab-<%=courseID%>" style=" height: 87px;  padding: 5px; width: 98px; text-align: center; display: inline-block;"> 
					<img alt="image" class="img-circle" src="<%=courseImage%>" style="width: 40px; height: 40px; margin-bottom: 3px;"> 
					<span style="white-space: normal; display: block; min-height: 36px;" class="label label-danger"><%=courseName%> </span>
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
							<div id="rank_holder" class="widget-head-color-box navy-bg p-lg text-center" style="margin-top: -14px;
    margin-left: -17px;
    margin-right: -18px; padding: 8px !important;     border-radius: 4px;">

								<div class="row" style="height: 121px;">
									<div class="col-md-4" style="margin-top: 22px;">
										<% String batchRank = rank;
                           String pointsEarned = courseSkill.getUserPoints()!=null ? courseSkill.getUserPoints()+"" : "N/A";
                              %>
										<h2 class="font-bold"><%=batchRank%></h2>
										<h3>
											<span> Batch Rank </span>
										</h3>
									</div>
									<div class="col-md-4" style="height: 98px;     margin-top: 11px;">
										<img src="<%=profileImage%>" class="img-circle circle-border m-b-md" alt="profile" style="width: 98px;
    height: 98px;">

									</div>
									<div class="col-md-4" style="margin-top: 22px;">
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
					<div class="col-lg-12" id="skill_holder" style="    padding-left: 0px;    padding-right: 0px;        margin-left: -17px;">
                    <!--  -->
                    <div class="ibox ">
                        <div class="ibox-title">
                            <h2>Skill Profile</h2>
                        </div>
                        <div class="ibox-content" >
                        <div class="full-height div-scroll-height-2"
				style="height: 232px !important;">
				<div class="full-height-scroll">
		  
		  	
		    <% 
		   
		    for(SkillReportPOJO subSkill:  courseSkill.getSkills()){
		    %>
		        <div class="col-md-12" style="padding-left: 0px !important;">
		            <ul class="tree1">
		                <li><%=subSkill.getName()%>
		                    <ul> 
		                    <% double percentagesubSkill=1;
                                            	
                                            	if(subSkill.getPercentage()!=null && subSkill.getPercentage()!=0){
                                                      percentagesubSkill= (subSkill.getPercentage());
                                                      
                                            	}
                                                     %>
		                    <div class="progress " >
		                                <div style="width: <%=percentagesubSkill%>%; padding:20px;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="<%=percentagesubSkill%>" role="progressbar" class="progress-bar ">
		                                    
		                                </div>
		                            </div>
		                        <p><%=subSkill.getUserPoints() %> / <%=subSkill.getTotalPoints()%> Points.</p>
		                     <%if(subSkill.getSkills().size()>0)
                                        	{%>
                                        	<%for(SkillReportPOJO child : subSkill.getSkills()){ %>
		                        <li><%=child.getName()%>
		                        
		                         <%
                                                     double percentageChild=1;
                                                 	if(child.getPercentage()!=null && child.getPercentage()!=0){
                                                 		percentageChild= child.getPercentage();
                                                 		
                                                 	}
                                                     %>
		                         <div class="progress"  >
		                                <div style="width: <%=percentageChild%>%; padding:20px;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="<%=percentageChild%>" role="progressbar" class="progress-bar">
		                                    
		                                </div>
		                            </div>
		                        
		                        </li>
		                        
		                       <%}
                                        	
		                       } %>
		                           <!--  <li>Company Maintenance
		                         <div class="progress"  >
		                                <div style="width: 10%; padding:20px;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="35" role="progressbar" class="progress-bar">
		                                    <span class="sr-only">35% Complete (success)</span>
		                                </div>
		                            </div>
		                        
		                        </li> -->
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
												%>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>

		</div>

	</div>
</div>