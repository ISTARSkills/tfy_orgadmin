<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="tfy.webapp.ui.TaskCardFactory"%>
<%@page import="com.istarindia.android.pojo.TaskSummaryPOJO"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<jsp:include page="inc/head.jsp"></jsp:include>
<%
 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	request.setAttribute("cp", cp);
	boolean flag = false;
%>
<body class="top-navigation student_pages" id="orgadmin_dashboard">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp" />
			<div class="wrapper wrapper-content animated fadeInRight" style="padding: 10px;" id='equalheight'>
				
			<%=(new TaskCardFactory()).showSummaryEvents(cp).toString()%>
				<%=(new TaskCardFactory()).showSummaryCard(cp).toString()%>
			<% 	for(TaskSummaryPOJO task :cp.getTaskForToday()) {
				System.out.println("task.getStatus()"+task.getStatus());
				System.out.println("task.getItemType()"+task.getItemType());
			if(!task.getStatus().equalsIgnoreCase("COMPLETED")) {
			%>
				<%=(new TaskCardFactory()).showcard(task).toString() %>
				
				<% } } %>
			</div>
		</div>
	</div>
	<jsp:include page="inc/foot.jsp"></jsp:include>
	<Script>
	$(".card1").flip({
		  trigger: 'mannual'
		});
	
	$('#equalheight2 .ibox-content').equalHeights();

	
	$('.reverse_view').unbind().on('click',function(){
		var card=$(this).closest('div[class="card1"]');
		$(card).flip('toggle');			
	});
	
	$(".rateYo").rateYo({
	    rating: 0.0, 
	    starWidth: "10px"   

	  });
	
	var productBoxHeight=$($($('.front')[0]).find('#ibox-content')).height();
	
	console.log('productBoxHeight---'+productBoxHeight);
	$('.back').each(function(e){
		$(this).find('#ibox-content').height(productBoxHeight)
	});
	$('.front').each(function(e){
	$(this).find('#ibox-content').height(productBoxHeight)
	});
	
	$('.submit_feedback').unbind().on("click",function(){
		//var holder_id='#trainer_rating_7035_14';
		
		var course_id=$(this).data('course_id');
		var user_id=$(this).data('user_id');
		var interviewer_id=$(this).data('interviewer_id');
		var stage =$(this).data('stage');
		
		var comments=$('#comments_'+user_id+'_'+course_id+'').val();
		var isSlected=$('#selected_'+user_id+'_'+course_id+'').prop('checked');
		
		var rate_list=$('#rate_list_'+course_id+'_'+user_id);
		
		var ratingSkill="";
		
		
		$(rate_list).find('.rateYo').each(function(){	
			var rating=$(this).rateYo("option", "rating");
			var skill_id=$(this).data('skill_id');
			ratingSkill=ratingSkill+skill_id+":"+rating+",";
		});
		
		if(ratingSkill.endsWith(",")){
			ratingSkill=ratingSkill.substring(0,ratingSkill.length-1);
		}
		
		 $.ajax({
		        type: "POST",
		        url: "/submit_interview",
		        data: {course_id:course_id,user_id:user_id,interviewer_id:interviewer_id,comments:comments,is_selected:isSlected,rating_skill:ratingSkill,stage:stage},
		        success: function(data) {
		        	location.reload();
		        }});		  
		
		
	});
	
	$('.i-checks').iCheck({
      checkboxClass: 'icheckbox_square-green',
      radioClass: 'iradio_square-green',
  });
	</Script>
</body>
</html>