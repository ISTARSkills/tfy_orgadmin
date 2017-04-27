<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.*"%>

<% 

int colegeID = -3;


UIUtils ui_Util = new UIUtils();
 %>
<div class="row border-bottom white-bg report-padding ">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-content">

			<div class="row">
			<div class="col-lg-2">
			<div class="form-group">
				<label>Choose Organization</label> 
				<select class="form-control m-b org_holder_programTab " name="orgID">
				
					<%= ui_Util.getOrganization() %>

				</select>
			</div>
			</div>
			
				<div class="col-lg-2">
					<div class="form-group">
						<label>Choose Program</label> <select
							class="form-control m-b course_holder " name="courseID">
							
							<%-- <%= ui_Util.getCourses(colegeID) %> --%>

						</select>
					</div>
				</div>
			
					
				</div>

		</div>
	</div>
</div>
<div class="row border-bottom white-bg report-padding">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		
		<div class="ibox-content ">

			<div class="row">
			
			<div class="col-lg-11" id="container10"  >
			
			<div class="spiner-example spinner-animation-holder_User" id="program_spiner">
								<div class="sk-spinner sk-spinner-three-bounce">
									<div class="sk-bounce1"></div>
									<div class="sk-bounce2"></div>
									<div class="sk-bounce3"></div>
								</div>
							</div>
			</div>
			
			
							<table id="datatable10" style="display:none"></table>
							
				

			</div>

		</div>
	</div>
</div>
<div class="row border-bottom white-bg report-padding">

	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-title">
			<h5></h5>
		</div>
		<div class="ibox-content ">
			<div class="row">
			
			
			
			
			<%
				ReportUtils util = new ReportUtils();
				HashMap<String, String> conditions = new HashMap();
				conditions.put("limit", "12");
				conditions.put("offset", "0");			
				%>
				
				<%=util.getTableOuterHTML(3047, conditions)%>
			
			
			<%-- <%
			List<HashMap<String, Object>> getTableData = ui_Util.getProgramTabTable();
			
			
			
			%>
			 --%>
			<!-- <div class="table-responsive">
						<table
							class="table table-bordered datatable_istar" id='account_details_list' data-url='../program_graphs?accountDetails=accountDetails'>
                                <thead>
                                <tr>
                                    
                                    <th>Account Name</th>
                                    <th>Master</th>
                                    <th>Wizard</th>
                                    <th>Rooki</th>
                                    <th>Apprentice</th>
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
