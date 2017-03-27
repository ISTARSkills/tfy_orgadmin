<%@page import="java.sql.Timestamp"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.*"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="com.istarindia.apps.dao.*"%>
<!DOCTYPE html>
<html>
<%

String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";


DatatableUtils dtUtils = new DatatableUtils();
HashMap<String, String> conditions = new HashMap<>();
String date1= null;

String batch_id ="";
String date_time_key ="";
String event_id ="";
String trainer_name ="";

if(request.getParameterMap().containsKey("batch_id"))
{
	batch_id = request.getParameter("batch_id");
	System.out.println(batch_id);
}
if(request.getParameterMap().containsKey("event_id"))
{
	event_id = request.getParameter("event_id");
	
}
if(request.getParameterMap().containsKey("trainer_name"))
{
	trainer_name = request.getParameter("trainer_name");
	
}
if(request.getParameterMap().containsKey("date_time_key"))
{
	date_time_key = request.getParameter("date_time_key");
	
	
	SimpleDateFormat  oldDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	SimpleDateFormat  newDateFormat = new SimpleDateFormat("dd MMM yyyy hh:mm a");
	Date date = oldDateFormat.parse(date_time_key.replace("T", ""));
	  date1 = newDateFormat.format(date);
	

	
	
}
%>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Portal | Invoice Print</title>

    <link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="<%=baseURL%>css/animate.css" rel="stylesheet">
    <link href="<%=baseURL%>css/style.css" rel="stylesheet">

</head>

            <body class="white-bg">
                <div class="wrapper wrapper-content p-xl">
                    <div class="ibox-content p-xl">
                              <div class="ibox-content p-xl">
                              
                              <%
                              DBUTILS util = new DBUTILS();
                              String sql_data1 ="SELECT name FROM batch WHERE id='"+batch_id+"'"; 
                              System.out.println(sql_data1);
                              
                              List<HashMap<String, Object>> data1 = util.executeQuery(sql_data1);
                              if(data1.size()>0)
                              {	
                           	   
                           		
                              	for(HashMap<String, Object> row1 : data1)
                              	{
                              		String Bname = (String)row1.get("name");
                              	
                              		
                              	
                              
                              %>
                              
                            <div class="row">
                                <div class="col-sm-6">
                                    <h3>Batch Name: <%=Bname %></h3>
                                    <address>
                                    <h5>Trainer Name: <%=trainer_name %></h5><br>
                                        <h5>Event Date/Time: <%=date1 %></h5><br>
                                        </address>
                                </div>

                         
                            </div>
                            <% 
                              	}
                            	}
                            %>

                            <div class="table-responsive m-t">
                                <table class="table invoice-table">
                                    <thead>
                                    <tr>
                                        <th>Student ID</th>
                                        <th>Student Name</th>
                                        <th>Attendance</th>
                                     
                                    </tr>
                                    </thead>
                                    <%
                                    String sql_data ="SELECT 	student. ID AS s_id, 	student. NAME AS s_name, 	attendance.status AS status FROM 	attendance, 	student WHERE 	student. ID = attendance.user_id AND attendance.event_id ='"+event_id+"'"; 
                                    System.out.println(sql_data);
                                   
                                    List<HashMap<String, Object>> data = util.executeQuery(sql_data);
                                    if(data.size()>0)
                                    {	
                                 	   
                                 		
                                    	for(HashMap<String, Object> row : data)
                                    	{
                                    		String Sname = (String)row.get("s_name");
                                    		int id = (int)row.get("s_id");
                                    		String attendance = (String)row.get("status");
                                    		
                                    	
                                    
                                    %>
                                  
                                    <tbody>
                                    <tr>
                                         <td><%=id %></td> 
                                         <td><%=Sname %></td>
                                         <td><%=attendance %></td>
                                        
                                    </tr>
                                    
                                    
                               
                                  <%
                                  
                                  }
                                    	}%>

                                    </tbody>
                                </table>
                            </div>

                        
                           

                            
                        </div>

    </div>

    <!-- Mainly scripts -->
    <script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
    <script src="<%=baseURL%>js/bootstrap.min.js"></script>
    <script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="<%=baseURL%>js/inspinia.js"></script>

    <script type="text/javascript">
    
    
        window.print();
    </script>

</body>

</html>