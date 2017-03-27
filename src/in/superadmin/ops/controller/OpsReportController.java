package in.superadmin.ops.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

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
		
			String sql="select b.id,b.name from batch b,batch_group bg where bg.id=b.batch_group_id and bg.college_id="+request.getParameter("orgId");
			
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
			
			String sql="SELECT DISTINCT 	ass. ID, 	ass.assessmenttitle, 	isa.eventdate FROM 	istar_assessment_event isa, 	assessment ass WHERE 	isa.assessment_id = ass. ID AND isa.batch_id = "+request.getParameter("batch");
			
			List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
			StringBuffer out = new StringBuffer();
			
			out.append("<option value='null'>select Assessment</option>");
			
			for (HashMap<String, Object> item : data) {
				out.append("<option value='" + item.get("id") + "'>" + item.get("assessmenttitle")+" ("+item.get("eventdate")+ ") </option>");
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
