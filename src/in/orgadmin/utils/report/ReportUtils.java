/**
 * 
 */
package in.orgadmin.utils.report;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;

import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.IStarColumn;
import in.orgadmin.utils.report.Report;
import in.orgadmin.utils.report.ReportCollection;
import in.talentify.core.utils.CMSRegistry;

/**
 * @author Vaibhav
 *
 */
public class ReportUtils {

	public StringBuffer getHTML(int reportID, HashMap<String, String> conditions) {
		Report report = getReport(reportID);
		System.err.println(report.getSql());
		String sql1 = report.getSql();
		for (String key : conditions.keySet()) {
			System.out.println("key->" + key + "   value-> " + conditions.get(key));
			String paramName = ":" + key;
			if (sql1.contains(paramName)) {

				sql1 = sql1.replaceAll(paramName, conditions.get(key));
			}
		}
		System.out.println("report type>>" + report.getType_of_report());
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

		for (IStarColumn iterable_element : report.getColumns()) {
			try {
				if (iterable_element.isVisible) {
					out.append("<th data-visisble='true'>" + iterable_element.getDisplayName() + "</th>");
				}
			} catch (Exception e) {
			}
		}
		out.append("</tr></thead>");

		if (conditions.containsKey("static_table")) {

			DBUTILS db = new DBUTILS();
			String sql1 = report.getSql();
			for (String key : conditions.keySet()) {
				String paramName = ":" + key;
				if (sql1.contains(paramName)) {
					System.out.println("key->" + key + "   value-> " + conditions.get(key));
					sql1 = sql1.replaceAll(paramName, conditions.get(key));
				}
			}
			List<HashMap<String, Object>> data = db.executeQuery(sql1);
			out.append("<tbody>");
			for (HashMap<String, Object> hashMap : data) {
				out.append("<tr>");
				for (IStarColumn iterable_element : report.getColumns()) {
					if (iterable_element.isVisible) {
						out.append("<td>" + hashMap.get(iterable_element.getName()) + "</td>");
					}
				}

				out.append("</tr>");
			}
			out.append("</tbody>");
			
			out.append("<tfoot> <tr>");

			for (IStarColumn iterable_element : report.getColumns()) {
				try {
					if (iterable_element.isVisible) {
						if(iterable_element.is_selectable){
							out.append("<th data-visisble='true' class='select-filter' data-selectable='true'>" + iterable_element.getDisplayName() + "</th>");
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
				"<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"
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

}