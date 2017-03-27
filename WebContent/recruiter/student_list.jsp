<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.istarindia.apps.dao.StageActionMapping"%>
<%@page import="java.util.UUID"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="in.recruitor.utils.RecrutUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<% 
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";

String stage_id = request.getAttribute("stage_id").toString();//request.getParameter("stage_id");
int vacancyID = Integer.parseInt(request.getAttribute("vacancyID").toString());
String collegeID = request.getAttribute("collegeID").toString();
int endIndex = Integer.parseInt(request.getParameter("startIndex").toString()) +15;

HashMap<Integer, Student> student = (HashMap<Integer, Student>) request.getAttribute("listOfStudents");
IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stage_id));
String stageType="";
String stageAction ="";
if(stage.getStageActionMappings()!=null && !stage.getStageActionMappings().isEmpty())
{
	StageActionMapping stage_action_map = stage.getStageActionMappings().iterator().next();
	stageType = stage_action_map.getType();
	stageAction = stage_action_map.getStageAction();
}

RecrutUtils utils = new RecrutUtils();
RecruiterServices recruiterServices = new RecruiterServices();

for (Integer st : student.keySet()) {
if(stage.getStage().equalsIgnoreCase("TARGETED")){
%>
				<div
					class="feed-element student_holder_actor row" id="<%=student.get(st).getId()%>">
					<div class="col-lg-2">
						<img alt="image"
							class="img-circle profile_image student_image-<%=student.get(st).getId()%>"
							src="<%=student.get(st).getImageUrl()%>"
							data-student="<%=student.get(st).getId()%>">
					</div>

					<div class="student_details_pane col-lg-10">
						<strong class="student_name"><%=student.get(st).getName()%></strong>
						<br> <small class="text-muted organization_name"><%=student.get(st).getCollege().getName()%></small>
						<%
							String ugDegreeName = student.get(st).getStudentProfileData().getUnder_graduate_degree_name();
								if (ugDegreeName != null) {
						%>
						<br> <small class="text-muted batch_name_name"><%=ugDegreeName%></small>
						<%
							String ugDegreeSpecialization = student.get(st).getStudentProfileData()
											.getUnderGraduationSpecializationName();
									if (ugDegreeSpecialization != null) {
						%>
						<small class="text-muted batch_name_name">(<%=ugDegreeSpecialization%>)
						</small>
						<%
							}
								}
							String pgDegreeName	= student.get(st).getStudentProfileData().getPg_degree_name();
							if (pgDegreeName != null) {	
						%>
						<br><small class="text-muted batch_name_name"><%=pgDegreeName%></small>
						<%
							String pgDegreeSpecialization = student.get(st).getStudentProfileData()
											.getPostGraduationSpecializationName();
								if (pgDegreeSpecialization != null) {
						%>
						<small class="text-muted batch_name_name">(<%=pgDegreeSpecialization%>)
						</small>
						<%} } %>
					</div>
				</div>
<%} else { %>

					<div data-vacancy_id="<%=vacancyID%>"
						class="feed-element student_holder_actor row"
						data-stage_id="<%=vacancyID%>--<%=stage_id%>"
						data-stage="<%=stage_id%>" id="<%=student.get(st).getId()%>" data-college="<%=collegeID%>">
							<a class="col-lg-2 profile_image_link"> <img alt="image" class="img-circle profile_image student_image-<%=student.get(st).getId()%>"
								data-percentile="<%=recruiterServices.getCountryPercentileForEachStudent(student.get(st).getId())%>" src="<%=student.get(st).getImageUrl()%>" data-student="<%=student.get(st).getId()%>">
							</a>
							
					<div class="student_details_pane col-lg-7">
						<strong class="student_name"><%=student.get(st).getName()%></strong>
						<br> <small class="text-muted organization_name"><%=student.get(st).getCollege().getName()%></small>
						<%
							String ugDegreeName = student.get(st).getStudentProfileData().getUnder_graduate_degree_name();
								if (ugDegreeName != null && !ugDegreeName.trim().isEmpty()) {
						%>
						<br> <small class="text-muted batch_name_name"><%=ugDegreeName%></small>
						<%
							String ugDegreeSpecialization = student.get(st).getStudentProfileData()
											.getUnderGraduationSpecializationName();
									if (ugDegreeSpecialization != null && !ugDegreeSpecialization.trim().isEmpty()) {
						%>
						<small class="text-muted batch_name_name">(<%=ugDegreeSpecialization%>)
						</small>
						<%
							}
								}
							String pgDegreeName	= student.get(st).getStudentProfileData().getPg_degree_name();
							if (pgDegreeName != null && !pgDegreeName.trim().isEmpty()) {	
						%>
						<br><small class="text-muted batch_name_name"><%=pgDegreeName%></small>
						<%
							String pgDegreeSpecialization = student.get(st).getStudentProfileData()
											.getPostGraduationSpecializationName();
								if (pgDegreeSpecialization != null && !pgDegreeSpecialization.trim().isEmpty()) {
						%>
						<small class="text-muted batch_name_name">(<%=pgDegreeSpecialization%>)
						</small>
						<%} } %>
					</div>
							<div class="col-lg-3 student_checkbox">
							<div class="pull-right">
								<input type="checkbox"
									data-stage_id="<%=stage_id%>"
									class="i-checks <%=vacancyID%> <%=stage_id%> <%=collegeID%> student_checkbox-<%=vacancyID%>-<%=stage_id%><%=collegeID%> <%=student.get(st).getId()%>"
									data-college="<%=collegeID%>"
									data-student_id="<%=student.get(st).getId()%>" name="send_msg"
									id="">
							</div>
							
							<%
							String style= "    margin-left: 20px;";
							if(!stageType.equalsIgnoreCase("interview") && !stageType.equalsIgnoreCase("Offered"))
							{
								style="    margin-left: 71px;";
							}
							%>
							<div class="cal-notification" style="<%=style%>">
									<div class="notification_box pull-left">
										<img src="/img/send_notif.png" class="chat_box chat_box11111"
											id="student_chat_box<%=vacancyID%>--<%=stage_id%><%=collegeID%>--<%=student.get(st).getId()%>"/>
									</div>
									<%if(stageType.equalsIgnoreCase("interview")) 
									{
									%>
									<div class="calendar_box " id="student_scheduler_box<%=vacancyID%>--<%=stage_id%><%=collegeID%>--<%=student.get(st).getId()%>"
									data-vacancy="<%=vacancyID%>" data-stage="<%=stage_id%>" data-student="<%=student.get(st).getId()%>" data-college="<%=collegeID%>">
										<img src="/img/schedule.png"/>
									</div>
									<%
									}else if(stageType.equalsIgnoreCase("Offered")){								
									%>
							<div class="offer_letter_button" id="offer_letter-<%=vacancyID%>--<%=stage_id%><%=collegeID%>--<%=student.get(st).getId()%>" 
							data-vacancy="<%=vacancyID%>" data-stage="<%=stage_id%>" data-student="<%=student.get(st).getId()%>" data-college="<%=collegeID%>">
										<img src="/img/send.png" />
							</div>
									<%} %>
							</div>
							</div>
						<% if(stageType.equalsIgnoreCase("Offered")){
								String offerLetterURL = utils.getOfferLetter(vacancyID, student.get(st).getId());	
								if(offerLetterURL!=null && !offerLetterURL.trim().isEmpty()){%>
							<div class="existing_offer_letter pull-left">
							<a href="<%=utils.getOfferLetter(vacancyID, student.get(st).getId())%>" target="_blank">Download Offer Letter</a>
							</div>
							<% }	
							}%>
					</div>
<%}
}%>
<center><a href="<%=baseURL%>StudentPaginatorRecruiter?startIndex=<%=endIndex%>&stageID=<%=stage_id%>&vacancyID=<%=vacancyID%>&collegeID=<%=collegeID%>"><i class="fa fa-chevron-down" aria-hidden="true"></i></a></center>