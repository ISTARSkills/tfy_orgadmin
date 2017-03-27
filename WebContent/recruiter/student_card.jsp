<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.recruiter.services.RecruiterServices"%>
<%@page import="com.istarindia.apps.dao.StudentDAO"%>
<%@page import="com.istarindia.apps.dao.Student"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	
	<% 
	
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	int studentID = Integer.parseInt(request.getParameter("student_id"));
	Student student = new StudentDAO().findById(studentID);
	String location = student.getAddress().getPincode().getCity()+", "+student.getAddress().getPincode().getState();
	String college = (student.getCollege()!=null)? student.getCollege().getName() : "N/A";
	String degree ="N/A";
	String intrested_job_domains = "N/A";
	String fname=student.getName();
	//String lastname="";
	if(student.getStudentProfileData()!=null)
	{		
		//fname= (student.getStudentProfileData().getFirstname()!=null)? student.getStudentProfileData().getFirstname() : student.getEmail(); 
		//lastname= (student.getStudentProfileData().getLastname()!=null)? student.getStudentProfileData().getLastname() : "";
		 degree =(student.getStudentProfileData().getUnderGraduationSpecializationName()!=null)? student.getStudentProfileData().getUnderGraduationSpecializationName() : "N/A";
		 intrested_job_domains =( student.getStudentProfileData().getJobSector()!=null)? student.getStudentProfileData().getJobSector() : "N/A";
	}
	 
	RecruiterServices serv = new RecruiterServices();
	List<HashMap<String, Object>> skillrating = serv.getStudentRatingPerskill(student.getId());	
	%>
	<div class="student_card">
	<div class="ibox float-e-margins" style="overflow-y: scroll; height: 41vh;    overflow-x: hidden;">
                        <div class="ibox-title">
                            <h5>Profile Detail</h5>
                        </div>
                        <div>
                        
                        	<div class="row ">
                        	<div class=" col-md-8">
                                <h4><strong><%=fname %> </strong></h4>
                                <p><i class="fa fa-map-marker"></i> <%=location %></p>
                                <p><i class="fa fa-university"></i> <%=college %></p>
                                 <p><i class="fa fa-graduation-cap"></i> <%=degree %></p>
                                <h5>
                                    Interested Domains/Jobs
                                </h5>
                                <p>
                                    <%=intrested_job_domains%>
                                </p>
                                
                            </div>
                        	 <div class="col-md-4">
                                <img alt="image" class="img-responsive" src="<%=student.getImageUrl()%>">
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
