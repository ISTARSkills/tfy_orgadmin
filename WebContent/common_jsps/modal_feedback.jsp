<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@page import="in.orgadmin.admin.services.AdminUIServices"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int user_id = Integer.parseInt(request.getParameter("user_id"));
	int task_id = Integer.parseInt(request.getParameter("task_id"));

	HashMap<String, String> ratingList = new HashMap();
	ratingList.put("projector", "Projector issue.");
	ratingList.put("internet", "Internet was not working properly.");
	ratingList.put("trainer_knowledge", "Trainer knowledge was not upto mark.");
	ratingList.put("trainer_too_fast", "Trainer went too fast.");
	ratingList.put("class_control_by_trainer", "Poor trainer class control.");
	ratingList.put("too_tough_content", "Content taught in class was too tough.");
	ratingList.put("too_much_theoritic", "Content was too much theory.");
	ratingList.put("no_fun_in_class", "Class was not fun.");
	ratingList.put("enough_examples", "Did not have enough examples.");
	ratingList.put("outside_disturbance", "Disturbance to class from outside.");
	
	
	AdminUIServices uiServices=new AdminUIServices();
	SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy HH:mma");
	
	List<HashMap<String, Object>> data=uiServices.studentFeedbackTrainerInfo(task_id);
	
	String trainer_email="";
	String trainer_firstName="";
	int trainer_id=0;
	int batchGrp=0;
	int event_id=0;
	String eventTime="N/A";
	String mediaURL=AppProperies.getProperty("media_url_path");
	
	if(data.get(0)!=null && data.get(0).get("email")!=null){
		trainer_email=(String)data.get(0).get("email");
		trainer_firstName=trainer_email.split("@")[0];
	}
	
	if(data.get(0)!=null && data.get(0).get("first_name")!=null){
		trainer_firstName=(String)data.get(0).get("first_name");
	}
	
	
	
	String profile_image=mediaURL+"/video/android_images/"+trainer_firstName.trim().toUpperCase().charAt(0)+".png";
	if(data.get(0)!=null && data.get(0).get("profile_image")!=null){
		String imagePath=(String)data.get(0).get("profile_image");
		if(imagePath.contains("cdn.talentify")){
			profile_image=imagePath;
		}else{
			profile_image=mediaURL+imagePath;
		}
	}
	
	
	if(data.get(0)!=null && data.get(0).get("eventdate")!=null){
		try{
		eventTime=formatter.format(((Timestamp)data.get(0).get("eventdate")).getTime());
		}catch(Exception e){
			
		}
	}
	String course_name="N/A";
	if(data.get(0)!=null && data.get(0).get("course_name")!=null){
		course_name=data.get(0).get("course_name")+"";
	}
	
	
	if(data.get(0)!=null && data.get(0).get("batch_group_id")!=null){
		batchGrp=(int)data.get(0).get("batch_group_id");
	}
	
	if(data.get(0)!=null && data.get(0).get("trainer_id")!=null){
		trainer_id=(int)data.get(0).get("trainer_id");
	}
	
	if(data.get(0)!=null && data.get(0).get("id")!=null){
		event_id=(int)data.get(0).get("id");
	}
	
	
	
%>


<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal">&times;</button>
	<h4 class="modal-title">Feedback</h4>
</div>
<div class="modal-body">
	<div class="row" style='margin-bottom: 15px;'>
		<div class="col-md-1"></div>
		<div class="col-md-2">
			<img alt="image" class="img-circle m-t-xs img-responsive"
				src="<%=profile_image%>">
		</div>
		<div class="col-md-8">
			<div>
				<h3 style="margin: 0px;">
					<strong style='font-weight: 500;'> <%=trainer_firstName%> (<%=trainer_email%>) </strong>
				</h3>
				
				<p style='margin: 5px;'>
					<i>Scheduled Time</i>: <%=eventTime%>
				</p>
				
				<p style='margin: 5px;'>
					<i>Course taught:</i> <%=course_name%>
				</p>
			</div>
		</div>
		<div class="col-md-1"></div>
	</div>
	<strong>What issues did you face in today's class?</strong>
	<div id='rate_list'>
		<%
			for (String key : ratingList.keySet()) {
		%>
		<div class="row" style='margin-top: 2px; padding: 7px'>
			<div class="col-md-6"><%=ratingList.get(key)%></div>
			<div class='rateYo col-md-6' style='float: left'
				data-skill_name='<%=key%>'></div>
		</div>
		<%
			}
		%>

	</div>
	<div class="row" style='margin: 0px; padding: 10px;'>
		<strong>Comments:</strong>
		<textarea class="form-control" style='padding: 10px;' rows="5"
			id="feedback_comments"></textarea>
	</div>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-danger" id='submit_feedback'
		data-user_id='<%=user_id%>' data-event_id='<%=event_id%>' data-trainer_id='<%=trainer_id%>'  data-batch_grp_id='<%=batchGrp%>'data-task_id='<%=task_id%>'>Submit</button>
</div>