<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.UIUtils"%>

<%@page import="java.util.*"%>

<% 
UIUtils ui_Util = new UIUtils();
 %>
<div class="row border-bottom white-bg">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-content">

			<div class="row">
				<div class="col-lg-4">
					<div class='customcss_dataTable' id="container_projector">
						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner1">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_projector" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div class='customcss_dataTable' id="container_internet">

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner2">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_internet" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div class='customcss_dataTable' id="container_trainer_knowledge">

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner2">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_trainer_knowledge" style="display: none"></table>

				</div>
				
			</div>
			
			<div class="row">
				<div class="col-lg-4">
					<div class='customcss_dataTable' id="container_trainer_too_fast">
						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner1">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_trainer_too_fast" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div class='customcss_dataTable' id="container_class_control_by_trainer">

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner2">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_class_control_by_trainer" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div id="container_too_tough_content" class='customcss_dataTable'>

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner2">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_too_tough_content" style="display: none"></table>

				</div>
				
			</div>
			
			<div class="row">
				<div class="col-lg-4">
					<div id="container_too_much_theoritic" class='customcss_dataTable'>
						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner1">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_too_much_theoritic" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div id="container_no_fun_in_class" class='customcss_dataTable'>

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner2">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_no_fun_in_class" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div id="container_enough_examples" class='customcss_dataTable'>

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner2">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable_enough_examples" style="display: none"></table>

				</div>
				
			</div>

		</div>
	</div>
</div>
<div class="row border-bottom white-bg" >
		<div class="ibox float-e-margins no-margins bg-muted">
				<div class="ibox-title">
					<h5>Student FeedBack Details</h5>
					
				</div>
				<div class="ibox-content">
        <div class="row">

               <%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");			
				%>
				
				<%=util.getTableOuterHTML(3063, conditions)%>
				</div>
					
				</div>
			</div>
		</div>
	</div>

<br>
<br>
<br>
