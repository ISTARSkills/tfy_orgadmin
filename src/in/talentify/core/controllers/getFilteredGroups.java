package in.talentify.core.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportUtils;

/**
 * Servlet implementation class getFilteredGroups
 */
@WebServlet("/get_filtered_groups")
public class getFilteredGroups extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getFilteredGroups() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		String filterBy = request.getParameter("filter_by");
		Integer collegeId = Integer.parseInt(request.getParameter("college_id"));
		CustomReportUtils reportUtil = new CustomReportUtils();
		CustomReport report = reportUtil.getReport(5);
		
		DBUTILS util = new  DBUTILS();
		String sql =report.getSql();
		sql=sql.replaceAll(":college_id", collegeId+"");
		sql= sql.replaceAll(":filter_by", filterBy);
		
		
		
		List<HashMap<String,Object>> groups =util.executeQuery(sql);
		StringBuffer sb = new StringBuffer();
		for(HashMap<String, Object> row: groups)
		{
			sb.append("<option value='"+row.get("id").toString()+"'>"+row.get("name").toString()+"</option>");
		}
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
