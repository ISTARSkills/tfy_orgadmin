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

int endIndex = Integer.parseInt(request.getParameter("startIndex").toString()) +15;
String recruiter_id = request.getAttribute("recruiterID").toString();
HashMap<Integer, Student> student = (HashMap<Integer, Student>) request.getAttribute("listOfStudents");

for (Integer st : student.keySet()) {
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
<%}%>
<a href="<%=baseURL%>StudentPaginatorVacancy?startIndex=<%=endIndex%>&recruiterID=<%=recruiter_id%>"></a>	