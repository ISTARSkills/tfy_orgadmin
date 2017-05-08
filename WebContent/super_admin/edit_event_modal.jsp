<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.viksitpro.core.dao.entities.*"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.UUID"%>

<%@page import="in.talentify.core.utils.UIUtils"%>
<%
				String url = request.getRequestURL().toString();
				String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
						+ request.getContextPath() + "/";
				
						
					
				boolean istrue = false;				
				IstarUserDAO studentDAO = new IstarUserDAO();
				IstarUser student = new IstarUser();
				ClassroomDetailsDAO classroomDetailsDAO = new ClassroomDetailsDAO();
				ClassroomDetails classroomDetails = new ClassroomDetails();
				
				UIUtils ui = new UIUtils();
				Batch batch = new Batch();
				String evntid = "";
				String eventDate = "08/09/2014";
				String eventTime = "09:30";
				int eventHours = 0;
				int eventminute = 0;
				int trainerID = 0;
				String trainerName = "defalut@mail.com";
				int classroomID = 0;
				String classroomName = "";
				int batchID=0;
				int courseID = 0;
				String tabType ="";
				int AdminUserID =0;
				int orgID=0;
				String associateTrainerID = null;
				String selectedTrainerString="0";
				ArrayList<Integer> setactedTrainer = new ArrayList();

if(request.getParameter("newEventID")!=null){
	istrue = true;
					 evntid = request.getParameter("newEventID");
					 trainerID = Integer.parseInt(request.getParameter("trainerID"));
					 AdminUserID = Integer.parseInt(request.getParameter("AdminUserID"));
					 orgID = Integer.parseInt(request.getParameter("orgID"));
					 trainerName = request.getParameter("trainerName");
					 eventminute = Integer.parseInt(request.getParameter("minute"));
					 eventHours = Integer.parseInt(request.getParameter("hours"));
					  batchID = Integer.parseInt(request.getParameter("batchID"));
					 classroomID = Integer.parseInt(request.getParameter("classroomID"));
					 String eventType = request.getParameter("eventType");
					 eventDate = request.getParameter("eventDate");
					 eventTime = request.getParameter("startTime");
					 tabType = request.getParameter("tabType");	
					System.out.print("------------>"+eventTime);
					 associateTrainerID = request.getParameter("associateTrainerID");
						if(associateTrainerID != null && !associateTrainerID.equalsIgnoreCase("")){
							selectedTrainerString=associateTrainerID;
					 if (associateTrainerID.contains(",")) {
						 for (String retval: associateTrainerID.split(",")) {
							 setactedTrainer.add(Integer.parseInt(retval));
					      }
						 
					 }else{
						 setactedTrainer.add(Integer.parseInt(associateTrainerID));
					 }
}else{
	setactedTrainer = null;
}
					
					
					 student = studentDAO.findById(trainerID);
					 student.getEmail();
					
						classroomDetails = classroomDetailsDAO.findById(classroomID);
						
				}
			%>


<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
	<button type="button" class="close" data-dismiss="modal">
		<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
	</button>
	<h4 class="modal-title text-center">Modify Events Details</h4>

</div>
<div class="modal-body">

	<form id="idForm4" class="form-horizontal">
<input type="hidden" name="eventID" value="<%=istrue?evntid:""%>"/>
<input type="hidden" name="eventType" value="session"/>
<input type="hidden" name="AdminUserID" value="<%=istrue?AdminUserID:""%>"/>
<input type="hidden" name="orgID" value="<%=istrue?orgID:""%>"/>
<input type="hidden" name="batchID" value="<%=istrue?batchID:""%>"/>
<input type="hidden" name="tabType" value="<%=istrue?tabType:""%>"/>
		<div class="form-group" id="data_2">
			<div class="col-lg-12">
				<label class="font-bold">Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" class="form-control" name="eventDate" value="<%=istrue?eventDate:""%>">
				</div>
			</div>
		</div>

		<div class="form-group">
			<label class="font-bold">Start Time</label>
			<div class="input-group" data-autoclose="true">
				 <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span><%-- <input type="text" style="width: 100%; height: 28px;" name="startTime" id="currenTime" class="timepicker" value="<%=istrue ? eventTime : ""%>"/> --%>
					<input type="text" style="width: 100%; height: 35px;" name="startTime" class="time_element" id="currenTime" value="<%=istrue ? eventTime : ""%>"/>
				</div> 
			<%-- <div class="input-group clockpicker " data-autoclose="true">
				<input type="text" class="form-control" name="startTime" value="<%=istrue?eventTime:""%>"> <span
					class="input-group-addon"> <span class="fa fa-clock-o"></span>
				</span>
			</div> --%>
			
		</div>
		<div class="form-group form-inline">
			<label class="sr-only">Hours</label> <input type="number" value="<%=istrue?eventHours:""%>"
				name="hours" placeholder="Hours" class="form-control"> <label
				class="sr-only">minute</label> <input type="number" value="<%=istrue?eventminute:""%>"
				name="minute" placeholder="Minute" class="form-control">
		</div>

      <div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="edit_associateTrainerID_holder" name="associateTrainerID" value="<%=selectedTrainerString%>"/>
				<select data-placeholder="select Groups AssociateTrainerID"  multiple class="select2-dropdown"
						tabindex="4" name="" id="edit_associateTrainerID">
						<option value="">Select Associate Trainers...</option>
					       <%=ui.getAllTrainer(setactedTrainer)%>

					</select>
			</div>

		<div class="form-group">
             <input type="hidden" name="trainerName" value="<%=istrue?trainerName:"" %>"/>
			<div class="col-lg-12">
				<label class="control-label">Select Trainer</label> <select
					class="form-control m-b" name="trainerID">
					
					
						<option value="<%=istrue?trainerID:""%>"><%=istrue?student.getEmail():"" %></option>
						
					           <%=istrue?ui.getAllTrainer(null):""%>

				</select>
			</div>
			<div class="col-lg-12">
				<label class="control-label">Select Class-Room</label> <select
					class="form-control m-b" name=classroomID>
						<option value="<%=istrue?classroomID:"" %>"><%=istrue?classroomDetails.getClassroomIdentifier():"" %></option>
					
					     <%=istrue?ui.getAllClassroom(orgID):""%>

				</select>
			</div>
			<%-- <%if(request.getParameterMap().containsKey("eventid")){ %>
			<div class="col-lg-12">
				<label class="control-label">Select Session</label> <select
					class="form-control m-b" name=sessionID>
						
					<%=istrue?ui.getLessons(batchID,courseID):""%>

				</select>
			</div><%} %> --%>
		</div>
	</form>



</div>
<div class="modal-footer">
    <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
 

   <%--  <button type="button" class="btn btn-danger newschedule_delete-event" id="<%=istrue?evntid:""%>" data-dismiss="modal">Delete Event</button> --%>
	<button type="button" data-form="idForm4" data-dismiss="modal" class="btn btn-primary btn-danger newschedule_edit-submit-btn">Save changes</button>

</div></div>