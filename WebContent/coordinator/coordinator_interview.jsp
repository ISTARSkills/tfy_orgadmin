<%@page import="java.util.HashMap"%>
<%@page import="tfy.admin.trainer.CoordinatorSchedularUtil"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%
	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	CoordinatorSchedularUtil schedularUtil = new CoordinatorSchedularUtil();
	String course_id=request.getParameter("course_id");
	String stage_id=request.getParameter("stage_id");
	String trainerID=request.getParameter("trainerID");
	String uniq_id=request.getParameter("uniq_id");
%>



<form id="schedular_form_<%=uniq_id%>" class="schedular_form m-t-md">
	<input type='hidden' name='coordinator_id' value='<%=user.getId()%>' /> <input type='hidden' name='course_id' value='<%=course_id%>' /> <input type='hidden' name='stage_id' value='<%=stage_id%>' /> <input type='hidden' name='trainerID' value='<%=trainerID%>' />
	<div class="form-group">
		<label>Choose Interviewer</label> <select class="form-control m-b scheduler_select" id='inter_viewer_id_<%=uniq_id%>' name="interviewer_id">
			<option value="">Select Interviewer...</option>
			<%
				for (HashMap<String, Object> item : schedularUtil.getInterViewersList()) {
			%>
			<option value="<%=item.get("id")%>"><%=item.get("email")%> (<%=item.get("role_name").toString().replaceAll("_", " ").toLowerCase()%>)
			</option>
			<%
				}
			%>
		</select>
	</div>

	<div class="form-group" id="data_2">
		<label class="font-bold">Interview Date</label>
		<div class="input-group date">
			<span class="input-group-addon"><i class="fa fa-calendar"></i></span> <input name="date" id="eventDate_<%=uniq_id%>" type="text" class="form-control date_holder" value="">
		</div>
	</div>

	<div class="form-group">
		<label class="font-bold">Interview Time</label>
		<div class="input-group" data-autoclose="true">
			<span class="input-group-addon"> <span class="fa fa-clock-o"></span>
			</span> <input type="text" style="width: 100%; height: 28px;" id="eventTime_<%=uniq_id%>" name="time" class="time_element" />
		</div>
	</div>

	<div class="form-group">
		<label class="font-bold">Interview Duration(in Mins)</label>
		<div class="input-group" data-autoclose="true">
			<span class="input-group-addon"> <span class="fa fa-hourglass-start"></span>
			</span> <input type="number" style="width: 100%; height: 28px;" id="event_duration_<%=uniq_id%>" value='30' name="duration" />
		</div>
	</div>
</form>
