<%@page import="in.orgadmin.utils.report.ReportUtils"%>
<%@page import="java.util.HashMap"%>
<%
String reportId = request.getParameter("report_id");
String reportName = request.getParameter("report_name");
String orgId = request.getParameter("organziation_id");
ReportUtils util = new ReportUtils();
%>
<jsp:include page="inc/head.jsp"></jsp:include>
<body class="top-navigation" >
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			<div class="row wrapper border-bottom white-bg page-heading">
                <div class="col-lg-10">
                    <h2><%=reportName %></h2>
                    <ol class="breadcrumb">
                        <li>
                            <a href="dashboard.jsp">Dashboard</a>
                        </li>
                        <li>
                            <a>Custom Reports</a>
                        </li>
                        <li class="active">
                            <strong><%=reportName %></strong>
                        </li>
                    </ol>
                </div>
                <div class="col-lg-2">

                </div>
            </div><div class="row">

			<div class="col-lg-12">
				
				<div class="no-paddings bg-muted">
					<%--  <div class="ibox-title">
                        <h5><%=reportName %></h5>
                        
                    </div> --%>
					<div class="ibox-content">
						<%HashMap<String, String> conditions = new HashMap();
						conditions.put("limit", "12");
						conditions.put("offset", "0");
						conditions.put("org_id", orgId);
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
	<jsp:include page="inc/foot.jsp"></jsp:include>
<!-- Mainly scripts -->
</body>
 
<script>
function callFilterAjaxCall(filterParam,report_id)
{
	var id = 'chart_datatable_'+report_id;
	var url = '../custom_report_datatable_filter?';
	$.each(filterParam, function( index, value ) {
		url +=index+'='+value+'&';			
		});
	
	
	$('#'+id).DataTable({
        pageLength: 10,
        responsive: true,
        dom: '<"html5buttons"B>lTfgitp',
        buttons: [
            { extend: 'copy'},
            {extend: 'csv'},
            {extend: 'excel', title: 'ExampleFile'},
            {extend: 'pdf', title: 'ExampleFile'},
            {extend: 'print',
             customize: function (win){
                    $(win.document.body).addClass('white-bg');
                    $(win.document.body).css('font-size', '10px');
                    $(win.document.body).find('table')
                            .addClass('compact')
                            .css('font-size', 'inherit');
            }
            }
        ], "processing": true,
        "serverSide": true,
        "ajax": url,
        "drawCallback": function( settings ) {			            
        }
    });
	
	$(this).on( 'draw.dt', function () {
	    //after draw
	});
	$('.dataTables_info').hide();
}


$(document).ready(function(){
	
	var startDate;
	var endDate;
	
	var report_id = <%=reportId%>;
	var org_id = <%=orgId%>;
	var filterParam=[];   
	 
	$('.date_range_filter').each(function() 
	{
		var id = $(this).attr('id');
		$('#'+id+' span').html(moment().subtract(29, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
		
		$(this).daterangepicker({
	         format: 'MM/DD/YYYY',
	         startDate: moment().subtract(29, 'days'),
	         endDate: moment(),
	         minDate: '01/01/2012',
	         maxDate: '12/31/2015',
	         dateLimit: { days: 60 },
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
	         startDate = start.toISOString();
	         endDate =end.toISOString();
	         var filter_name = $(this).data('filter_name');
	         filterParam[filter_name]= startDate+'!#'+endDate;	         
	         callFilterAjaxCall(filterParam,report_id);
	     });
	});
	 
     
       $( ".int_filter" ).each(function() {
    	   $this =   $(this);
    	   var filter_name=$(this).data('filter_name');
    	   $this.ionRangeSlider({
    	         type: 'double',
    	         prettify: false,
    	         hasGrid: true, 
    	         onChange: function (data) {

    	         },
    	         onFinish: function (data) {
    	        	 filterParam[filter_name]= $this.attr("value");
    	        	 callFilterAjaxCall(filterParam,report_id);
    	         },
    	     });
    	}); 
     
   
	$('.data_table_filter').unbind().on('change', function(){
	   var id = $(this).attr('id');
	   var filter_name = $(this).data('filter_name');
	   var filter_value =$("#"+id+" option:selected").text();
	   filterParam[filter_name]= filter_value;
	   callFilterAjaxCall(filterParam,report_id);
	   
	});
      
     

       
       
});


</script>

</html>