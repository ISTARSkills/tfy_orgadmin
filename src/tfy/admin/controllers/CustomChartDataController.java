package tfy.admin.controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.Report;
import in.orgadmin.utils.report.ReportUtils;

/**
 * Servlet implementation class CustomChartDataController
 */
@WebServlet("/cutsom_chart_data")
public class CustomChartDataController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CustomChartDataController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String trainerId = request.getParameter("trainer_id");
		String orgId = request.getParameter("org_id");
		String batchGroupId = request.getParameter("batch_group_id");
		String courseId = request.getParameter("course_id");
		String startDate = request.getParameter("start_date");//05/06/2014
		String endDate = request.getParameter("end_date");//05/06/2014
		String timeSql = "";
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat to = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if(startDate!=null && !startDate.equalsIgnoreCase("") && !startDate.equalsIgnoreCase("null"))
		{
			try {
				String startDateString = to.format(sdf.parse(startDate+" 00:00:01"));
				timeSql += " and eventdate >= cast ('"+startDateString+"' as timestamp)";
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		else
		{
			timeSql += "";
		}	
		if(endDate!=null && !endDate.equalsIgnoreCase("") && !endDate.equalsIgnoreCase("null"))
		{
			try {
				String endDateString = to.format(sdf.parse(endDate+" 23:59:59"));
				timeSql += " and eventdate <= cast ('"+endDateString+"' as timestamp)";
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
		}else
		{
			timeSql +=" and eventdate <=now()";
		}	
		
		/*+ "COALESCE (cast (max(seconds) as integer) ,0) as max_time,"
				+ " COALESCE (cast (min(seconds) as integer) ,0) as min_time,"
				+ " COALESCE (cast (avg(seconds) as integer) ,0) as avg_time,"
				+ " COALESCE (cast ((max(seconds)-avg(seconds)) as integer) ,) as deviation"*/
		String sql ="select  to_char( eventdate, 'DD-Mon-yyyy HH24:MI' ) as event_date, eventdate, "
				+"COALESCE ( 		round(cast(MAX(seconds)as numeric) ,2), 		0.001 	) AS max_time, 	COALESCE ( 		round(cast(MIN(seconds)as numeric) ,2), 		0.001 	) AS min_time, 	COALESCE ( 	round(cast(AVG(seconds)as numeric) ,2), 		0.001 	) AS avg_time, 	COALESCE ( 		round(cast((MAX(seconds) - AVG(seconds))as numeric) ,2), 		0.0001 	) AS deviation"
				+ " from ("
				+ "select id as event_id, eventdate,org_name,course_name,group_name,trainer_name, session_title,slide_id, next_cat, created_at, (DATE_PART('day', next_cat - created_at) * 24 +                 DATE_PART('hour', next_cat - created_at) * 60 +                 DATE_PART('minute', next_cat - created_at) * 60 +                 DATE_PART('second', next_cat - created_at) )  as seconds  "
				+ "from "
				+ "( select bse.id , bse.eventdate, organization.name org_name, course.course_name, bg.name as group_name, COALESCE(tu.first_name, trainer.email) as trainer_name, cmsession.title session_title, slide_change_log.slide_id, slide_change_log.created_at ,lag(slide_change_log.created_at) OVER w as previous_cat ,lead(slide_change_log.created_at) OVER w as next_cat from batch_schedule_event bse join batch_group bg on (bse.batch_group_id = bg.id and bse.type ='BATCH_SCHEDULE_EVENT_TRAINER' and bse.course_id="+courseId+" and bse.batch_group_id ="+batchGroupId+" and bse.actor_id ="+trainerId+" "+timeSql+") join course on (bse.course_id = course.id) join organization on (organization.id = bg.college_id) join istar_user trainer on (bse.actor_id = trainer.id) left join user_profile tu on (tu.user_id = trainer.id) left join slide_change_log on (slide_change_log.event_id = bse.id) left join cmsession on (cmsession.id = slide_change_log.cmsession_id) WINDOW w AS (PARTITION BY bse.eventdate, organization.name , course.course_name, bg.name, cmsession.title ,COALESCE(tu.first_name, trainer.email)  order by bse.eventdate, organization.name , course.course_name, bg.name, cmsession.title ,COALESCE(tu.first_name, trainer.email), slide_change_log.created_at) )tokcat )T2 group by  eventdate order by eventdate";
		
		System.out.println("slide summary sql >>>"+sql);
		
		StringBuffer out = new StringBuffer();
		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_"+id+"' ></div> ");
		out.append("<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"+id+"' data-y_axis_title='Time in seconds' data-report_title='Slide Analytics Summary For Trainer' "
				+ " data-graph_holder='container" + id + "' id='chart_datatable_"+id+"'");
		out.append(" data-graph_type='line'>");				
		out.append(""
				+ "<thead><tr><th></th>");
		
		out.append("<th>Max Time(in secs)</th>");
		out.append("<th>Min Time(in secs)</th>");
		out.append("<th>Avg Time(in secs)</th>");
		out.append("<th>Deviation Time(in secs)</th>");
		out.append("</tr></thead>");
		out.append("<tbody>");
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>>data = util.executeQuery(sql);
		if(data!=null && data.size()>0)
		{
				for(HashMap<String, Object> row : data)
				{
					out.append("<tr>");
					out.append("<td>"+row.get("eventdate").toString()+"</td>");
					out.append("<td>"+row.get("max_time")+"</td>");
					out.append("<td>"+row.get("min_time")+"</td>");
					out.append("<td>"+row.get("avg_time")+"</td>");
					out.append("<td>"+row.get("deviation")+"</td>");
					out.append("</tr>");					
				}
		}	
		out.append("</tbody></table>");
		response.getWriter().write(out.toString());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
