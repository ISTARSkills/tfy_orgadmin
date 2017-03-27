<div class="panel-body">

	<div class="graph_holder" id="container" ></div>
	<table class="data_holder" data-report_title="Monthly Average Performance" data-graph_holder="container" id="datatable" 
	 data-graph_type="column">
		
		 <thead>
        <tr>
            <th></th>
            <th>Jane</th>
            <th>John</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th>Apples</th>
            <td>3</td>
            <td>4</td>
        </tr>
        <tr>
            <th>Pears</th>
            <td>2</td>
            <td>0</td>
        </tr>
        <tr>
            <th>Plums</th>
            <td>5</td>
            <td>11</td>
        </tr>
        <tr>
            <th>Bananas</th>
            <td>1</td>
            <td>1</td>
        </tr>
        <tr>
            <th>Oranges</th>
            <td>2</td>
            <td>4</td>
        </tr>
    </tbody>
	</table>

</div><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>


<script>
$( document ).ready(function() {
Highcharts.chart('container', {
		data : {
			table : 'datatable'
		},
		chart : {
			type : 'column'
		},
		title : {
			text : 'Data extracted from a HTML table in the page'
		}
	});
});
</script>