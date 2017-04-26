package tfy.admin.controllers;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.orgadmin.utils.report.ReportUtils;
import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class ChartFilter
 */
@WebServlet("/chart_filter")
public class ChartFilter extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChartFilter() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		ReportUtils util = new ReportUtils();
		int reportId = Integer.parseInt(request.getParameter("report_id"));
		HashMap<String, String> conditions = new HashMap<>();
		Enumeration params = request.getParameterNames(); 
		while(params.hasMoreElements()){
		 String paramName = (String)params.nextElement();
		 String paramValue = request.getParameter(paramName);
		 conditions.put(paramName, paramValue);
		}
		StringBuffer sb = new StringBuffer(util.getHTML(reportId, conditions));
		
		response.getWriter().write(sb.toString());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
