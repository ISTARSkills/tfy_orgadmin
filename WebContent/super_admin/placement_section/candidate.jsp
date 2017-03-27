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

<%

String selectDistinctYear="select DISTINCT split_part(\"PassingoutDate\", '-', 3) as ss from  candidate_details where \"PassingoutDate\"is not null and \"PassingoutDate\" !=''";

List<HashMap<String, Object>> data  = db.executeQuery(selectDistinctYear);

for(HashMap<String, Object> rowYear: data)
{
	%>
	<div class="row border-bottom white-bg report-padding">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-title">
				<h2 class="text-center">Average Salary Breakdown for Year <%=rowYear.get("ss") %></b></h2>
				<% String sql ="SELECT 	COUNT (*) as cc, 	\"MonthlyCurrentCTCOrearning\" as ff FROM 	candidate_details  WHERE 	\"PassingoutDate\" LIKE '%"+rowYear.get("ss")+"%' GROUP BY 	\"MonthlyCurrentCTCOrearning\""; 						
						List<HashMap<String, Object>> itemss = db.executeQuery(sql);
					%>
			</div>
		<div class="ibox-content ">

			<div class="row">
			
			<div class="col-lg-11" id="container_comp_prof_<%=rowYear.get("ss") %>"  >
			
			<div class="spiner-example spinner-animation-holder_User" id="program_spiner">
								<div class="sk-spinner sk-spinner-three-bounce">
									<div class="sk-bounce1"></div>
									<div class="sk-bounce2"></div>
									<div class="sk-bounce3"></div>
								</div>
							</div>
			</div>
			
			
							
							<table class="year_wise_salary_breakdown" id='datatable_comp_prof_<%=rowYear.get("ss")%>' style='display:none'><thead><tr>
							<th></th>
							<%
							for(HashMap<String, Object> row: itemss)
							{
								%>
							<th><%=row.get("ff") %></th>
							
							<%
							}
							%>
							
							
							</tr>
							</thead>
							<tbody>
							<%
							for(HashMap<String, Object> row: itemss)
							{
								%>
							<tr><td><%=row.get("ff") %></td><td><%=row.get("cc")%></td></tr>
							
							
															
								<%
							}
							%>
							
							
							</tbody>
							</table>
							

			</div>

		</div>
	</div>
</div>
<%
}

%>







	
	
	<div class="row border-bottom white-bg ">
		<div class="ibox no-margins no-padding bg-muted p-xs">
			<div class="ibox-title">
				<h2 class="text-center">Employee Breakdown</h2>
			</div>
			<div class="ibox-content">
<% String sql3 ="SELECT  id,	\"public\".candidate_details.\"Noofyearsofpreviousexperience\" , 	\"public\".candidate_details.\"Enrollmentnumber\" as aa, 	\"public\".candidate_details.\"NameofCandidate\" as bb, 	\"public\".candidate_details.\"EducationLevel\" as cc, 	\"public\".candidate_details.\"TcDistrict\" as dd, 	\"public\".candidate_details.\"PassingoutDate\" as ee , 	CAST ( 		\"public\".candidate_details.\"MonthlyCurrentCTCOrearning\" AS INTEGER 	) AS ctc, 	\"public\".candidate_details.\"EmployerNameOrSelfEmployed\" as xx FROM 	\"public\".candidate_details WHERE 	\"EmployerNameOrSelfEmployed\" != '' and \"public\".candidate_details.\"NameofCandidate\" not like ' ' ORDER BY 	\"NameofCandidate\" limit 30 ;"; 
						
						List<HashMap<String, Object>> itemss1 = db.executeQuery(sql3);
					%>
					<div class="table-responsive">
						<table
							class="table table-striped table-bordered table-hover dataTables-example">
							<thead>
								<tr>
								<th>Id</th>
								<th>Enrolment Number</th>
									<th>Candidate Name</th>
									<th>Education Level</th>
									<th>PassingOut Date</th>
									<th>Employer Name</th>
									<th>Salary</th>
									<th>Profile</th>
									
								</tr>
							</thead>
							<tbody>
							<% for(HashMap<String, Object> row: itemss1 ) { %>
<tr>
									<td><%=row.get("id") %></td>
									<td><%=row.get("aa") %></td>
									<td><%=row.get("bb") %></td>
									<td><%=row.get("cc") %></td>
									<td><%=row.get("ee") %></td>
									<td><%=row.get("xx") %></td>
									<td><%=row.get("ctc") %></td>
									<td><a href="placement_section/candidate_profile.jsp?candidate_id=<%=row.get("id")%>" class="btn btn-w-m btn-primary">Profile</a></td>
									
								</tr>
<% } %>
							</tbody>
							<tfoot>
								<tr>
								<th>Id</th>
									<th>Candidate Name</th>
									<th>Education Level</th>
									<th>PassingOut Date</th>
									<th>Employer Name</th>
									<th>Salary</th>
									<th>Profile</th>
								</tr>
							</tfoot>
						</table>


					</div>
				</div>
		</div>
	</div>
	
	
	
	
	<br>
	<br>
	<br>
