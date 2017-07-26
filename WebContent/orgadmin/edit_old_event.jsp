<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.BatchDAO"%>
<%@page import="com.viksitpro.core.dao.entities.ClassroomDetailsDAO"%>
<%@page import="com.viksitpro.core.dao.entities.ClassroomDetails"%>
<%@page import="com.viksitpro.core.dao.entities.Batch"%>
<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.UUID"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
IstarUser user = (IstarUser)request.getSession().getAttribute("user");
int orgAdminUserID =user.getId();
int colegeID = (int) request.getSession().getAttribute("orgId");
	 


	int user_id = user.getId();

	Organization college = new OrganizationDAO().findById(colegeID);
	
	boolean istrue = false;
	UIUtils ui = new UIUtils();
	user_id = ui.getOrgPrincipal(colegeID);

	
	Batch batch = new Batch();
	
	String evntid = "";
	String eventDate = "08/09/2014";
	String eventTime = "09:30";
	int eventHours = 0;
	int eventminute = 0;
	int trainerID = 0;
	int batchID = 0;
	String trainerEmail = "defalut@mail.com";
	int classroomID = 0;
	String classroomName = "";
	String associate_trainee = null;
	String selectedTrainerString="0";
	ArrayList<Integer> setactedTrainer = new ArrayList();
	if (request.getParameterMap().containsKey("eventid")) {

		istrue = true;
		evntid = request.getParameter("eventid");
		//System.out.println("------------------------------------------->" + evntid);
		
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat sdf1 = new SimpleDateFormat("HH:mm");
	
		
		for(HashMap<String, Object> dd : ui.getEventDetails(evntid)){
			
			eventDate = sdf2.format(formatter1.parse(dd.get("evedate").toString()));
			eventTime = sdf1.format(formatter1.parse(dd.get("evedate").toString()));
			eventHours = (int)dd.get("hours");
			eventminute = (int)dd.get("min");
			trainerID = (int)dd.get("userid");
			classroomID =(int)dd.get("classroomid");
			batchID =(int)dd.get("batch_id");
			associate_trainee =(String)dd.get("associate_trainee");
			if(associate_trainee != null && !associate_trainee.equalsIgnoreCase("")){
				selectedTrainerString=associate_trainee;
			if (associate_trainee.contains(",")) {
				 for (String retval: associate_trainee.split(",")) {
					 setactedTrainer.add(Integer.parseInt(retval));
			      }
				 
			 }else{
				 setactedTrainer.add(Integer.parseInt(associate_trainee));
			 }}else{
					setactedTrainer = null;
				}
						
		}
		IstarUser istarUser = new IstarUserDAO().findById(trainerID);
				trainerEmail = istarUser.getEmail();
				ClassroomDetails classroomDetails = new ClassroomDetailsDAO().findById(classroomID);
				classroomName = classroomDetails.getClassroomIdentifier();
				batch = new BatchDAO().findById(batchID);
	}
%>


<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
 <div class="panel-heading custom-theme-panal-color">
	<button type="button" class="close" data-dismiss="modal">
		<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
	</button>
	<h4 class="modal-title text-center" style="color: white!important;">Modify Events Details</h4>

</div>
<div class="modal-body">

	<form id="idForm4" class="form-horizontal">
		<input type="hidden" name="eventID" value="<%=evntid%>" /> <input
			type="hidden" name="eventType" value="session" /> <input
			type="hidden" name="AdminUserID" value="<%=user_id%>" /> <input
			type="hidden" name="batchID" value="<%=batchID%>" />
			
			<div class="form-group" id="data_2">
			<div class="col-lg-4">
				<label class="control-label">Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" class="form-control" name="eventDate" value="<%=eventDate%>">
				</div>
			</div>
		<div class="col-lg-4">
			<label class="control-label">Event Time</label>
			<div class="input-group" data-autoclose="true">
				 <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span><%-- <input type="text" style="width: 100%; height: 28px;" name="startTime" class="timepicker" id="currenTime" value="<%=istrue ? eventTime : ""%>"/> --%>
					<input type="text" style="width: 100%; height: 35px;" name="startTime" class="time_element" id="currenTime" value="<%=istrue ? eventTime : ""%>"/>
				</div> 
			<%-- <div class="input-group clockpicker " data-autoclose="true">
				<input type="text" class="form-control" name="startTime" value="<%=eventTime%>"> <span
					class="input-group-addon"> <span class="fa fa-clock-o"></span>
				</span>
			</div> --%>
			</div>
			
		<div class="col-lg-2">
			<label class="control-label" >Hours</label> <input type="number" value="<%=eventHours%>"
				name="hours" placeholder="Hours" class="form-control"> 
		</div>
		<div class="col-lg-2">
		<label class="control-label">Minute</label> <input type="number" value="<%=eventminute%>"
				name="minute" placeholder="Minute" class="form-control">
		</div></div>
            <div class="form-group">
            <div class="col-lg-6">
				<label class="control-label" >Choose Associate Trainee</label>
				<input type="hidden" id="edit_old_associateTrainerID_holder" name="associateTrainerID" value="<%=selectedTrainerString%>"/>
				<select data-placeholder="select Groups AssociateTrainerID"  multiple class="select2-dropdown"
						tabindex="4" name="" id="edit_old_associateTrainerID">
						<option value="">Select Associate Trainers...</option>
					       <%=ui.getAllTrainer(setactedTrainer)%>

					</select>
			
</div>
			<div class="col-lg-6">
				<label class="control-label">Select Trainer</label> <select
					class="form-control m-b" name="trainerID">
					<option value="<%=istrue?trainerID:"" %>"><%=istrue?trainerEmail:"" %></option>
					<%=ui.getAllTrainer(null)%>

				</select>
			</div>
			</div>
			 <div class="form-group">
			<div class="col-lg-6">
				<label class="control-label">Select Class-Room</label> <select
					class="form-control m-b" name=classroomID>
					<option value="<%=istrue?classroomID:"" %>"><%=istrue?classroomName:"" %></option>
					<%=istrue ? ui.getAllClassroom(colegeID) : ""%>

				</select>
			</div>
			<div class="col-lg-6">
				<label class="control-label">Select Session</label> <select
					class="form-control m-b" name=sessionID>
					
					<%=ui.getLessons(batchID,batch.getCourse().getId())%>

				</select>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-lg-12">
				<label class="control-label">Reason for Edit*</label> <input type="text" name="reason_for_edit_delete" class="form-control" required id="reason_for_edit_delete" >
				<label id="reason_needed" class="error" style="display:none">Reason is required.</label>
			</div>			
		</div>
	</form>



</div>
<div class="modal-footer">
	<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
	<button  class="btn btn-danger delete-event"
		id="<%=evntid%>">Delete Event</button>
	<button type="button" data-form="idForm4"
		class="btn btn-danger edit-submit-btn">Save changes</button>
</div></div>