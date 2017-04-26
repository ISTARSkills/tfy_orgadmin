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
		StringBuffer out = new StringBuffer();
		Report report = getReport(reportID);
		System.err.println(report.getSql());
		String sql1=report.getSql();
		out.append("<div class='graph_holder' id='graph_container_"+reportID+"' ></div> ");
		out.append("<table class='data_holder datatable_report' data-graph_containter='graph_container_"+reportID+"' data-y_axis_title='"+report.getyAxisTitle()+"' data-report_title='"+report.getTitle()+"' "
				+ " data-graph_holder='container" + reportID + "' id='chart_datatable_"+reportID+"'");
		out.append(" data-graph_type='" + report.getType_of_report() + "'> ");
		out.append("<thead><tr>");
		
		for (String key : conditions.keySet()) {
			
				String paramName=":"+key;
				
				if (sql1.contains(paramName)) {
					System.out.println("key->" + key + "   value-> " + conditions.get(key));
					
					sql1 =sql1.replaceAll(paramName, conditions.get(key));

				}
			
		}
		
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql1);
		
			for (IStarColumn iterable_element : report.getColumns()) {
				try {
					out.append("<th>"+iterable_element.getDisplayName()+"</th>");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					//e.printStackTrace();
				}
			}
		
		out.append("</tr></thead> ");
		out.append("<tbody>");	
			int i=0;
			for (HashMap<String, Object> hashMap : data) {
				out.append("<tr>");
				for (IStarColumn iterable_element : report.getColumns()) {
					if(iterable_element.isIs_header()){
						out.append("<th>"+hashMap.get(iterable_element.getName())+"</th>");
					} else {
						out.append("<td>"+hashMap.get(iterable_element.getName())+"</td>");	
					}
				}
				
				
				
				
				out.append("</tr>");
			}
			
		
		out.append("</tbody> </table>");
		
		System.out.println(out.toString());
		
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