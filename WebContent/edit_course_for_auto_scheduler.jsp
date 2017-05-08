<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroupDAO"%>
<%@page import="com.viksitpro.core.dao.entities.BatchGroup"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
String entityType = request.getParameter("entity_type");
String entityId = request.getParameter("entity_id");
String courseId = request.getParameter("course_id");
Course course = new CourseDAO().findById(Integer.parseInt(courseId));
String entityName = ""; 
int total_session = 0 ;
int total_lessons = 0;
int stuCount=0;
DBUTILS util = new DBUTILS();
String courseSQl ="select cast (count(DISTINCT cmsession_module.cmsession_id) as integer) as cmsessions, cast (count(DISTINCT lesson_cmsession.lesson_id) as integer) as lessons from module_course, cmsession_module, lesson_cmsession where module_course.course_id = "+courseId+" and module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = lesson_cmsession.cmsession_id";
List<HashMap<String, Object>> courseData = util.executeQuery(courseSQl);
if(courseData.size()>0)
{	for(HashMap<String, Object> row: courseData)
	{
		total_session =(int) row.get("cmsessions"); 
		total_lessons =(int) row.get("lessons");
	}	
}

if(entityType.equalsIgnoreCase("USER"))
{
	IstarUser user = new IstarUserDAO().findById(Integer.parseInt(entityId));
	entityName =  user.getEmail();
	stuCount = 1;
}
else
{
	BatchGroup group = new BatchGroupDAO().findById(Integer.parseInt(entityId));
	entityName = group.getName();
	if(group.getBatchStudentses()!=null){
		stuCount = group.getBatchStudentses().size();
	}
}

Timestamp startDate = null;
Timestamp endDate = null;
ArrayList <String>scheduledDays=new ArrayList();
int freq = 0;
String sql="select entity_id, entity_type, start_date, end_date, scheduled_days, frequency from auto_scheduler_data where entity_id = "+entityId+" and entity_type = '"+entityType+"'";
List<HashMap<String, Object>> data = util.executeQuery(sql);
if(data.size()>0)
{	for(HashMap<String, Object> row: data){
		startDate = (Timestamp)	row.get("start_date");
		endDate = (Timestamp)	row.get("end_date");
		scheduledDays =(ArrayList <String>) Arrays.asList(row.get("scheduled_days").toString().split(","));
		freq = (int)row.get("frequency");
	}
}

%>    
<div class="col-md-12">
<input id="scheduler_entity_id" type="hidden" value="<%=entityId%>">
<input id="scheduler_entity_type" type="hidden" value="<%=entityType%>">
<input id="scheduler_course_id" type="hidden" value="<%=courseId%>">
<input id="scheduler_total_lessons" type="hidden" value="<%=total_lessons%>">
										<div class="profile-info" style="margin-left: 0px !important;">
											<div class="">
												<div>
													<h2 class="no-margins"><%=course.getCourseName() %></h2>
													<h3><%=entityType %> : <%=entityName %></h3>
												</div>
											</div>
										</div>
										<div class="row  m-t-sm">
											<div class="col-sm-4">
												<div class="font-bold">#Students</div>
												<%=stuCount %>
											</div>
											<div class="col-sm-4">
												<div class="font-bold">#Sessions</div>
												<%=total_session %>
											</div>
											<div class="col-sm-4">
												<div class="font-bold">#Lessons</div>
												<%=total_lessons %>
											</div>
										</div>
										<br>
										<div class="form-group" id="data_5">
                                <label>Start Date - End Date</label>
                                <div class="input-daterange input-group" id="datepicker">
                                    <input id ="sd" type="text" class="input-sm form-control" name="start" <%if(startDate!=null) { %>value="<%=startDate%>" <% } %> />
                                    <span class="input-group-addon">to</span>
                                    <input id ="ed" type="text" class="input-sm form-control" name="end" <%if(endDate!=null) { %>value="<%=endDate%>" <% } %> />
                                </div>
                            </div>										
										<div class="form-group">
											<label>Select Days of Week &nbsp;</label><br> <label class="checkbox-inline"> 
											<input type="checkbox" value="SUN" name="scheduled_days" <%if(scheduledDays.contains("SUN")) { %>checked<% } %>> SUN
											</label> <label class="checkbox-inline"> <input type="checkbox" value="MON" name="scheduled_days" <%if(scheduledDays.contains("MON")) { %>checked<% } %>> MON
											</label> <label class="checkbox-inline"> <input type="checkbox" value="TUE" name="scheduled_days" <%if(scheduledDays.contains("TUE")) { %>checked<% } %>> TUE
											</label> <label class="checkbox-inline"> <input type="checkbox" value="WED" name="scheduled_days" <%if(scheduledDays.contains("WED")) { %>checked<% } %>> WED
											</label><br> <label class="checkbox-inline"> <input type="checkbox" value="THU" name="scheduled_days" <%if(scheduledDays.contains("THU")) { %>checked<% } %>> THU
											</label> <label class="checkbox-inline"> <input type="checkbox" value="FRI" name="scheduled_days" <%if(scheduledDays.contains("FRI")) { %>checked<% } %>> FRI
											</label> <label class="checkbox-inline"> <input type="checkbox" value="SAT" name="scheduled_days" <%if(scheduledDays.contains("SAT")) { %>checked<% } %>>  SAT
											</label>
										</div>
										<div class="form-group">
											<label>Tasks Per Day</label>
											<input type="text" class="form-control"  disabled name="frequency" <%=freq%> id="freq">
										</div>
								<div class="form-group">
                                    <button class="btn btn-primary" type="submit" id="save_auto_schedule">Save </button>
                                </div>
									</div>