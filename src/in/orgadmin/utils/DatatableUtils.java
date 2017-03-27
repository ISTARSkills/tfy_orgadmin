/**

 * 
 */
package in.orgadmin.utils;

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

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;

import in.orgadmin.utils.report.IStarColumn;
import in.orgadmin.utils.report.Report;
import in.orgadmin.utils.report.ReportCollection;
import in.orgadmin.utils.report.ReportColumnHandlerFactory;

/**
 * @author Mayank
 *
 */
public class DatatableUtils {

	public Report getReportFromXML(int reportID) {
		ReportCollection reportCollection = new ReportCollection();
		Report report = new Report();
		try {
			URL url = (new OrgAdminRegistry()).getClass().getClassLoader().getResource("/report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(ReportCollection.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (ReportCollection) jaxbUnmarshaller.unmarshal(file);
		} catch (URISyntaxException e1) {
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

	public String dataTableConstructor(int report_id, String... params) {
		Report report = getReportFromXML(report_id);

		StringBuffer dtConstructor = new StringBuffer();
		StringBuffer keyValuePairs = new StringBuffer();
		for (String param : params) {
			keyValuePairs.append("&" + param);
		}

		dtConstructor.append("$('#datatable_report_" + report_id + "').DataTable({\n");

		dtConstructor.append("ajax:   '/data?report_id=" + report_id + keyValuePairs + "',\n");
		dtConstructor.append("responsive: true, 	\n");
		dtConstructor.append("stateSave: true,  	\n");
		dtConstructor.append("\"pageLength\": 10, \n");
		dtConstructor.append("\"oLanguage\": { \"sSearch\": '<i class=\"fa fa-search\"></i>' }, \n");
		dtConstructor.append("dom: 'Bfrtip',\n");

		dtConstructor.append("buttons: [ \n");
		dtConstructor.append("'copy', 'csv', 'excel', 'pdf', 'print', 	\n");
		dtConstructor.append("{ extend: \"create\", editor: editor }, 	\n");
		dtConstructor.append("{ extend: \"edit\",   editor: editor }\n");
		dtConstructor.append("], \n");

		dtConstructor.append("select: { \n");
		dtConstructor.append("style:    'os', 	\n");
		dtConstructor.append("selector: 'td:first-child'\n");
		dtConstructor.append("}, \n");

		dtConstructor.append("columns:[ \n");
		dtConstructor.append("	{	\n");
		dtConstructor.append("	data: null,\n");
		dtConstructor.append("	defaultContent: ' ',\n");
		dtConstructor.append("	className: 'select-checkbox',\n");
		dtConstructor.append("	orderable: false 	\n");
		dtConstructor.append("	},	\n");

		int ite = 1;
		int iteMax = report.getColumns().size();
		for (IStarColumn column : report.getColumns()) {
			if (column.getIsVisible()) {
				dtConstructor.append("{  	\n");
				if (!column.getEdit_type().equalsIgnoreCase("READ_ONLY")) {
					dtConstructor.append("data: \"" + column.getName() + "\", className: 'editable'	\n");
				} else {
					dtConstructor.append("data: \"" + column.getName() + "\"	\n");
				}
				dtConstructor.append("}	\n");

				if (ite < iteMax) {
					dtConstructor.append(",	\n");
				}
			}
			ite++;
		}

		dtConstructor.append("],\n");
		dtConstructor.append("});	\n");

		return dtConstructor.toString();
	}

	public String dataTableEditorConstructor(int report_id, String... params) {
		Report report = getReportFromXML(report_id);

		StringBuffer dtConstructor = new StringBuffer();
		StringBuffer keyValuePairs = new StringBuffer();
		for (String param : params) {
			keyValuePairs.append("&" + param);
		}

		dtConstructor.append("var editor; 	\n");
		dtConstructor.append("editor = new $.fn.dataTable.Editor( {	\n");

		dtConstructor.append("ajax:   '/edit_data?report_id=" + report_id + keyValuePairs + "',	\n");
		dtConstructor.append("idSrc:  'id',\n");
		dtConstructor.append("table: '#datatable_report_" + report_id + "'	,\n");
		dtConstructor.append("fields: [  	\n");

		int ite = 1;
		int iteMax = report.getColumns().size();
		for (IStarColumn column : report.getColumns()) {
			if (!column.getEdit_type().equalsIgnoreCase("READ_ONLY")) {
			dtConstructor.append("\n " + getColumnHanderEdit(column) + "");

			if (ite++ < iteMax) {
				dtConstructor.append(",");
			}
			}
		}

		dtConstructor.append("]	\n");
		dtConstructor.append("});\n");

		//dtConstructor.append("$('#datatable_report_" + report_id
		//		+ "').on( 'click', 'tbody td:not(:first-child)', function (e) {	\n");
		///dtConstructor.append(" editor.inline( this );\n");
		//dtConstructor.append("});\n");

		dtConstructor.append(dataTableConstructor(report_id, params));
		String ret = dtConstructor.toString().replace(",,", ",");

		return ret;
	}

	public ArrayList<ArrayList<String>> getReportData(String sql1, ArrayList<IStarColumn> keys,
			HashMap<String, String> conditions) {
		System.err.println("report for query ->" + " -- " + sql1);
		ArrayList<ArrayList<String>> table = new ArrayList<>();
		Session session = new IstarUserDAO().getSession();
		List<HashMap<String, Object>> results;
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(sql1);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);

			for (String key : conditions.keySet()) {
				// System.err.println("key -> " + key + " ; value -> " +
				// conditions.get(key)) ;
				try {
					if (sql1.contains(key)) {
						query.setParameter(key, Integer.parseInt(conditions.get(key)));
					}
				} catch (Exception e) {
					// e.printStackTrace();
					query.setParameter(key, conditions.get(key));
				}
			}

			DBUTILS util = new DBUTILS();
			// results = query.list();
			results = util.executeFromQueryObject(query);
			for (HashMap<String, Object> object : results) {
				ArrayList<String> row = new ArrayList<>();
				for (IStarColumn string : keys) {
					row.add(object.get(string.getName()) + "");
				}
				table.add(row);
			}
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

		return table;
	}

	public List<HashMap<String, Object>> updateData(int reportID, HashMap<String, String> conditions) {
		Report report = getReportFromXML(reportID);
		boolean isValidSql = false;

		String sql = "update " + report.getTableName() + " set ";
		for (String key : conditions.keySet()) {
			// System.err.println("key -> " + key + " ; value -> " +
			// conditions.get(key) );
			if (!(key.equalsIgnoreCase("id") || key.equalsIgnoreCase("email"))) {
				try {
					sql = sql + key + " = '" + conditions.get(key) + "' ,";
					isValidSql = true;
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		sql = sql + " where id = " + conditions.get("id");
		sql = sql.replace(" , where", "  where");

		DBUTILS util = new DBUTILS();
		if (isValidSql) {
			System.out.println("update query  --------> " + sql);
			util.executeUpdate(sql);
		}
       if(reportID == 197){
		sql = "SELECT 	batch_group. ID, 	batch_group. NAME, 	( SELECT COUNT (*) 	FROM 	batch_students 	WHERE 	batch_group_id = batch_group. ID 	) AS stu_count, 	( SELECT COUNT (*) 	FROM 	batch 	WHERE 	batch.batch_group_id = batch_group. ID 	) AS batch_count, ('&lt;a href=''/orgadmin/batch_group/dashboard.jsp?batch_group_id='||batch_group. ID||''' class=''btn btn-primary btn-xs''&gt;&lt;i class=''fa fa-folder''&gt;&lt;/i&gt; View &lt;/a&gt;') as status FROM " + report.getTableName() + " where id = " + conditions.get("id");
        }else
        {
        	sql = "select * from " + report.getTableName() + " where id = " + conditions.get("id");
        }
		System.out.println("update query new  --------> " + sql);
		List<HashMap<String, Object>> result = util.executeQuery(sql);
		return result;
	}

	public List<HashMap<String, Object>> createNewRecord(int reportID, HashMap<String, String> conditions) {
		Report report = getReportFromXML(reportID);
		boolean isValidSql = false;

		String sql = "insert into " + report.getTableName();
		StringBuffer keyString = new StringBuffer();
		StringBuffer valueString = new StringBuffer();

		keyString.append(" ( ID, ");
		valueString.append(" values ( (SELECT MAX(ID) + 1 FROM " + report.getTableName() + "), ");

		int ite = 1;
		for (String key : conditions.keySet()) {
			System.err.println("key -> " + key + " ; value -> " + conditions.get(key));
			ite++;
			if (!key.equalsIgnoreCase("id")) {
				try {
					keyString.append(" " + key + " ");
					valueString.append(" '" + conditions.get(key) + "' ");
					isValidSql = true;

					if (ite <= conditions.size()) {
						keyString.append(" , ");
						valueString.append(" , ");
					} else {
						keyString.append(" ) ");
						valueString.append(" ) ");
					}

				} catch (Exception e) {
					// e.printStackTrace();
				}
			}
		}

		sql = sql + keyString.toString() + valueString.toString() + " RETURNING id";

		DBUTILS util = new DBUTILS();
		int id = 0;
		if (isValidSql) {
			System.out.println("insert query ----------> " + sql);
			id = util.executeUpdateReturn(sql);
		}
		if(reportID == 197){
			sql = "SELECT 	batch_group. ID, 	batch_group. NAME, 	( SELECT COUNT (*) 	FROM 	batch_students 	WHERE 	batch_group_id = batch_group. ID 	) AS stu_count, 	( SELECT COUNT (*) 	FROM 	batch 	WHERE 	batch.batch_group_id = batch_group. ID 	) AS batch_count, ('&lt;a href=''/orgadmin/batch_group/dashboard.jsp?batch_group_id='||batch_group. ID||''' class=''btn btn-primary btn-xs''&gt;&lt;i class=''fa fa-folder''&gt;&lt;/i&gt; View &lt;/a&gt;') as status FROM " + report.getTableName() +  " where id = " + id;
	        }else
	        {
	        	sql = "select * from " + report.getTableName() + " where id = " + id;
	        }
			System.out.println("update query new  --------> " + sql);
		
		List<HashMap<String, Object>> result = util.executeQuery(sql);
		return result;
	}

	public StringBuffer getReport(int reportID, HashMap<String, String> conditions, IstarUser user, String taskType) {
		Report report = getReportFromXML(reportID);

		StringBuffer out = new StringBuffer();
		ArrayList<ArrayList<String>> data = new ArrayList<>();
		try {
			data = getReportData(report.getSql(), report.getColumns(), conditions);
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Report type is:" + report.getType_of_report());

		/* start here */
		if (report.getType_of_report().equalsIgnoreCase("table")) {
			out.append("<div class='table-responsive'>                                                      "
					+ "<table id='datatable_report_" + report.getId() + "' data-graph_title='" + report.getTitle()
					+ "' " + "data-graph_containter='report_container_" + report.getId() + "' data-graph_type='"
					+ report.getType_of_report() + "' "
					+ "class=' datatable_report table table-striped table-bordered table-hover dataTables-example' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px;'>     ");

		} else if (report.getType_of_report().equalsIgnoreCase("edit_table")) {
			out.append("<div class='table-responsive'>                                                      "
					+ "<table id='datatable_report_" + report.getId() + "' data-graph_title='" + report.getTitle()
					+ "' " + "data-graph_containter='report_container_" + report.getId() + "' data-graph_type='"
					+ report.getType_of_report() + "' "
					+ "class=' datatable_report table table-striped table-bordered table-hover dataTables-example'  >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px;'>     ");
			out.append("<th>#</th> ");
		} else {
			out.append("<div class='table-responsive'>                                                      "
					+ "<table id='datatable_report_" + report.getId() + "' data-graph_title='" + report.getTitle()
					+ "' " + "data-graph_containter='report_container_" + report.getId() + "' data-graph_type='"
					+ report.getType_of_report() + "'  data-dateselector='"+report.getDateselector()+"'"
					+ "class=' datatable_report table table-striped table-bordered table-hover dataTables-example' style='display:none' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px;'>     ");
		}

		for (IStarColumn column : report.getColumns()) {
			if (column.getIsVisible()) {
				out.append("    <th>" + column.getDisplayName() + "</th>                  ");
			}
		}
		out.append("</tr>                                                                               "
				+ "</thead>                                                                             ");

		if (report.getType_of_report().contains("table") ) {
			out.append("<tfoot><tr style='font-size: 11px;'>");
			for (IStarColumn column : report.getColumns()) {
				if (column.getIsVisible()) {
					out.append( " <th>"+column.getDisplayName()+"</th> ");
				}
			}
			out.append("</tr></tfoot>");
		}
		
		out.append("<tbody >");
		String ROWID = "0";

		for (ArrayList<String> row : data) {
			out.append("<tr style='font-size: 11px;' >");
			int i = 0;
			for (IStarColumn column : report.getColumns()) {
				try {
					if (column.getName().equalsIgnoreCase("id")) {
						ROWID = row.get(i);
					}
					if (column.getIsVisible()) {
						if (column.getColumnHandler().equalsIgnoreCase("NONE")) {
							try {
								out.append("<td>" + Integer.parseInt(row.get(i)) + "</td>");
							} catch (Exception e) {
								out.append("<td>" + row.get(i) + "</td>");
							}
						} else {
							out.append(
									"<td india style='max-width:100px !important; word-wrap: break-word;'>"
											+ ReportColumnHandlerFactory.getInstance()
													.getHandler(column.getColumnHandler()).getHTML(row.get(i), user,
															taskType, Integer.parseInt(ROWID), reportID, taskType)
											+ "</td>");
						}
						i++;
					}

				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			ROWID = "" + i;
			out.append("</tr>");
		}

		out.append("</tbody>");
		out.append("</table>    </div>  ");
		out.append("<div id='report_container_" + reportID + "'></div>");

		return out;

	}

	public StringBuffer getReportTableWithoutBody(int reportID, HashMap<String, String> conditions, IstarUser user,
			String taskType) {
		Report report = getReportFromXML(reportID);

		StringBuffer out = new StringBuffer();

		/* start here */
		if (report.getType_of_report().equalsIgnoreCase("table")) {
			out.append("<div class='table-responsive'>                                                      "
					+ "<table id='datatable_report_" + report.getId() + "' data-graph_title='" + report.getTitle()
					+ "' " + "data-graph_containter='report_container_" + report.getId() + "' data-graph_type='"
					+ report.getType_of_report() + "' "
					+ "class=' datatable_report table table-striped table-bordered table-hover dataTables-example' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px;'>     ");

		} else if (report.getType_of_report().equalsIgnoreCase("edit_table")) {

			out.append("<div class='table-responsive'>                                                      "
					+ "<table id='datatable_report_" + report.getId() + "' data-graph_title='" + report.getTitle()
					+ "' " + "data-graph_containter='report_container_" + report.getId() + "' data-graph_type='"
					+ report.getType_of_report() + "' "
					+ "class=' datatable_report table table-striped table-bordered table-hover dataTables-example' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px;'>     ");
			out.append("<th>#</th> ");
		} else {
			out.append("<div class='table-responsive'>                                                      "
					+ "<table id='datatable_report_" + report.getId() + "' data-graph_title='" + report.getTitle()
					+ "' " + "data-graph_containter='report_container_" + report.getId() + "' data-graph_type='"
					+ report.getType_of_report() + "' "
					+ "class=' datatable_report table table-striped table-bordered table-hover dataTables-example' style='display:none' >  "
					+ "<thead>                                                                             "
					+ "<tr style='font-size: 11px;'>     ");
		}

		for (IStarColumn column : report.getColumns()) {
			if (column.getIsVisible()) {
				out.append("    <th>" + column.getDisplayName() + "</th>                  ");
			}
		}
		out.append("</tr>                                                                               "
				+ "</thead>                                                                             ");

		// out.append("<tfoot><tr style='font-size: 11px;'>");
		for (IStarColumn column : report.getColumns()) {
			if (column.getIsVisible()) {
				// out.append( " <th>"+column.getDisplayName()+"</th> ");
			}
		}

		out.append("</tr></tfoot>");
		out.append("</table>    </div>  ");
		out.append("<div id='report_container_" + reportID + "'></div>");

		/* end here */
		return out;

	}

	public StringBuffer getColumnHanderEdit(IStarColumn col) {
		StringBuffer sb = new StringBuffer();

		switch (col.getEdit_type()) {
		case "TEXT":
			sb.append(" {");
			sb.append(" 	label: \"" + col.getDisplayName() + ":\",");
			sb.append(" 	name: \"" + col.getName() + "\"");
			sb.append(" 	}");

			sb.append(" ");
			break;

		case "READ_ONLY":
			sb.append(" {");
			sb.append(" 	label: \"" + col.getDisplayName() + ":\",");
			sb.append(" 	name: \"" + col.getName() + "\" , ");
			sb.append(" type:  \"readonly\"");

			sb.append(" 	}");

			sb.append(" ");
			break;

		case "SELECT":
			sb.append(" {");
			sb.append(" 	label: \"" + col.getDisplayName() + ":\",");
			sb.append(" 	name: \"" + col.getName() + "\" , ");

			sb.append(" type:  \"radio\",");
			sb.append(" options: [");

			for (String sType : col.getSelect_options().split(",")) {
				sb.append("     { label: \"" + sType + "\", value: \"" + sType + "\" },");

			}

			sb.append(" ],");
			// sb.append(" def: "+col.getSelect_options().split(",")[0]);

			sb.append(" 	}");

			sb.append(" ");
			break;

		default:
			break;
		}

		return sb;
	}
	
	

}
