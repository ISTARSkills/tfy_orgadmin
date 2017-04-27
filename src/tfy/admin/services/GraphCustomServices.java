/**
 * 
 */
package tfy.admin.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * @author mayank
 *
 */
public class GraphCustomServices {

	public StringBuffer getProgressGraph(int collegeId)
	{
		DBUTILS dbutils = new DBUTILS();
		StringBuffer out = new StringBuffer();
		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_"+id+"' ></div> ");
		out.append("<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"+id+"' data-y_axis_title='Average Adjusted Score' data-report_title='Average Performance of Section Over Time' "
				+ " data-graph_holder='container" + id + "' id='chart_datatable_"+id+"'");
		out.append(" data-graph_type='line'>");
		
		
		out.append(""
				+ "<thead><tr><th></th>");

	

		String sql9 = "select id, bg_progress.batch_group_id, cast (''||to_char(created_at, 'YYYY-MM-DD HH:MM:SS')||'' as TIMESTAMP) as created_at, batch_group_name, cast (avg_score as integer) as avg_score from bg_progress where college_id ="
				+ collegeId + " ORDER BY created_at ";
		
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
