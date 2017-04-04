/**
 * 
 */
package in.talentify.core.utils;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.IStarColumn;
import in.orgadmin.utils.report.Report;
import in.orgadmin.utils.report.ReportCollection;

/**
 * @author Vaibhav
 *
 */
public class ReportUtils {

	public StringBuffer getHTML(int reportID, HashMap<String, String> conditions) {
		StringBuffer out = new StringBuffer();
		Report report = getReport(reportID);
		System.err.println(report.getSql());
		out.append("<div class='graph_holder' id='container" + reportID + "' ></div> ");
		out.append("<table class='data_holder' data-report_title='"+report.getTitle()+"' "
				+ " data-graph_holder='container" + reportID + "' id='datatable" + reportID
				+ "' ");
		out.append(" data-graph_type='" + report.getType_of_report() + "'> ");
		out.append("<thead><tr>");
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(report.getSql());
		
		List<HashMap<String, Object>> pivotedData = new ArrayList<>();
		if(report.getIsPivot())
		{
			
			for(String str: data.get(0).keySet())
			{
				System.out.println("keyset >>>"+str);
				HashMap<String, Object> pivotedRow = new HashMap<>();
				for(int i =0; i<data.size(); i++)
				{
					pivotedRow.put(data.get(i).get(str).toString(),str );
				
					pivotedData.add(pivotedRow);
				}
				
					
			}
			
			out.append("<th>"+report.getGroupByCol().toString()+"</th>");
			for(int i =0; i<data.size(); i++)
			{
				out.append("<th>"+data.get(i).get(report.getPrimaryColumn()).toString()+"</th>");
			}
			
			
			
		}
		else
		{
			for (IStarColumn iterable_element : report.getColumns()) {
				try {
					out.append("<th>"+iterable_element.getDisplayName()+"</th>");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					//e.printStackTrace();
				}
			}
		}	
				
		
		
		out.append("</tr></thead> ");
		out.append("<tbody>");
		
		
		if(report.getIsPivot())
		{
			
			int i=0;
			for (HashMap<String, Object> hashMap : pivotedData) {
				out.append("<tr>");
				
				for(String str : hashMap.keySet())
				{
					if(hashMap.get(str).toString().equalsIgnoreCase(report.getGroupByCol()))
					{
						out.append("<td>"+str+"</td>");	
						break;
					}
				}
				
				for(String str : hashMap.keySet())
				{
					if(hashMap.get(str).toString().equalsIgnoreCase("avg_score"))
					{
						//out.append("<td>"+str+"</td>");
						//out.append("<td>"+str+"</td>");
					}
				}
				
				
				out.append("</tr>");
			}
			
		}
		else
		{
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
		}	
		
		out.append("</tbody> </table>");
		
		System.out.println(out.toString());
		
		return out;

	}

	public Report getReport(int reportID) {
		ReportCollection reportCollection = new ReportCollection();
		Report report = new Report();
		try {
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("/report_list.xml");
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