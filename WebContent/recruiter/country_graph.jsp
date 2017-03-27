<%@page import="java.util.List"%>
<%@page import="com.istarindia.apps.dao.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

 <div id="container"></div> 
<%
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
		+ request.getContextPath() + "/";

int rec_id =Integer.parseInt(request.getParameter("recruiter_id"));
	DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> table = db.executeQuery(
				"SELECT COUNT (DISTINCT actor_id), pincode.state_code FROM jobs_event, student_profile_data, pincode, vacancy WHERE LATTIUDE IS NOT NULL AND LONGITUDE IS NOT NULL AND vacancy. ID = jobs_event.vacancy_id AND student_profile_data.pincode = pincode.pin AND student_profile_data.student_id = jobs_event.actor_id AND "
				+" vacancy.recruiter_id = "+rec_id+" GROUP BY pincode.state_code");
	System.out.println("SELECT COUNT (DISTINCT actor_id), pincode.state_code FROM jobs_event, student_profile_data, pincode, vacancy WHERE LATTIUDE IS NOT NULL AND LONGITUDE IS NOT NULL AND vacancy. ID = jobs_event.vacancy_id AND student_profile_data.pincode = pincode.pin AND student_profile_data.student_id = jobs_event.actor_id AND "
			+" vacancy.recruiter_id = "+rec_id+" GROUP BY pincode.state_code");
	
	%>
	<script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
	<script src="https://code.highcharts.com/maps/highmaps.js"></script>
	<script src="https://code.highcharts.com/maps/modules/map.js"></script>

<script src="https://code.highcharts.com/mapdata/countries/in/custom/in-all-disputed.js"></script>

<div id="container"></div>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.3.6/proj4.js"></script>
	<script type="text/javascript">
	
	$(function () {

	    // Prepare demo data
	    var data = [
	       <% for(HashMap<String, Object> row: table) { %> 
	    	
	    	{
	    		
	    	
	            "hc-key": "<%=row.get("state_code").toString().toLowerCase()%>",
	            "value": <%=row.get("count")%>
	        },
	       <%} %>
]
	    // Initiate the chart
	    $('#container').highcharts('Map', {

	    	chart :{
	    		height: 600
	    	},
	        title : {
	            text : 'Vacancy Distribution across the Country'
	        },

	        subtitle : {
	            text : ''
	        },

	        mapNavigation: {
	            enabled: true,
	            buttonOptions: {
	                verticalAlign: 'bottom'
	            }
	        },

	        colorAxis: {
	            min: 0
	        },

	        series : [{
	            data : data,
	            mapData: Highcharts.maps['countries/in/custom/in-all-disputed'],
	            joinBy: 'hc-key',
	            name: 'Random data',
	            states: {
	                hover: {
	                    color: '#BADA55'
	                }
	            },
	            dataLabels: {
	                enabled: true,
	                format: '{point.name}'
	            }
	        }]
	    });
	});
	
	Highcharts.theme = {
			   colors: ['#1AB395', '#63D2BD', '#3AC0A6', '#009D7E', ' #007861', '#004638', '#00726E',
			      '#009590', '#39BAB6', '#62CECA', '#19ACA7'],
			   
			   // General
			   background2: '#F0F0EA'

			};
	Highcharts.setOptions(Highcharts.theme);


</script>