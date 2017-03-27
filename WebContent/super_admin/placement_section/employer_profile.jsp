<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="com.istarindia.apps.dao.CollegeDAO"%>
<%@page import="com.istarindia.apps.dao.College"%>
<% 
String employer_name= request.getParameter("employee_name");

UIUtils ui_Util = new UIUtils();
DBUTILS db = new DBUTILS();
 %>

 <jsp:include page="../inc/head.jsp"></jsp:include>
<body class="top-navigation" id="super_admin_comp_prof">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="../inc/navbar.jsp"></jsp:include>

 
 
<div class="row border-bottom white-bg report-padding">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-title">
				<h2 class="text-center">Average Employment Time of Candidate with  <b><%=employer_name %></b></h2>
				<% String sql ="select cast (count(*) filter(where months_worked <=6 ) as integer) as l_t_s_m, cast (count(*) filter(where months_worked >6 and months_worked <=12)as integer) as m_t_s_m_t_y, cast (count(*) filter(where months_worked >12 and months_worked <=24)as integer) as m_t_y, cast (count(*) filter(where months_worked >24)as integer) as g_t_2y  from candidate_history where prev_company='SBGD';"; 						
						List<HashMap<String, Object>> itemss = db.executeQuery(sql);
					%>
			</div>
		<div class="ibox-content ">

			<div class="row">
			
			<div class="col-lg-11" id="container_comp_prof"  >
			
			<div class="spiner-example spinner-animation-holder_User" id="program_spiner">
								<div class="sk-spinner sk-spinner-three-bounce">
									<div class="sk-bounce1"></div>
									<div class="sk-bounce2"></div>
									<div class="sk-bounce3"></div>
								</div>
							</div>
			</div>
			
			
							
							<table id='datatable_comp_prof' style='display:none'><thead><tr>
							<th></th>
							<th>Less Then 6 Months</th>
							<th>Less than a Year</th>
							<th>More than a Year</th>
							<th></th>
							
							</tr>
							</thead>
							<tbody>
							<%
							for(HashMap<String, Object> row: itemss)
							{
								%>
							<tr><td>Less Then 6 Months</td><td><%=row.get("l_t_s_m")%></td></tr>
							<tr><td>Less than a Year</td><td><%=row.get("m_t_s_m_t_y") %></td></tr>
							<tr><td>More than a Year</td><td><%=row.get("m_t_y") %></td></tr>
							<tr><td>More than 2 Year</td><td><%=row.get("g_t_2y") %></td>	</tr>
							
															
								<%
							}
							%>
							
							
							</tbody>
							</table>
							

			</div>

		</div>
	</div>
</div>
	
	<div class="row border-bottom white-bg report-padding">
	<div class="ibox no-margins no-padding bg-muted p-xs">
		<div class="ibox-title">
				<h2 class="text-center">Employablity Over Years for <b><%=employer_name %></b></h2>
				<% String sql2 ="select count(id) as id, to_char(to_date(''||\"PassingoutDate\"||'','dd-mm-yyyy'), 'yyyy-mm-dd') as dateeeeee from candidate_details where \"EmployerNameOrSelfEmployed\" like '%"+employer_name+"%' and \"PassingoutDate\" IS NOT NULL  AND \"PassingoutDate\" != '' AND \"PassingoutDate\" !=' ' group by dateeeeee order by dateeeeee"; 	
						System.out.println(sql2);
						List<HashMap<String, Object>> itemss2 = db.executeQuery(sql2);
					%>
			</div>
		<div class="ibox-content ">

			<div class="row">
			
			<div class="col-lg-11" id="container_comp_prof1"  >
			
			<div class="spiner-example spinner-animation-holder_User" id="program_spiner">
								<div class="sk-spinner sk-spinner-three-bounce">
									<div class="sk-bounce1"></div>
									<div class="sk-bounce2"></div>
									<div class="sk-bounce3"></div>
								</div>
							</div>
			</div>
			
			
							
							<table id='datatable_comp_prof1' style='display:none'><thead><tr>
							<th>Date</th>
							<th>Number</th>
						
							
							</tr>
							</thead>
							<tbody>
							<%
							for(HashMap<String, Object> row: itemss2)
							{
								%>
							<tr>
							<td><%=row.get("dateeeeee") %></td>
							<td><%=row.get("id") %></td></tr>
							
							
															
								<%
							}
							%>
							
							
							</tbody>
							</table>
							

			</div>

		</div>
	</div>
</div>
	
	
	
	
	
	<br>
	<br>
	<br>

		</div>
	</div>
	<jsp:include page="../inc/foot.jsp"></jsp:include>
<!-- Mainly scripts -->
</body>
</html>