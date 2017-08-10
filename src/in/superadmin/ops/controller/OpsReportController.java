package in.superadmin.ops.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;



/**
 * Servlet implementation class OpsReportController
 */
@WebServlet("/get_ops_report")
public class OpsReportController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OpsReportController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		DBUTILS dbutils = new DBUTILS();
		
		
		if(request.getParameter("type")!=null&&request.getParameter("type").equalsIgnoreCase("org") &&request.getParameter("orgId")!=null){
		
			String sql="select DISTINCT b.id,b.name from batch b,batch_group bg where bg.id=b.batch_group_id and bg.college_id="+request.getParameter("orgId");
			
			List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
			StringBuffer out = new StringBuffer();
			out.append("<option value='null'>select Batch</option>");
			for (HashMap<String, Object> item : data) {
				out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
			}
			out.append("");
			response.getWriter().print(out);
		}
		
		if(request.getParameter("type")!=null&&request.getParameter("type").equalsIgnoreCase("batch") &&request.getParameter("batch")!=null){
			
			String sql="SELECT DISTINCT 	assessment. ID, 	assessment.assessmenttitle, 	CAST ( 		COALESCE ( 			to_char( 				MIN (task.start_date), 				'DD-Mon-yyyy HH24:MI' 			), 			'N/A' 		) AS VARCHAR 	) AS start_date FROM 	task, 	batch, 	batch_group, 	batch_students, 	assessment WHERE 	item_type = 'ASSESSMENT' AND batch.batch_group_id = batch_group. ID AND batch_group. ID = batch_students.batch_group_id AND task.actor = batch_students.student_id AND assessment. ID = task.item_id AND batch. ID = "+request.getParameter("batch")+" GROUP BY assessment.id ";
			
			List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
			StringBuffer out = new StringBuffer();
			
			out.append("<option value='null'>select Assessment</option>");
			
			for (HashMap<String, Object> item : data) {
				out.append("<option value='" + item.get("id") + "'>" + item.get("assessmenttitle")+" ("+item.get("start_date")+ ") </option>");
			}
			out.append("");
			
			response.getWriter().print(out);
		}
			
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
