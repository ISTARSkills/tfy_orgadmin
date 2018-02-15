/**
 * 
 */
package in.orgadmin.utils.report;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.logger.ViksitLogger;
import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.utils.CMSRegistry;

/**
 * @author Vaibhav
 *
 */
public class ReportUtils {

	public StringBuffer getHTML(int reportID, HashMap<String, String> conditions) {
		Report report = getReport(reportID);
		//ViksitLogger.logMSG(this.getClass().getName(),(report.getSql());
		String sql1 = report.getSql();
		for (String key : conditions.keySet()) {
			//ViksitLogger.logMSG(this.getClass().getName(),"key->" + key + "   value-> " + conditions.get(key));
			String paramName = ":" + key;
			if (sql1.contains(paramName)) {

				sql1 = sql1.replaceAll(paramName, conditions.get(key));
			}
		}
		//ViksitLogger.logMSG(this.getClass().getName(),"report type>>" + report.getType_of_report());
		return getGraphHTML(sql1, report);

		// return out;

	}

	/*
	 * public JSONArray getDataTableBody(String searchTerm, int reportId,
	 * HashMap<String, Object> condition) {
	 * 
	 * }
	 */

	public StringBuffer getTableOuterHTML(int reportID, HashMap<String, String> conditions) {
		Report report = getReport(reportID);
		StringBuffer out = new StringBuffer();
		String dataAttrString = "";
		for (String key : conditions.keySet()) {
			dataAttrString += "data-" + key + "='" + conditions.get(key) + "'  ";
		}
		out.append("<table class='table table-bordered datatable_istar' " + dataAttrString + " id='chart_datatable_"
				+ report.getId() + "' data-report_id='" + report.getId() + "'>");
		out.append("<thead> <tr>");
		int colCount =0;
		for (IStarColumn iterable_element : report.getColumns()) {
			try {
				if (iterable_element.isVisible) {
					out.append("<th data-visisble='true' data-column_number='"+colCount+"'>" + iterable_element.getDisplayName() + "</th>");
				}
			} catch (Exception e) {
			}
			colCount++;
		}
		out.append("</tr></thead>");

		if (conditions.containsKey("static_table")) {

			DBUTILS db = new DBUTILS();
			String sql1 = report.getSql();
			for (String key : conditions.keySet()) {
				String paramName = ":" + key;
				if (sql1.contains(paramName)) {
					//ViksitLogger.logMSG(this.getClass().getName(),"key->" + key + "   value-> " + conditions.get(key));
					sql1 = sql1.replaceAll(paramName, conditions.get(key));
				}
			}
			
			ViksitLogger.logMSG(this.getClass().getName(),"sql1sql1->" + sql1);
			List<HashMap<String, Object>> data = db.executeQuery(sql1);
			out.append("<tbody>");
			for (HashMap<String, Object> hashMap : data) {
				//String resultSize = hashMap.get("total_rows").toString();
				out.append("<tr>");
				for (IStarColumn iterable_element : report.getColumns()) {
					if (iterable_element.isVisible) {
						
						if(iterable_element.getColumnHandler().equalsIgnoreCase("NONE"))
						{
							out.append("<td>" + hashMap.get(iterable_element.getName()) + "</td>");
						}
						else
						{
							ColumnHandler handler= ReportColumnHandlerFactory.getInstance().getHandler(iterable_element.getColumnHandler());
							
							String val="";
							String order="";
							if(handler!=null && hashMap.get(iterable_element.getName())!=null && handler.getHTML(hashMap.get(iterable_element.getName()).toString(), reportID)!=null){
								val= handler.getHTML(hashMap.get(iterable_element.getName()).toString(), reportID).toString();;
								order = handler.getOrder(hashMap.get(iterable_element.getName()).toString(), reportID).toString();;
							}
							
							out.append("<td data-order='"+order+"'>" + val + "</td>");
						}
						
						
					}
				}

				out.append("</tr>");
			}
			out.append("</tbody>");
			
			out.append("<tfoot> <tr>");

			for (IStarColumn iterable_element : report.getColumns()) {
				try {
					if (iterable_element.isVisible) {
						out.append("<th data-visisble='true' data-selectable='false'>" + iterable_element.getDisplayName() + "</th>");
						if(iterable_element.is_selectable){
							//out.append("<th data-visisble='true' class='select-filter' data-selectable='true'>" + iterable_element.getDisplayName() + "</th>");
							
						} else {
							//out.append("<th data-visisble='true' data-selectable='false'>" + iterable_element.getDisplayName() + "</th>");
						}
					}
				} catch (Exception e) {
				}
			}
			out.append("</tr></tfoot>");
		}

		/*
		 * out.append("<tbody>"); for (HashMap<String, Object> hashMap : data) {
		 * out.append("<tr>"); for (IStarColumn iterable_element :
		 * report.getColumns()) { if(iterable_element.isVisible){
		 * out.append("<td>"+hashMap.get(iterable_element.getName())+"</td>"); }
		 * }
		 * 
		 * out.append("</tr>"); } out.append("</tbody>");
		 */
		out.append("</table>");

		return out;
	}

	private StringBuffer getGraphHTML(String sql1, Report report) {

		if (report.getType_of_report().equalsIgnoreCase("AREA")) {
			return giveAreaDataTable(sql1, report);
		} else if (report.getType_of_report().equalsIgnoreCase("PIE")) {
			return givePieChartData(sql1, report);
		} else {
			return giveSimpleDataDatble(sql1, report);
		}

	}

	private StringBuffer givePieChartData(String sql1, Report report) {

		// TODO Auto-generated method stub
		StringBuffer out = new StringBuffer();
		out.append("<div class='graph_holder' id='graph_container_" + report.getId() + "' ></div> ");
		out.append(
				"<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"
						+ report.getId() + "' data-y_axis_title='" + report.getyAxisTitle() + "' data-report_title='"
						+ report.getTitle() + "' " + " data-graph_holder='container" + report.getId()
						+ "' id='chart_datatable_" + report.getId() + "'");
		out.append(" data-graph_type='" + report.getType_of_report() + "'> ");

		out.append("<thead><tr>");
		DBUTILS db = new DBUTILS();
		out.append("<th></th><th>Percentage</th>");
		List<HashMap<String, Object>> progress_views = db.executeQuery(sql1);

		out.append("</tr></thead>");
		out.append("<tbody>");
		for (HashMap<String, Object> progress_view : progress_views) {

		}
		if (progress_views.size() > 0) {
			HashMap<String, Object> progress_view = progress_views.get(0);
			for (String key : progress_view.keySet()) {
				out.append("<tr>");
				out.append("<td>" + key.toUpperCase() + "</td><td>" + progress_view.get(key) + "</td>");
				out.append("</tr>");
			}
		}
		out.append("</tbody></table>");

		return out;

	}

	private StringBuffer giveSimpleDataDatble(String sql1, Report report) {
		StringBuffer out = new StringBuffer();
		out.append("<div class='graph_holder' id='graph_container_" + report.getId() + "' ></div> ");
		out.append(
				"<table   class='data_holder datatable_report' data-graph_containter='graph_container_"
						+ report.getId() + "' data-y_axis_title='" + report.getyAxisTitle() + "' data-report_title='"
						+ report.getTitle() + "' " + " data-graph_holder='container" + report.getId()
						+ "' id='chart_datatable_" + report.getId() + "'");
		out.append(" data-graph_type='" + report.getType_of_report() + "'> ");

		out.append("<thead><tr>");
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql1);

		for (IStarColumn iterable_element : report.getColumns()) {
			try {
				out.append("<th>" + iterable_element.getDisplayName().toUpperCase() + "</th>");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
			}
		}

		out.append("</tr></thead> ");
		out.append("<tbody>");
		int i = 0;
		if (data.size() > 0) {
			for (HashMap<String, Object> hashMap : data) {
				out.append("<tr>");
				for (IStarColumn iterable_element : report.getColumns()) {
					if (iterable_element.isIs_header()) {
						out.append("<th>" + hashMap.get(iterable_element.getName()) + "</th>");
					} else {
						out.append("<td>" + hashMap.get(iterable_element.getName()) + "</td>");
					}
				}

				out.append("</tr>");
			}

		}
		out.append("</tbody> </table>");

		return out;

	}

	private StringBuffer giveAreaDataTable(String sql1, Report report) {
		// TODO Auto-generated method stub
		StringBuffer out = new StringBuffer();
		out.append("<div class='graph_holder' id='graph_container_" + report.getId() + "' ></div> ");
		out.append(
				"<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"
						+ report.getId() + "' data-y_axis_title='" + report.getyAxisTitle() + "' data-report_title='"
						+ report.getTitle() + "' " + " data-graph_holder='container" + report.getId()
						+ "' id='chart_datatable_" + report.getId() + "'");
		out.append(" data-graph_type='" + report.getType_of_report() + "'> ");

		out.append("<thead><tr>");
		DBUTILS db = new DBUTILS();

		ArrayList<String> colNames = new ArrayList<>();
		HashMap<String, String> defaultValue = new HashMap<>();
		List<HashMap<String, Object>> progress_views = db.executeQuery(sql1);
		for (HashMap<String, Object> rows : progress_views) {
			if (!colNames.contains(rows.get("col_name"))) {
				colNames.add(rows.get("col_name").toString());
				defaultValue.put(rows.get("col_name").toString(), "0");
			}
		}

		out.append("<th></th>");
		for (int i = 0; i < colNames.size(); i++) {
			out.append("<th>" + colNames.get(i) + "</th>");
		}

		out.append("</tr></thead>");
		out.append("<tbody>");
		for (HashMap<String, Object> progress_view : progress_views) {
			String colName = progress_view.get("col_name").toString();
			out.append("<tr>");
			out.append("<td>" + progress_view.get("row_key").toString() + "</td>");
			for (int i = 0; i < colNames.size(); i++) {
				if (colName.equalsIgnoreCase(colNames.get(i))) {
					defaultValue.put(colNames.get(i), progress_view.get("col_value").toString());
					out.append("<td>" + progress_view.get("col_value").toString() + "</td>");
				} else {
					// int updatedScore =
					// bgCumScore.get(batchGroupNames.get(i))+2;
					// bgCumScore.put(batchGroupNames.get(i), updatedScore);
					out.append("<td>" + defaultValue.get(colNames.get(i)) + "</td>");
				}

			}
			out.append("</tr>");

		}
		out.append("</tbody></table>");

		return out;

	}

	public Report getReport(int reportID) {
		ReportCollection reportCollection = new ReportCollection();
		Report report = new Report();
		try {
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(ReportCollection.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (ReportCollection) jaxbUnmarshaller.unmarshal(file);

		} catch (URISyntaxException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}

		for (Report r : reportCollection.getReports()) {
			if (r.getId() == reportID) {
				report = r;
			}
		}
		return report;
	}

	public StringBuffer getTableFilters(int reportId, HashMap<String, String> conditions) {
		StringBuffer sb = new StringBuffer();
		Report report = getReport(reportId);
		
		String sql1 = report.getSql();
		for (String key : conditions.keySet()) {
			//ViksitLogger.logMSG(this.getClass().getName(),"key->" + key + "   value-> " + conditions.get(key));
			String paramName = ":" + key;
			if (sql1.contains(paramName)) {

				sql1 = sql1.replaceAll(paramName, conditions.get(key));
			}
		}
		
		sb.append("<div class='row'>");
		
		int columnCount =0;
		for (IStarColumn iterable_element : report.getColumns()) {
			try {
				if (iterable_element.isVisible && iterable_element.is_selectable && iterable_element.dataType!=null) {
					
					switch (iterable_element.dataType)
					{
						case IstarColumnTypes.DATE:
							sb.append(getDateFiler(report, sql1, iterable_element, columnCount));
							break;
						case IstarColumnTypes.STRING:
							sb.append(getStringDropdown(report, sql1, iterable_element, columnCount));
							break;
						case IstarColumnTypes.INTEGER:
							sb.append(getIntegerSelector(report, sql1, iterable_element, columnCount));
							break;
					}
				}
			} catch (Exception e) {
			}
			columnCount++;
		}
		
		sb.append("</div>");
		
		return sb;		
	}

	private StringBuffer getIntegerSelector(Report report, String sql1, IStarColumn iterable_element, int colCount) {
		StringBuffer sb = new StringBuffer();
		DBUTILS util = new DBUTILS();
		String filterSql = "select cast (COALESCE(min("+iterable_element.name+"), 0) as integer) as  min,cast (COALESCE(max("+iterable_element.name+"), 0) as integer) as  max  from ("+sql1+")FILTER_TABLE ";
		List<HashMap<String, Object>> options = util.executeQuery(filterSql);
		int min =0;
		int max =0;
		if(options.size()>0)
		{
			if(options.get(0).get("min")!=null){
			min = (int)options.get(0).get("min");
			}
			if(options.get(0).get("max")!=null){
				max = (int)options.get(0).get("max");
				}
		}
		sb.append("<div class=col-sm-3>");
				sb.append("<div class=m-b-sm>");
						sb.append("<h4>Select "+iterable_element.displayName+"</h4>");
								sb.append("</div>");                           
										sb.append("<div class='int_filter' id=int_filter_"+iterable_element.name+" data-min='"+min+"' data-max='"+max+"' data-filter_name='"+iterable_element.name+"' data-column_number='"+colCount+"'></div>");
												sb.append("</div>");
	return sb;
	}

	private StringBuffer getStringDropdown(Report report, String sql1, IStarColumn iterable_element, int colCount) {
		DBUTILS util = new DBUTILS();
		String filterSql = "select distinct "+iterable_element.name+" from ("+sql1+")FILTER_TABLE order by "+iterable_element.name;
		List<HashMap<String, Object>> options = util.executeQuery(filterSql);
		
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='col-sm-3 m-b-xs'>");
				sb.append(" <h4>Select "+iterable_element.displayName+"</h4>");
						sb.append(" <select class='data_table_filter' id='string_filter_"+iterable_element.name+"' data-filter_name='"+iterable_element.name+"' data-column_number='"+colCount+"'>");
						
						if(options.size()>0)
						{
							sb.append("<option value=''>Select "+iterable_element.displayName+" </option>");
							for(HashMap<String, Object>  row: options)
							{
								sb.append("<option value="+row.get(iterable_element.name)+">"+row.get(iterable_element.name)+"</option>");
							}							
						}
						else
						{
							sb.append("<option value='null'>No Filter Available</option");
						}	
								
														sb.append(" </select>");
																sb.append("</div>");
		return sb;
	}

	private StringBuffer getDateFiler(Report report, String sql1, IStarColumn iterable_element, int colCount) {	
		StringBuffer sb = new StringBuffer();
		DBUTILS util = new DBUTILS();
		String filterSql = "select to_char(MIN (to_timestamp("+iterable_element.name+", 'DD-Mon-yyyy HH24:MI') ),'DD-Mon-yyyy HH24:MI') AS min_date, 	to_char(MAX (to_timestamp("+iterable_element.name+", 'DD-Mon-yyyy HH24:MI') ),'DD-Mon-yyyy HH24:MI') AS max_date from ("+sql1+")FILTER_TABLE";
	
		List<HashMap<String, Object>> minMaxDates = util.executeQuery(filterSql);
		String minDate = "01/01/2015";
		String maxDate = "12/31/2030";
		SimpleDateFormat from = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
		SimpleDateFormat to = new SimpleDateFormat("MMMMM dd, yyyy");
		
		if(minMaxDates.size()> 0)
		{
			if(minMaxDates.get(0).get("min_date")!=null)
			{
				String mtemp = minMaxDates.get(0).get("min_date").toString();
				try {
					minDate = to.format(from.parse(mtemp));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(minMaxDates.get(0).get("max_date")!=null)
			{
				
				String mtemp = minMaxDates.get(0).get("max_date").toString();
				try {
					maxDate = to.format(from.parse(mtemp));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		sb.append("<div class='col-sm-3 m-b-xs'><h4>Select Date </h4>");
				sb.append("<div id='reportrange_"+iterable_element.name+"' class='form-control date_range_filter ' data-filter_name='"+iterable_element.name+"' data-column_number='"+colCount+"' data-min_date='"+minDate+"' data-max_date='"+maxDate+"'>");
						sb.append("   <i class='fa fa-calendar'></i>");
								sb.append(" <span></span> <b class='caret'></b>");
										sb.append(" </div>");
												sb.append("  </div>");
		return sb;
	}
}
