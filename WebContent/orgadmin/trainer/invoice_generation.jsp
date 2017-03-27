<%@page import="java.sql.Timestamp"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.*"%>
<%@page import="in.orgadmin.utils.DatatableUtils"%>
<%@page import="com.istarindia.apps.dao.*"%>
<!DOCTYPE html>
<html>

<head>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
	//Marh 18, 2014
	DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
Date date = new Date();
//System.out.println(); 
	String date_string=" "+dateFormat.format(date);
	
	int k = 0;
	int i = 0;
	String j ="";
	String drange="";
	String start_date="";
	String end_date="";
	String trainer_id="";

		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd");


	if(request.getParameterMap().containsKey("daterange"))
	{
		System.out.println(request.getParameter("daterange"));
		drange = request.getParameter("daterange");
		start_date = drange.split("-")[0].trim();
		end_date = drange.split("-")[1].trim();
		 
		  start_date = formatter1.format(formatter.parse(start_date));
		  end_date = formatter1.format(formatter.parse(end_date));
		 
		 
		 System.out.println(start_date+"---------------------------------"+end_date);
	}
	
	if(request.getParameterMap().containsKey("trainer_id"))
	{
		trainer_id = request.getParameter("trainer_id");
		System.out.println(trainer_id);
	}
	
	DatatableUtils dtUtils = new DatatableUtils();
	HashMap<String, String> conditions = new HashMap<>();
	
%>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>INSPINIA | Invoice Generate</title>

    <link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="<%=baseURL%>css/animate.css" rel="stylesheet">
    <link href="<%=baseURL%>css/style.css" rel="stylesheet">
<link
	href="<%=baseURL%>css/plugins/daterangepicker/daterangepicker-bs3.css"
	rel="stylesheet">
</head>

<body>

    <div id="wrapper">

		<jsp:include page="../includes/sidebar.jsp"></jsp:include>

        <div id="page-wrapper" class="gray-bg">
        <div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
			</div>
            <div class="row wrapper border-bottom white-bg page-heading">
                <div class="col-lg-8">
                <form action="<%=baseURL%>orgadmin/trainer/invoice_generation.jsp" method="get" class="form-horizontal">
							
                    <h2>Invoice</h2>
                    <h3>Date Range Picker</h3>


									<input class="form-control" type="text" name="daterange" id="daterange"
										value="07/01/2016 - 07/01/2016" />



									<h3>Selected Trainer</h3>
									
								
											<select class="form-control m-b" name="trainer_id" id='id__trainer_id'>
													
														
														<% 
														 
                                    DBUTILS util = new DBUTILS();
									String sql ="select id , email, name from student where user_type='TRAINER' order by email";
									List<HashMap<String, Object>> data = util.executeQuery(sql);
                                    if(data.size()>0)
                                    {	
                                    	for(HashMap<String, Object> row : data)
                                    	{
                                    		int id= (int)row.get("id");
                                    		String email= (String)row.get("email");
                                    		String name = (String)row.get("name");
                                    %>
														<option value="<%=id%>"><%=name %>, Email :<%=email %></option>
														<%
                                    	}
                                    }
														
                                    %>
													</select>
													<button class="btn btn-primary " type="submit" id="show_table"><i class="fa fa-check"></i>&nbsp;Generate Report</button>
					 </from>				
                </div>
                <div class="col-lg-4">
                    <div class="title-action">
                       
                        
                        <a href="print_invoice.jsp?trainer_id=<%=trainer_id %>&start_date=<%=start_date %>&end_date=<%=end_date%>" target="_blank"  id="print" class="btn btn-primary"><i class="fa fa-print"></i> Print Invoice </a>
                    </div>
                </div>
            </div>
        <div class="row" id="print_page">
            <div class="col-lg-12">
                <div class="wrapper wrapper-content animated fadeInRight">
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
                                	   
                                	   conditions.clear();
                                	   
									}else{
										
								
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
            </div>
        </div>
      

        </div>
        </div>

    <!-- Mainly scripts -->
    <script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
    <script src="<%=baseURL%>js/bootstrap.min.js"></script>
    <script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    
    <script
		src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Date range use moment.js same as full calendar plugin -->
	<script src="<%=baseURL%>js/plugins/fullcalendar/moment.min.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="<%=baseURL%>js/inspinia.js"></script>
    <script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>
           <script src="<%=baseURL%>js/highcharts-custom.js"></script>
    
    	<!-- Date range picker -->
	<script src="<%=baseURL%>js/plugins/daterangepicker/daterangepicker.js"></script>
	<script>
	

	$(document).ready(function() {
		
		var d = new Date();

		var month = d.getMonth()+1;
		var day = d.getDate();

		var output = d.getFullYear() + '/' +
		    ((''+month).length<2 ? '0' : '') + month + '/' +
		    ((''+day).length<2 ? '0' : '') + day;
		
		console.log(output);
		$('#current_date').val(output);
		
        $('input[name="daterange"]').daterangepicker({ startDate: new Date(), endDate: new Date() });
   });
   
	

	
	</script>

</body>

</html>