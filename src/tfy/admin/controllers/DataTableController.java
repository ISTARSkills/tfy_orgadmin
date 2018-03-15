package tfy.admin.controllers;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.ColumnHandler;
import in.orgadmin.utils.report.IStarColumn;
import in.orgadmin.utils.report.Report;
import in.orgadmin.utils.report.ReportColumnHandlerFactory;
import in.orgadmin.utils.report.ReportUtils;
import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class DataTableController
 */
@WebServlet("/data_table_controller")
public class DataTableController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DataTableController() {
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
		Enumeration params = request.getParameterNames(); 
		while(params.hasMoreElements()){
		 String paramName = (String)params.nextElement();
		 String paramValue = request.getParameter(paramName);
		 conditions.put(paramName, paramValue);
		}
		
		String searchTerm = request.getParameter("search[value]");
		//ViksitLogger.logMSG(this.getClass().getName(),"search term>>>"+searchTerm);
		if (searchTerm != null && searchTerm.equalsIgnoreCase("")) {
		
			conditions.put("limit", request.getParameter("length"));
			conditions.put("offset", request.getParameter("start"));
		}
		else
		{
			conditions.put("limit", "all");
			conditions.put("offset", "0");
		}	
		
		conditions.put("order_by_column", (Integer.parseInt(request.getParameter("order[0][column]")) + 1)+"");
		conditions.put("order_type", request.getParameter("order[0][dir]"));
		
		DBUTILS db = new DBUTILS();
		String sql1=report.getSql();
		for (String key : conditions.keySet()) {			
			String paramName=":"+key;				
			if (sql1.contains(paramName)) {
				//ViksitLogger.logMSG(this.getClass().getName(),"key->" + key + "   value-> " + conditions.get(key));					
				sql1 =sql1.replaceAll(paramName, conditions.get(key));
			}			
		}
		
		
		JSONArray array = new JSONArray();
		List<HashMap<String, Object>> data = db.executeQuery(sql1);		
		String resultSize ="0";
		for (HashMap<String, Object> item : data) {
			resultSize = item.get("total_rows").toString();
			
			
			if (condition(item, searchTerm) || searchTerm.equalsIgnoreCase("")) {
				JSONArray tableRowsdata = new JSONArray();
				for (IStarColumn iterable_element : report.getColumns()) {
					if(iterable_element.getIsVisible()){
						//out.append("<th>"+hashMap.get(iterable_element.getName())+"</th>");
						if(iterable_element.getColumnHandler().equalsIgnoreCase("NONE"))
						{
							tableRowsdata.put(item.get(iterable_element.getName()));
						}
						else
						{
							ColumnHandler handler= ReportColumnHandlerFactory.getInstance().getHandler(iterable_element.getColumnHandler());
							
							String val="";
							String order="";
							if(handler!=null && item.get(iterable_element.getName())!=null && handler.getHTML(item.get(iterable_element.getName()).toString(), reportId)!=null){
								val= handler.getHTML(item.get(iterable_element.getName()).toString(), reportId).toString();;
								order = handler.getOrder(item.get(iterable_element.getName()).toString(), reportId).toString();;
							}
							tableRowsdata.put(val);
						}	
					} 
				}				
				array.put(tableRowsdata);
			}if(!searchTerm.equalsIgnoreCase("")) {
				resultSize = "0";
			}
			
		}
		
		
		JSONObject jsonObject = new JSONObject();
		try{	
			
			jsonObject.put("draw", request.getParameter("draw"));
			jsonObject.put("recordsTotal", resultSize + "");
			jsonObject.put("recordsFiltered", resultSize + "");
			jsonObject.put("iDisplayLength", 10);
			jsonObject.put("data", array);
		} catch (Exception e) {
			e.printStackTrace();
		}

		response.setContentType("application/json");
		response.getWriter().print(jsonObject);
		response.getWriter().flush();
		
	}
	
	public boolean condition(HashMap<String, Object> item, String searchTerm) {
		
		boolean status = false;
		for (String key : item.keySet()) {
			if (item.get(key) != null && searchTerm != null) {
				for (int i = 0; i < searchTerm.split(",").length; i++) {					
					if (item.get(key).toString().toUpperCase().contains(searchTerm.split(",")[i].toUpperCase())) {
						status = true;
						break;
					}
				}
			}
		}
		return status;
	}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
