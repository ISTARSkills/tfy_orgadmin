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
//Marh 18, 2014
DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
Date date = new Date();
//System.out.println(); 
String date_string=" "+dateFormat.format(date);

DatatableUtils dtUtils = new DatatableUtils();
HashMap<String, String> conditions = new HashMap<>();

int k = 0;
int i = 0;
String j ="";
String trainer_id ="";
String start_date ="";
String end_date ="";

if(request.getParameterMap().containsKey("trainer_id"))
{
	trainer_id = request.getParameter("trainer_id");
	System.out.println(trainer_id);
}
if(request.getParameterMap().containsKey("end_date"))
{
	end_date = request.getParameter("end_date");
	System.out.println("eeeeeeeeeeeeeeeeeeee"+end_date);
}
if(request.getParameterMap().containsKey("start_date"))
{
	start_date = request.getParameter("start_date");
	System.out.println("sssssssssssssss"+start_date);
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
                            <div class="row">
                                <div class="col-sm-6">
                                    <h5>From:</h5>
                                    <address>
                                        <strong>Istar Skill Development Pvt. Ltd</strong><br>1st Floor, "Akshaya", 63/2, 18th Cross,<br> Malleswaram, Bengaluru<br>
                                       Karnataka 560055<br>
                                        <abbr title="Phone">Phone:</abbr>  080 4128 1021
                                    </address>
                                </div>

                                <div class="col-sm-6 text-right">
                                    <h4>Invoice No.</h4>
                                    <h4 class="text-navy">INV-000567F7-00</h4>
                                    <span>To:</span>
                                    <address>
                                        <strong>Istar Skill Development Pvt. Ltd</strong><br>1st Floor, "Akshaya", 63/2, 18th Cross,<br> Malleswaram, Bengaluru<br>
                                       Karnataka 560055<br>
                                        <abbr title="Phone">Phone:</abbr>  080 4128 1021
                                    </address>
                                    <p>
                                        <span><strong>Invoice Date:</strong><%=date_string %></span><br/>
                                        
                                    </p>
                                </div>
                            </div>

                            <div class="table-responsive m-t">
                                <table class="table invoice-table">
                                    <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Trainer</th>
                                        <th>Event Name</th>
                                        <th>Hours</th>
                                     
                                    </tr>
                                    </thead>
                                    
                                   <%
                                   if(trainer_id.equalsIgnoreCase(""))
									{
                                	   
                                	   
                                	   
									}else{
										
										 DBUTILS util = new DBUTILS();
                                   String sql_data ="SELECT 	batch_schedule_event.eventdate as date, 	SUBSTRING(batch_schedule_event.event_name,22) as e_name, 	sum((batch_schedule_event.eventhour*60 + batch_schedule_event.eventminute) )as duration, 	student.name as s_name, student.id as stu_id FROM 	batch_schedule_event,   student WHERE batch_schedule_event. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND batch_schedule_event.event_name LIKE '%REAL EVENT%' AND batch_schedule_event.actor_id = student.id AND cast (batch_schedule_event.eventdate as date) >='"+start_date+"' AND cast (batch_schedule_event.eventdate as date) <= '"+ end_date+"' and student.user_type='TRAINER' and student.id = "+trainer_id+" GROUP BY student.name, student.id, eventdate,batch_schedule_event.event_name order by batch_schedule_event.eventdate DESC"; 
                                   System.out.println(sql_data);
                                  
                                   List<HashMap<String, Object>> data1 = util.executeQuery(sql_data);
                                   if(data1.size()>0)
                                   {	
                                	   
                                		
                                   	for(HashMap<String, Object> row1 : data1)
                                   	{
                                   		String name = (String)row1.get("s_name");
                                   		String class_room = (String)row1.get("e_name");
                                   		Timestamp dates = (Timestamp)row1.get("date");
                                   		BigInteger duration = (BigInteger)row1.get("duration");
                                   		
                                   		  i = duration.intValue();
                                
                                             k = k + i;
                                             
                                   	   j = duration.toString();
                                 		
                                   			if(i<=60){
                                   		
                                   				j = i+" min" ;
                                   			    
                                   				
                                   			}else if((i > 60) && (i / 60 == 0)){
                                   				
                                   				
                                   				j = i/60 +" hrs";
                                   				
                                   			}else if((i > 60) && (i / 60 != 0)){
                                   				
                                   				j = i/60 + " hrs " + i%60+" min ";
                                   			}
                                 
                                   %>
                                    <tbody>
                                    <tr>
                                         <td><%=dates %></td> 
                                        <td><%=name %></td>
                                        <td><%=class_room %></td>
                                         <td><%=j%></td> 
                                        
                                    </tr>
                                    
                                    
                                  <%
                                  
                                   	} 
                                   	
                                   }} %>
                                  

                                    </tbody>
                                </table>
                            </div><!-- /table-responsive -->

                            <table class="table invoice-total">
                            <%
                            if(k<=60){
                           		
                   				j = k+" min" ;
                   			    
                   				
                   			}else if((k > 60) && (k / 60 == 0)){
                   				
                   				
                   				j = k/60 +" hrs";
                   				
                   			}else if((k > 60) && (k / 60 != 0)){
                   				
                   				j = k/60 + " hrs " + k%60+" min ";
                   			}
                            
                        
                         
                            %>
                            
                                <tbody>                             
                                <tr>
                                    <td><strong>TOTAL :</strong></td>
                                    <td><%=j %></td>
                                </tr>
                                </tbody>
                            </table>
                           

                            
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
