<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
				
				
				UIUtils ui = new UIUtils();
				IstarUser istarUser = new IstarUser();
				Batch batch = new Batch();
				String evntid = "";
				String eventDate = "08/09/2014";
				String eventTime = "09:30";
				int eventHours = 0;
				int eventminute = 0;
				int trainerID = 0;
				String trainerEmail = "defalut@mail.com";
				int classroomID = 0;
				String classroomName = "";
				int orgAdminUserID =300;
				int orgID=0;
				int batchID = 0;
				String associate_trainee = null;
				ArrayList<Integer> setactedTrainer = new ArrayList();
				if (request.getParameterMap().containsKey("eventid")) {

					istrue = true;
					evntid = request.getParameter("eventid");
					System.out.println("------------------------------------------->" + evntid);
					
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
						 if (associate_trainee.contains(",")) {
							 for (String retval: associate_trainee.split(",")) {
								 setactedTrainer.add(Integer.parseInt(retval));
						      }
							 
						 }else{
							 setactedTrainer.add(Integer.parseInt(associate_trainee));
						 }
					}else{
						setactedTrainer = null;
					}
						
						
					}
					istarUser = new IstarUserDAO().findById(trainerID);
							trainerEmail = istarUser.getEmail();
							ClassroomDetails classroomDetails = new ClassroomDetailsDAO().findById(classroomID);
							classroomName = classroomDetails.getClassroomIdentifier();
							batch = new BatchDAO().findById(batchID);
				}
		
			%>


<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal">
		<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
	</button>
	<h4 class="modal-title">Modify Events details</h4>

</div>
<div class="modal-body">

	<form id="idForm4" class="form-horizontal">
<input type="hidden" name="eventID" value="<%=evntid%>"/>
<input type="hidden" name="eventType" value="session"/>
<input type="hidden" name="AdminUserID" value="<%=orgAdminUserID%>"/>
<input type="hidden" name="batchID" value="<%=batchID%>"/>
		<div class="form-group" id="data_2">
			<div class="col-lg-12">
				<label class="font-bold">Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" class="form-control" name="eventDate" value="<%=eventDate%>">
				</div>
			</div>
		</div>

		<div class="form-group">
			<label class="font-bold">Start Time</label>
			<div class="input-group clockpicker " data-autoclose="true">
				<input type="text" class="form-control" name="startTime" value="<%=eventTime%>"> <span
					class="input-group-addon"> <span class="fa fa-clock-o"></span>
				</span>
			</div>
			
		</div>
		<div class="form-group form-inline">
			<label class="sr-only">Hours</label> <input type="number" value="<%=eventHours%>"
				name="hours" placeholder="Hours" class="form-control"> <label
				class="sr-only">minute</label> <input type="number" value="<%=eventminute%>"
				name="minute" placeholder="Minute" class="form-control">
		</div>
            <div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="edit_old_associateTrainerID_holder" name="associateTrainerID" value="<%=setactedTrainer.toString()%>"/>
				<select data-placeholder="select Groups AssociateTrainerID"  multiple class="select2-dropdown"
						tabindex="4" name="" id="edit_old_associateTrainerID">
						<option value="">Select Associate Trainers...</option>
					       <%=ui.getAllTrainer(setactedTrainer)%>

					</select>
			</div>

		<div class="form-group">

			<div class="col-lg-12">
				<label class="control-label">Select Trainer</label> <select
					class="form-control m-b" name="trainerID">
					<option value="<%=istrue?trainerID:"" %>"><%=istrue?trainerEmail:"" %></option>
					<%=ui.getAllTrainer(null)%>

				</select>
			</div>
			<div class="col-lg-12">
				<label class="control-label">Select Class-Room</label> <select
					class="form-control m-b" name=classroomID>
					<option value="<%=istrue?classroomID:"" %>"><%=istrue?classroomName:"" %></option>
					 <%=istrue?ui.getAllClassroom(orgID):""%>

				</select>
			</div>
			<div class="col-lg-12">
				<label class="control-label">Select Session</label> <select
					class="form-control m-b" name=sessionID>
					
					<%=ui.getLessons(batchID,batch.getCourse().getId())%>

				</select>
			</div>
		</div>
	</form>



</div>
<div class="modal-footer">
    <button type="button" class="btn btn-white" data-dismiss="modal">Close</button>
    <button type="button" class="btn btn-danger delete-event" id="<%=evntid%>" data-dismiss="modal">Delete Event</button>
	<button type="button" data-form="idForm4" class="btn btn-primary edit-submit-btn">Save changes</button>
</div>