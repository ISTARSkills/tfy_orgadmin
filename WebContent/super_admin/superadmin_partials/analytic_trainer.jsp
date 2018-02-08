<%@page import="com.viksitpro.core.dao.entities.OrganizationDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Organization"%>
<%@page import="tfy.admin.services.AdminServices"%>
<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.*"%>

<% 
UIUtils ui_Util = new UIUtils();
 %>
<div class="row border-bottom white-bg  ">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-content">

			<div class="row">
				<div class="col-lg-4">
					<div class='customcss_dataTable' id="container11">

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner1">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable11" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div class='customcss_dataTable' id="container12">

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner2">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable12" style="display: none"></table>

				</div>
				<div class="col-lg-4">

					<div class='customcss_dataTable' id="container13">

						<div class="spiner-example spinner-animation-holder_User"
							id="trainer_spiner3">
							<div class="sk-spinner sk-spinner-three-bounce">
								<div class="sk-bounce1"></div>
								<div class="sk-bounce2"></div>
								<div class="sk-bounce3"></div>
							</div>
						</div>
					</div>


					<table id="datatable13" style="display: none"></table>

				</div>


			</div>

		</div>
	</div>
</div>
<div class="row border-bottom white-bg">
	<div class="col-lg-12 gray-bg custom_css-trainer_mastertrainer">
		<div class="tabs-container">
			<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#trainer_tab">Trainer</a></li>
				<li class=""><a data-toggle="tab" href="#master_trainer_tab">Master
						Trainer</a></li>
						<li class=""><a data-toggle="tab" href="#slide_analytics_tab">Trainer Slide Analytics - Summary</a></li>
			</ul>
			<div class="tab-content">
				<div id="trainer_tab" class="tab-pane active">
					<div class="panel-body">
						<div class="gray-bg">
							<div class="row">

								<div class="col-lg-12">

									<div class="no-paddings bg-muted">
										<div class="ibox-title">
											<h5>Trainer List</h5>

										</div>
										<div class="ibox-content">
											<%HashMap<String, String> conditions = new HashMap();
						conditions.put("limit", "12");
						conditions.put("offset", "0");
						conditions.put("static_table", "true");	
						ReportUtils util = new ReportUtils();
						%>

											<%-- <%= util.getTableFilters(Integer.parseInt("3077"), conditions) %> --%>




											<%= util.getTableOuterHTML(Integer.parseInt("3077"), conditions) %>
											<%%>
										</div>
									</div>
								</div>
							</div>


						</div>
					</div>
				</div>
				<div id="master_trainer_tab" class="tab-pane">
					<div class="panel-body">
						<div class="gray-bg">
							<div class="row">

								<div class="col-lg-12">

									<div class="no-paddings bg-muted">
										<div class="ibox-title">
											<h5>Master Trainer List</h5>

										</div>
										<div class="ibox-content">
											<%HashMap<String, String> conditions2 = new HashMap();
						conditions2.put("limit", "12");
						conditions2.put("offset", "0");
						conditions2.put("static_table", "true");	
						ReportUtils util2 = new ReportUtils();
						%>

										<%-- 	<%= util2.getTableFilters(Integer.parseInt("3078"), conditions2) %> --%>




											<%= util2.getTableOuterHTML(Integer.parseInt("3078"), conditions) %>
											<%%>
										</div>
									</div>
								</div>
							</div>


						</div>
					</div>
				</div>
				<div id="slide_analytics_tab" class="tab-pane active">
				<div class="panel-body">
							
							
						</div>
				</div>
			</div>
		</div>
	</div>
</div>

<br>
<br>
<br>

<script>

</script>
