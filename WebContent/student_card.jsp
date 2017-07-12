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
/*tree related  */
.rank {
	margin-top: 3%;
}

.profile-header {
	background: lightgray;
	vertical-align: middle;
	padding: 6px;
	height: 30px;
	color: grey;
}

@media only screen and (min-width: 992px) {
	.position-no {
		font-size: 14px;
		color: #ffffff;
		background-color: #23b6f9;
		padding: 6px 12px;
		position: absolute;
		bottom: 55;
		right: 37%;
		border-radius: 50%;
		padding-left: 5px;
		padding-right: 6px;
	}
	.account-setting-camera-position {
		font-size: 14px;
		color: #ffffff;
		background-color: #23b6f9;
		padding: 6px 12px;
		position: absolute;
		bottom: 55;
		right: 42%;
		border-radius: 50%;
		padding-left: 5px;
		padding-right: 6px;
	}
}

@media only screen and (min-device-width : 320px) and (max-device-width
	: 480px) {
	.position-no {
		font-size: 14px;
		color: #ffffff;
		background-color: #23b6f9;
		padding: 6px 12px;
		position: absolute;
		top: 75;
		right: 0;
		border-radius: 50%;
		padding-left: 7px;
		padding-right: 7px;
	}
}

.scroll-horizontally-div {
	overflow: auto;
	display: flex;
	background: lightgray;
}

/*start  */
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
/* end */
/*Start of plugin css  */
.circular-progress-bar {
	position: relative;
	margin: 0 auto;
}

.progress-percentage, .progress-text {
	position: absolute;
	width: 100%;
	top: 50%;
	left: 59%;
	transform: translate(-50%, -50%);
	text-align: center;
}

.progress-percentage {
	font-size: 18px;
	transform: translate(-50%, -85%);
}

.progress-text {
	transform: translate(-50%, 0%);
	color: #888888;
	font-size: 11px;
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

		<div class="modal-body" style="padding: 0px 2px 0px 2px !important; background-color: #e8e8e9;">
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
										<img src="http://cdn.talentify.in:9999/<%=profileImage%>" class="img-circle circle-border m-b-md" alt="profile" style="width: 98px;
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
		                    <% double percentagesubSkill=0;
                                            	
                                            	if(subSkill.getPercentage()!=null && subSkill.getPercentage()!=0){
                                                      percentagesubSkill= (subSkill.getPercentage());
                                                      
                                            	}
                                                     %>
		                    <div class="progress" style="height: 5px !important; display: block;">
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
		                         <div class="progress" style="height: 5px !important;" >
		                                <div style="width: <%=percentageChild%>%; " aria-valuemax="100" aria-valuemin="0" aria-valuenow="<%=percentageChild%>" role="progressbar" class="progress-bar">
		                                    
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
						else{
													
													%>
													 <h2 style=" text-align: center;"> No Skill Profile Available.</h2>
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
<script>

$(document).ready(function() {
var progress;
progress = $('#progress-nos').attr('va');
console.log("progress------" + progress);
$(".my-progress-bar").circularProgress({
	line_width : 4,
	height : "140px",
	width : "140px",
	color : "#eb384f",
	starting_position : 0, // 12.00 o' clock position, 25 stands for 3.00 o'clock (clock-wise)
	percent : 0, // percent starts from
	percentage : true,
	text : "Profile Completed"
}).circularProgress('animate', progress, 5000);

$('.btn-white').click(function(){
	var icon_class = $(this).find('i').attr('class');
	var button_icon = $(this).find('i');
	if(icon_class === 'fa fa-pencil'){
		button_icon.removeClass(icon_class);
		button_icon.addClass('fa fa-check');
		$(this).parent().siblings().removeAttr('disabled');
		
	}else{
		button_icon.removeClass(icon_class);
		button_icon.addClass('fa fa-pencil');
		$(this).parent().siblings().attr('disabled', 'disabled');
		
		
		var serialized = form.serialize();
		console.log(serialized);
		$.ajax({
	        type: "POST",
	        url: "gvygv",
	        data: {serialized},
	        success: function(data) {
	        	console.log('success');
	        }});
		
	}
});
});
</script>