<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
           <%
				String url = request.getRequestURL().toString();
				String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
						+ request.getContextPath() + "/";
			%>

<%
String reportId = request.getParameter("report_id");
String reportName = request.getParameter("report_name");
//String orgId = request.getParameter("organziation_id");
ReportUtils util = new ReportUtils();
%>
<jsp:include page="/inc/head.jsp"></jsp:include>
<body class="top-navigation" id="custom_task_report_superadmin">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
			<div class="row wrapper border-bottom white-bg page-heading" style="padding-bottom: 10px;
    padding-left: 20px;">
                <div class="row">
							<div class="col-xs-12">
								<div class="page-title-box">
                                    <h4 class="page-title"><%=reportName %> </h4>
                                    <ol class="breadcrumb p-0 m-0">
                                        <li>
                                            <a href="#">Dashboard</a>
                                        </li>
                                        <li>
                                            <a href="#">Custom Reports </a>
                                        </li>
                                        <li class="active">
                                            <%=reportName %>
                                        </li>
                                    </ol>
                                    <div class="clearfix"></div>
                                </div>
							</div>
						</div>
                <div class="col-lg-2">

                </div>
            </div><div class="row">

			<div class="col-lg-12">
				
				<div class="no-paddings bg-muted">
						<div class="ibox-content card-box margin-box ">
						<%HashMap<String, String> conditions = new HashMap();
						conditions.put("limit", "10");
						conditions.put("offset", "0");
						/* conditions.put("org_id", orgId); */
						conditions.put("static_table", "true");	
						
						%>
						
						<%= util.getTableFilters(Integer.parseInt(reportId), conditions) %>
						
						
						
                           						
						<%= util.getTableOuterHTML(Integer.parseInt(reportId), conditions) %>
				<%%>
					</div>
				</div>
				</div>
				</div>
				
				
		</div>
	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
<!-- Mainly scripts -->
</body>
 
<script>
$(document).ready(function(){
	
	var startDateVar;
	var endDateVar;
	
	var report_id = <%=reportId%>;
	<%-- var org_id = <%=orgId%>; --%>
	
	deleteTaskFunction();
	
	
	
	
	
	var filterParam=[];   
	$('.date_range_filter').each(function() 
	{
		var id = $(this).attr('id');
		var min_date = $(this).data('min_date'); //June 12, 2017
		var max_date = $(this).data('max_date');
		var monthArray= [];
		monthArray['January']='01';
		monthArray['February']='02';
		monthArray['March']='03';
		monthArray['April']='04';
		monthArray['May']='05';
		monthArray['June']='06';
		monthArray['July']='07';
		monthArray['August']='08';
		monthArray['September']='09';
		monthArray['October']='10';
		monthArray['November']='11';
		monthArray['December']='12';
		
		startDateVar = min_date.split(" ")[2]+monthArray[min_date.split(" ")[0]]+min_date.split(" ")[1].replace(",","");
		endDateVar = max_date.split(" ")[2]+monthArray[max_date.split(" ")[0]]+max_date.split(" ")[1].replace(",","");
		$('#'+id+' span').html(min_date + ' - ' + max_date);
		var column_number = $(this).data('column_number');
		$(this).daterangepicker({
	         format: 'MM/DD/YYYY',
	         startDate: moment().subtract(29, 'days'),
	         endDate: moment(),
	         minDate: '01/01/2016',
	         maxDate: '12/31/2020',
	         dateLimit: { days: 120 },
	         showDropdowns: true,
	         showWeekNumbers: true,
	         timePicker: false,
	         timePickerIncrement: 1,
	         timePicker12Hour: true,
	         ranges: {
	             'Today': [moment(), moment()],
	             'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
	             'Last 7 Days': [moment().subtract(6, 'days'), moment()],
	             'Last 30 Days': [moment().subtract(29, 'days'), moment()],
	             'This Month': [moment().startOf('month'), moment().endOf('month')],
	             'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
	         },
	         opens: 'right',
	         drops: 'down',
	         buttonClasses: ['btn', 'btn-sm'],
	         applyClass: 'btn-primary',
	         cancelClass: 'btn-default',
	         separator: ' to ',
	         locale: {
	             applyLabel: 'Submit',
	             cancelLabel: 'Cancel',
	             fromLabel: 'From',
	             toLabel: 'To',
	             customRangeLabel: 'Custom',
	             daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr','Sa'],
	             monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
	             firstDay: 1
	         }
	     }, function(start, end, label) {	         	  
	    	 $('#'+id+' span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));	
	         console.log(start.toISOString(), end.toISOString(), label);
	         startDateVar = start.format('YYYYMMDD');
	         endDateVar =end.format('YYYYMMDD');
	          var id = '#chart_datatable_'+report_id;
        	  var table = $(id).DataTable();
               table.draw(); 
        	  
	     });
		
		
		$.fn.dataTableExt.afnFiltering.push(
				function(oSettings, aData, iDataIndex){
					var dateStart = startDateVar;
					var dateEnd = endDateVar;
					// aData represents the table structure as an array of columns, so the script access the date value 
					// in the first column of the table via aData[0]
					var evalDate= parseDateValue(aData[column_number]);
					
					if (evalDate >= dateStart && evalDate <= dateEnd) {
						return true;
					}
					else {
						return false;
					}
					
				});

	});
	 
     
       $( ".int_filter" ).each(function() {
    	   $this =   $(this);
    	   var filter_name=$(this).data('filter_name');
    	   var column_number = $this.data('column_number');
    	   $this.ionRangeSlider({
    	         type: 'double',
    	         prettify: false,
    	         hasGrid: true, 
    	         onChange: function (data) {
					
    	         },
    	         onFinish: function (data) {
    	        	 var id = '#chart_datatable_'+report_id;
    	        	 var table = $(id).DataTable();
    	        	 table.draw();
    	        	 $.fn.dataTable.ext.search.push(
 	        			    function( settings, data, dataIndex ) {
 	        			        var min = parseInt($this.attr("value").split(';')[0]);
 	        			        var max = parseInt(  $this.attr("value").split(';')[1]);
 	        			        var age = parseFloat( data[column_number] ) || 0; // use data for the age column 	        			 
 	        			        if ( ( isNaN( min ) && isNaN( max ) ) ||
 	        			             ( isNaN( min ) && age <= max ) ||
 	        			             ( min <= age   && isNaN( max ) ) ||
 	        			             ( min <= age   && age <= max ) )
 	        			        {
 	        			            return true;
 	        			        }
 	        			        return false;
 	        			    }
 	        	);
    	        	
    	         },
    	     });
    	}); 
     
   
	$('.data_table_filter').unbind().on('select2:select select2:unselecting', function(){
	   var id = $(this).attr('id');
	   
	   var tableId = '#chart_datatable_'+report_id;
  	   var table = $(tableId).DataTable();
  	   if($("#"+id+" option:selected")!=null && $("#"+id+" option:selected").val()!=null && $("#"+id+" option:selected").val()!=''){
  		 var filter_name = $(this).data('filter_name');
  	     var filter_value =$("#"+id+" option:selected").text();
  	     var column_number = $('#'+id).data('column_number');
  	     table.columns(column_number).search(filter_value).draw();
  	   }
  	   else
  		{ var column_number = $('#'+id).data('column_number');
  		 table.columns(column_number).search('').draw();
  		}	   
  	   
  	   $('#'+id).select2();
  	 deleteTaskFunction();
	});  
	
	function parseDateValue(rawDate) {
		var monthArray= [];
		monthArray['Jan']='01';
		monthArray['Feb']='02';
		monthArray['Mar']='03';
		monthArray['Apr']='04';
		monthArray['May']='05';
		monthArray['Jun']='06';
		monthArray['Jul']='07';
		monthArray['Aug']='08';
		monthArray['Sep']='09';
		monthArray['Oct']='10';
		monthArray['Nov']='11';
		monthArray['Dec']='12';
		
		var dateArray= rawDate.split(" ")[0].split("-");
		var parsedDate= dateArray[2] + monthArray[dateArray[1]] + dateArray[0];
		return parsedDate;
	}

	
	 $('#chart_datatable_'+report_id).on( 'draw.dt', function () {
		 
		    deleteTaskFunction();
	  } );
       
       
});


</script>
<script>
function deleteTaskFunction(){
	
	
$(".delete_task_btn").click(function(){
	    
		var task_id = "";
		var student_playlist_id =  "";
		var start_date = "";
		var end_date = "";
		var course = "";
		var entity_type = "";
		var entity_id = "";
		
		var key = $(this).attr("data-task_delete");
		if(key === 'task_delete'){
			 task_id = $(this).attr("data-task");
			 student_playlist_id =  $(this).attr("data-student_playlist_id");
		}if(key === 'auto_scheduler_task_delete'){
			
			 start_date = $(this).attr("data-start_date");
			 end_date = $(this).attr("data-end_date");
			 course = $(this).attr("data-course");
			 entity_type = $(this).attr("data-entity_type");
			 entity_id = $(this).attr("data-entity_id");
		}
		
		
		
		$.ajax({
	        type: "POST",
	        url: '<%=baseURL%>task_delete',
	        data: {
	        	key:key,
	        	task_id:task_id,
	        	student_playlist_id:student_playlist_id,
	        	start_date:start_date,
	        	end_date:end_date,
	        	entity_type:entity_type,
	        	entity_id:entity_id,
	        	course:course
	        },
	        success: function(result) {
	          
	        	
	        	location.reload();
	        }
	    });
	          
	  });
	
	
}


</script>
</html>