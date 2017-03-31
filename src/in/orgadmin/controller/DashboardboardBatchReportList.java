package in.orgadmin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchDAO;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

import in.orgadmin.utils.DatatableUtils;

/**
 * Servlet implementation class DashboardboardReportList
 */
@WebServlet("/batch_report_list")
public class DashboardboardBatchReportList extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public DashboardboardBatchReportList() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		
		
		
		
if(request.getParameterMap().containsKey("ids")){
			
	
			
			String col_id =request.getParameter("ids");
			System.out.println(col_id);
			
			String[] seperate_ids = col_id.split(",");
			
			
			//sb.append("<option value='NONE'>Select Batch</option>");
			for(String Colid : seperate_ids){
				
				String sql ="SELECT id,name FROM batch_group WHERE college_id="+Colid+"";
				
				
				
				List<HashMap<String, Object>> data = util.executeQuery(sql);
                if(data.size()>0)
                {	
                	for(HashMap<String, Object> row : data)
                	{
                		int id= (int)row.get("id");
                		String name= (String)row.get("name");
               
                		sb.append("<option value='"+id+"'>"+name+"</option>");
									
                	}
                }
                
                
                
                
				
				}
			
			
               
		}
		
		if(request.getParameterMap().containsKey("selectedbatch") ){
			
			
			int batchg_id = Integer.parseInt(request.getParameter("selectedbatch"));
			
			sb.append("<div class='ibox-content' style='min-height: 40em;'>");
			DatatableUtils dtUtils = new DatatableUtils();
			HashMap<String, String> conditions = new HashMap<>();
			
			conditions.put("batchg_id", batchg_id + "");
			sb.append(dtUtils.getReport(3040, conditions, ((IstarUser) request.getSession().getAttribute("user")), "NONE").toString());
			sb.append("</div>");
               
		}
		
		
		response.getWriter().print(sb);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

}
