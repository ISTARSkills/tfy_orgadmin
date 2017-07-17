<%@page import="com.viksitpro.core.customtask.TaskFormElement"%>
<%@page import="com.viksitpro.core.customtask.TaskStep"%>
<%@page import="com.viksitpro.core.dao.entities.Task"%>
<%@page import="com.viksitpro.core.customtask.TaskLibrary"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.UUID"%>

<jsp:include page="../student/inc/head.jsp"></jsp:include>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	request.setAttribute("cp", cp);
	boolean flag = false;
	int taskID = Integer.parseInt(request.getParameter("task_id"));
	Task task = new TaskLibrary().getTaskTemplate(taskID);
%>
<style>
.wizard>.steps .done a, .wizard>.steps .done a:hover, .wizard>.steps .done a:active
{
background: rgba(235, 56, 79, 0.61) !important;
color: #fff;
}
</style>
<body class="top-navigation student_pages" id='custom_task'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../student/inc/navbar.jsp" />
			<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-sm-4">
					<h2><%=task.fetchTaskTemplate().getLabel()%></h2>
					<ol class="breadcrumb">
						<li><a href="/student/dashboard.jsp">Dashboard</a></li>
						<li class="active"><strong>Task</strong></li>
					</ol>
				</div>

			</div>
			<div class="wrapper wrapper-content animated fadeInRight" style="padding: 10px;" id='equalheight'>
				<div class="col-lg-12">
					<div class="ibox">
						<div class="ibox-content">
							<form id="form"  class="wizard-big">
								<%
									int i = 0;
									for (TaskStep step : task.fetchTaskTemplate().getSteps()) {
										String uniqueId = UUID.randomUUID().toString().replaceAll("-", "");
								%>
								
								<input type="hidden" name="task_id"  value="<%=taskID %>" >
								<input type="hidden" name="user_id"  value="<%=user.getId() %>" >
								<h1><%=step.getLabel()%></h1>
								<fieldset style='background-color: #ffffff;min-height: 420px;'>
									<h2><%=step.getLabel()%></h2>
									<div class="row equal_heights_wizard_step" style='padding-bottom:20px;'>
										<%
											for (TaskFormElement formelement : step.getForm_elements()) {
										%>
										<div class="col-md-6">
											<%=TaskFormElement.get(formelement, uniqueId).toString()%>
										</div>
										<%
											}
										%>
									</div>
								</fieldset>
								<%
									i++;
									}
								%>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../student/inc/foot.jsp"></jsp:include>
</body>
</html>