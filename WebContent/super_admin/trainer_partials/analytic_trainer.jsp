<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.*"%>

<% 
UIUtils ui_Util = new UIUtils();
 %>
<div class="row border-bottom white-bg report-padding ">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-content">

			<div class="row">
				<div class="col-lg-4">
					<div id="container11"
						style="min-width: 310px; height: 400px; margin: 0 auto">

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

					<div id="container12"
						style="min-width: 310px; height: 400px; margin: 0 auto">

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

					<div id="container13"
						style="min-width: 310px; height: 400px; margin: 0 auto">

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
<div class="row border-bottom white-bg report-padding">


	
		<div class="col-lg-12">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>Trainer Details</h5>
					
				</div>
				<div class="ibox-content">
<div class="row">
			
			
			
			
			<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");			
				%>
				
				<%=util.getTableOuterHTML(3039, conditions)%>
				
				
				</div>
					<!-- <div class="table-responsive">
						<table
							class="table table-bordered datatable_istar" id='trainer_details_list' data-url='../program_graphs?trainerDetails=trainerDetails'>
							<thead>
								<tr>
									<th>Trainer Name</th>
									<th>Date Joined</th>
									<th>E-mail</th>
									<th>Rating</th>
									<th>Late Start</th>
									<th>Early finish</th>
									<th>Location</th>
									<th>Unbilled Hours</th>
									
								</tr>
							</thead>
							
						</table>


					</div> -->
				</div>
			</div>
		</div>
	</div>

<br>
<br>
<br>
