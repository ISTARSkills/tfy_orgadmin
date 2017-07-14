package tfy.admin.controllers;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.Report;
import in.orgadmin.utils.report.ReportUtils;
import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class CustomReportDataTableFilter
 */
@WebServlet("/custom_report_datatable_filter")
public class CustomReportDataTableFilter extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CustomReportDataTableFilter() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		ReportUtils util = new ReportUtils();
		int reportId = Integer.parseInt(request.getParameter("report_id"));
		Report report = util.getReport(reportId);
		HashMap<String, String> conditions = new HashMap<>();
		
		//org id will be passedd as paramenter
		Enumeration params = request.getParameterNames(); 
		while(params.hasMoreElements()){
		 String paramName = (String)params.nextElement();
		 String paramValue = request.getParameter(paramName);
		 conditions.put(paramName, paramValue);
		}
		conditions.put("limit", "all");
		conditions.put("offset", "0");
		
		DBUTILS db = new DBUTILS();
		String sql1=report.getSql();
		for (String key : conditions.keySet()) {			
			String paramName=":"+key;				
			if (sql1.contains(paramName)) {
				System.out.println("key->" + key + "   value-> " + conditions.get(key));					
				sql1 =sql1.replaceAll(paramName, conditions.get(key));
			}			
		}
		
		System.out.println("-------------------------->"+sql1);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
