/**
 * 
 */
package in.orgadmin.utils.report;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.HashMap;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.utils.CMSRegistry;

/**
 * @author mayank
 *
 */
public class FilterUtils {

	public StringBuffer getHTML(int filterID, HashMap<String, String> conditions) {
	StringBuffer out = new StringBuffer();
	DataFilter filter = getReport(filterID);
	//System.err.println(filter.getSql());
	
	DBUTILS db = new DBUTILS();
	List<HashMap<String, Object>> data = db.executeQuery(filter.getSql());
	out.append("<label class='col-sm-3 control-label'>"+filter.getTitle()+"</label> 	"			
			+ "<div class='col-sm-4'> "
			+ "select class='form-control m-b graph_filter_selector'  data-report_id='"+filter.getRelatedReportListId()+"'"
			+ "id='graph_filter_"+filterID+"' data-college='<%=colegeID%>'> "
			+ "	<%=uiUtil.getCourses(colegeID)%> "
			+ "</select> "
			+ "</div>");
	
	
	/*out.append("<div class='graph_holder' id='program_view' ></div> ");
	out.append("<table class='data_holder datatable_report' data-graph_containter='program_view' data-report_title='"+report.getTitle()+"' "
			+ " data-graph_holder='container" + reportID + "' id='program_view_datatable'");
	out.append(" data-graph_type='" + report.getType_of_report() + "'> ");
	out.append("<thead><tr>");
	
	
	
	
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
		
	
	out.append("</tbody> </table>");*/
	
	//System.out.println(out.toString());
	
	return out;

}

public DataFilter getReport(int reportID) {
	FilterCollection reportCollection = new FilterCollection();
	DataFilter report = new DataFilter();
	try {
		URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("filter_list.xml");
		File file = new File(url.toURI());
		JAXBContext jaxbContext = JAXBContext.newInstance(FilterCollection.class);
		Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
		reportCollection = (FilterCollection) jaxbUnmarshaller.unmarshal(file);

	} catch (URISyntaxException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
	} catch (JAXBException e) {
		e.printStackTrace();
	}
	
	for (DataFilter r : reportCollection.dataFilters) {
		if (r.getId() == reportID) {
			report = r;
		}
	}
	return report;
}
}

