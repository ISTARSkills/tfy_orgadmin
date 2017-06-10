<jsp:include page="inc/head.jsp" />

<body class="top-navigation" id="orgadmin_report_detail">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			
			<jsp:include page="inc/navbar.jsp"></jsp:include>
			
			<jsp:include page="report_section/programs_report_details.jsp">
				<jsp:param name="course_id"
					value='<%=request.getParameter("course_id")%>' />
				<jsp:param name="batch_id"
					value='<%=request.getParameter("batch_id")%>' />
				<jsp:param name="headname"
					value='<%=request.getParameter("headname")%>' />
			</jsp:include></div>

	</div>
	<!-- Mainly scripts -->
	<jsp:include page="inc/foot.jsp"></jsp:include>
	
</body>
<script>
var chart;
$(document).ready(function() {
    $('#mastery_per_skill').highcharts({
        chart: {
            type: 'column',
            events: {
                drilldown: function (e) {
                    if (!e.seriesOptions) {
                        var chart = this,
                            drilldowns = {
                                'Animals': {
                                    name: 'Animals',
                                   
                                    data: [
                                        ['Cows', 2],
                                        ['Sheep', 3]
                                    ]
                                },
                                'Fruits': {
                                    name: 'Fruits',
                                   
                                    data: [
                                        ['Oranges', 3],
                                        ['Bananas', 2]
                                    ]
                                }
                            },
                            drilldowns2 = {
                                'Animals': {
                                    name: 'Animals',
                                   
                                    data: [
                                        ['Cows', 8],
                                        ['Sheep', 7]
                                    ]
                                },
                                'Fruits': {
                                    name: 'Fruits',
                                   
                                    data: [
                                    {name: 'Oranges', y: 6, drilldown: true},      
                                    {name: 'Bananas', y: 1, drilldown: true}             
                                    ]
                                }
                            },
                            series = drilldowns[e.point.name],
                            series2 = drilldowns2[e.point.name];
                            chart.addSingleSeriesAsDrilldown(e.point, series); 
                            chart.addSingleSeriesAsDrilldown(e.point, series2);
                            chart.applyDrilldown();
                    }
                }
            }
        },
        title: {
            text: 'Async drilldown'
        },
        xAxis: {
            type: 'category'
        },
        legend: {
            enabled: false
        },
        plotOptions: {
        column: {stacking: 'normal'},
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                    style: { textShadow: false, fontSize: '1vw' }
                }
            }
        },
        series: [{
            name: 'Things',
            color: '#3150b4',
            data: [{
                name: 'Animals',
                y: 5,
                drilldown: true
            }, {
                name: 'Fruits',
                y: 5,
                drilldown: true
            }]
        },{
            name: 'MyThings',
            color: '#50B432',
            data: [{
                name: 'Animals',
                y: 15,
                drilldown: true
            }, {
                name: 'Fruits',
                y: 7,
                drilldown: true
            }]
        }],
        drilldown: {
            series: []
        }
    });
});
</script>
</html>
