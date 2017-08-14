/**
 * 
 */
package tfy.admin.services;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportList;
import in.talentify.core.utils.CMSRegistry;

/**
 * @author mayank
 *
 */
public class GraphCustomServices {

	
	public CustomReport getReport(int reportID) {
		CustomReportList reportCollection = new CustomReportList();
		CustomReport report = new CustomReport();
		try {
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("custom_report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(CustomReportList.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (CustomReportList) jaxbUnmarshaller.unmarshal(file);

		} catch (URISyntaxException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		
		for (CustomReport r : reportCollection.getCustomReports()) {
			if (r.getId() == reportID) {
				report = r;
			}
		}
		return report;
	}
	
	public StringBuffer getCompetitionGraph(HashMap<String, String> conditions)
	{		DBUTILS dbutils = new DBUTILS();
		StringBuffer out = new StringBuffer();
		
		
		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_"+id+"' ></div> ");
		out.append("<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"+id+"' data-y_axis_title='Average Adjusted Score' data-report_title='Competetive Performance with Other Organizations' "
				+ " data-graph_holder='container" + id + "' id='chart_datatable_"+id+"'");
		out.append(" data-graph_type='bar'>");	
		int col_id = Integer.parseInt(conditions.get("college_id"));
		Organization org = new OrganizationDAO().findById(col_id);
		out.append("<thead><tr><th></th><th>"+org.getName()+"</th><th>Other Colleges</th></tr></thead>");
		out.append("<tbody>");
		
		CustomReport report2 = getReport(3);
		String sql2 = report2.getSql();
		for(String key : conditions.keySet())
		{
			sql2 = sql2.replaceAll(":"+key, conditions.get(key));
		} 
		String avgeScoreForCurrentCollege = sql2;
		List<HashMap<String, Object>> avgScoreData = dbutils.executeQuery(avgeScoreForCurrentCollege);
		CustomReport report4 = getReport(4);
		String sql4 = report4.getSql();
		for(String key : conditions.keySet())
		{
			sql4 = sql4.replaceAll(":"+key, conditions.get(key));
		} 
		
		
		
		String avgScoreForOtherCollege =sql4;
		List<HashMap<String, Object>> avgScoreDataForOtherCollege = dbutils.executeQuery(avgScoreForOtherCollege);			
		
		HashMap<Integer, Integer> currentCollegeCourseAvgScoreMap = new HashMap<>();
		HashMap<Integer, Integer> otherCollegeCourseAvgScoreMap = new HashMap<>();
		for(HashMap<String, Object> row: avgScoreData)
		{
			int course_id = (int) row.get("course_id");				
			int avg_score = (int) row.get("avg_score");
			int collId = (int)row.get("college_id");	
				
				currentCollegeCourseAvgScoreMap.put(course_id, avg_score);
			
		}
		
		for(HashMap<String, Object> row: avgScoreDataForOtherCollege)
		{
			int course_id = (int) row.get("course_id");				
			int avg_score = (int) row.get("avg_score");
			otherCollegeCourseAvgScoreMap.put(course_id, avg_score);	
		}
		
		
		CustomReport report1 = getReport(2);
		String sql9 = report1.getSql();
		for(String key : conditions.keySet())
		{
			sql9 = sql9.replaceAll(":"+key, conditions.get(key));
		}
		String coursesInCollege = sql9;
		List<HashMap<String, Object>> CoursesInCollege = dbutils.executeQuery(coursesInCollege);
		for(HashMap<String, Object> row: CoursesInCollege)
		{
			int course_id = (int)row.get("id");
			out.append("<tr>");
			out.append("<td>"+row.get("course_name")+"</td>");
			int currentCollegeScore = 0;
			if(currentCollegeCourseAvgScoreMap.containsKey(course_id))
			{
				currentCollegeScore = currentCollegeCourseAvgScoreMap.get(course_id);
			}				
			int otherCollegeScore = 0;
			if(otherCollegeCourseAvgScoreMap.containsKey(course_id))
			{
				otherCollegeScore = otherCollegeCourseAvgScoreMap.get(course_id);
			}
			out.append("<td>"+currentCollegeScore+"</td>");
			out.append("<td>"+otherCollegeScore+"</td>");								
			out.append("</tr>");				
		}
		
		out.append("</tbody></table>");
		
		
		
		return out;
	}
	
	public StringBuffer getProgressGraph(int reportID, HashMap<String, String> conditions)
	{
		DBUTILS dbutils = new DBUTILS();
		StringBuffer out = new StringBuffer();
		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_"+id+"' ></div> ");
		out.append("<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"+id+"' data-y_axis_title='Average Adjusted Points' data-report_title='Average Performance of Section Over Time' "
				+ " data-graph_holder='container" + id + "' id='chart_datatable_"+id+"'");
		out.append(" data-graph_type='line'>");				
		out.append(""
				+ "<thead><tr><th></th>");
		CustomReport report = getReport(reportID) ;
		String sql9 = report.getSql();
		for(String key : conditions.keySet())
		{
			sql9 = sql9.replaceAll(":"+key, conditions.get(key));
		}		
		
		ArrayList<String> batchGroupNames = new ArrayList<>();
		List<HashMap<String, Object>> progress_views = dbutils.executeQuery(sql9);
		HashMap<String, Integer> bgCumScore = new HashMap<>();
		for(HashMap<String, Object>  rows : progress_views)
		{
			if(!batchGroupNames.contains(rows.get("batch_group_name")))
			{
				batchGroupNames.add(rows.get("batch_group_name").toString());
				bgCumScore.put(rows.get("batch_group_name").toString(), 2);
			}
		}
		
		for(int i=0; i< batchGroupNames.size(); i++)
		{
			out.append("<th>"+batchGroupNames.get(i)+"</th>");
		}
		
		out.append("</tr></thead>");
		
		out.append("<tbody>");
		
		for (HashMap<String, Object> progress_view : progress_views) 
		{
			String bgName = progress_view.get("batch_group_name").toString();
			out.append("<tr>");
			out.append("<td>"+progress_view.get("created_at").toString()+"</td>");
			for(int i=0; i< batchGroupNames.size(); i++)
			{
				if(bgName.equalsIgnoreCase(batchGroupNames.get(i)))
				{
					int updatedScore=bgCumScore.get(bgName)+ ((int)progress_view.get("avg_score"));
					
					bgCumScore.put(bgName, updatedScore);
																				
					out.append("<td>"+bgCumScore.get(bgName)+"</td>");
				}
				else
				{
					//int updatedScore = bgCumScore.get(batchGroupNames.get(i))+2;
					//bgCumScore.put(batchGroupNames.get(i), updatedScore);
					out.append("<td>"+bgCumScore.get(batchGroupNames.get(i))+"</td>");
				}	
				
			}
			out.append("</tr>");
			
		}
		
		out.append("</tbody></table>");
		return out;
	}
		
	
}
