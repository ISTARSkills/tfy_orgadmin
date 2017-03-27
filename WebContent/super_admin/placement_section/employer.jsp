<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.istarindia.apps.dao.CollegeDAO"%>
<%@page import="com.istarindia.apps.dao.College"%>
<% 


UIUtils ui_Util = new UIUtils();
DBUTILS db = new DBUTILS();
 %>
<%--  <div class="row border-bottom white-bg report-padding ">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-content">
			
				<div class="row">
					<div class="col-lg-4">
			<div class="form-group">
				<label>Choose Organization</label> 
				<select class="form-control m-b org_holder " name="orgID">
			<%= ui_Util.getOrganization() %>

				</select>
			</div>
			</div>
				</div>
				
			</div>
		</div>
	</div>  --%>

	
	
	<%-- <div class="row border-bottom white-bg ">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-title">
				<h2 class="text-center">Employer Breakdown</h2>
			</div>
			<div class="ibox-content">
				<div class="ibox-title">
					
					<% String sql1 ="select count(*), \"EmployerNameOrSelfEmployed\" as eee from \"candidate_details\" where \"EmployerNameOrSelfEmployed\" not in ('','SELF EMPLOYED','SELF EMPLOYMENT' ) group by \"EmployerNameOrSelfEmployed\""; 
						
						List<HashMap<String, Object>> empData = db.executeQuery(sql1);
					%>
					
					<table id="piiie"
							class="table table-striped table-bordered table-hover dataTables-example">
							<thead>
								<tr>
									<th>Emplyeer Name</th>
									<th>Placed</th>
									
									
								</tr>
							</thead>
							<tbody>
							<% for(HashMap<String, Object> row: empData ) { %>
<tr>
									<td><%=row.get("eee") %></td>
									
									<td><%=row.get("count") %></td>
									
								</tr>
<% } %>
							</tbody>
							
						</table>
						
						<div id='piiie_piiie'></div>
			</div>
			
			
			
			
			</div>
		</div>
	</div> --%>
	
	
	<div class="row border-bottom white-bg ">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-title">
				<h2 class="text-center">Employer Statistics Details</h2>
				<% String sql ="SELECT DISTINCT 	CD.\"EmployerNameOrSelfEmployed\" AS employer_name, 	TE.COMMENT AS COMMENT, 	COUNT (\"Enrollmentnumber\") FROM 	candidate_details CD, 	temp_employee TE WHERE 	CD.\"EmployerNameOrSelfEmployed\" = TE.employee_name GROUP BY 	employer_name, 	COMMENT order by count  desc "; 						
					System.out.println(sql);	
				
				List<HashMap<String, Object>> itemss = db.executeQuery(sql);
					%>
			</div>
			<div class="ibox-content">
					<div class="table-responsive">
						<table
							class="table table-striped table-bordered table-hover dataTables-example">
							<thead>
								<tr>
									<th>Employer Name</th>
									<th>Comment</th>
									<th>Students Placed</th>
									<th>Profile</th>
								</tr>
							</thead>
							<tbody>
							<% for(HashMap<String, Object> row: itemss ) { %>
<tr>
									<td><%=row.get("employer_name") %></td>
									<td><%=row.get("comment") %></td>
									<td><%=row.get("count") %></td>
									<td><a href="placement_section/employer_profile.jsp?employee_name=<%=row.get("employer_name")%>" class="btn btn-w-m btn-primary">Profile</a></td>

								</tr>
<% } %>
							</tbody>
							<tfoot>
								<tr>
									<th>Employer Name</th>
									<th>Comment</th>
									<th>Students Placed</th>
									<th>Profile</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
		</div>
	</div>
	<div class="row border-bottom white-bg report-padding ">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-content">
			<div class="row">
				<div class="col-lg-4">
					<div style="width: 600px; height: 400px; margin: 0 auto">
    <div id="container-speed" style="width: 300px; height: 200px; float: left">
    
    <img alt="" src="/assets/images/average_salary.PNG">
    </div>
</div>



				</div>
				
				


			</div>

		</div>
	</div>
</div>
	<br>
	<br>
	<br>
