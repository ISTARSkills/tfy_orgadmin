package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

/**
 * Servlet implementation class UpdateBatchGroup
 */
@WebServlet("/update_batchgroup")
public class UpdateBatchGroup extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    
    public UpdateBatchGroup() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		
DBUTILS util = new DBUTILS();


Calendar cal = Calendar.getInstance();
Date dt = cal.getTime();
		
		
		
		String batchGroup_name = request.getParameter("batchGroup_name");
		int	max_student = Integer.parseInt(request.getParameter("max_student"));
		int	ass_id = 10195;
		
		if(request.getParameter("ass_id")!=null && !(request.getParameter("ass_id").equalsIgnoreCase("NONE"))){
			
			ass_id = Integer.parseInt(request.getParameter("ass_id"));

		}
		
        if(request.getParameter("batchgroup_id")!=null){
        	
        	int	batch_group_id = Integer.parseInt(request.getParameter("batchgroup_id"));
       
			
			String update_sql = "UPDATE batch_group SET name = '"+batchGroup_name+"', max_students = "+max_student+", assessment_id = "+ass_id+"  WHERE id="+batch_group_id;
			System.out.println("------------update_sql------------"+ update_sql);
			util.executeUpdate(update_sql);
			  
			   
			String org_id_sql = "SELECT college_id from batch_group WHERE id="+batch_group_id;
			List<HashMap<String, Object>> data = util.executeQuery(org_id_sql);
		    String college_id =  data.get(0).get("college_id").toString();
		    response.sendRedirect("orgadmin/organization/dashboard.jsp?org_id="+college_id);
			
		}else{
       	 
			int	org_id = Integer.parseInt(request.getParameter("org_id"));
			//System.out.println("--------------ass_id----------"+ass_id);
			
			int batch_code =  getRandomInteger(100000,999999);
			
			 
			
       	 String insert_sql = "INSERT INTO batch_group ( 	id, 	createdat, 	max_students, 	name, 	updatedat, 	college_id , batch_code, assessment_id) "
       	 		+ "VALUES 	( 	(SELECT max(id) +1 FROM batch_group ), 		'"+dt+"', 		"+max_student+", 		'"+batchGroup_name+"', 		'"+dt+"', 		"+org_id+",  "+batch_code+",  "+ass_id+" )";
			
			System.out.println(insert_sql);
		     util.executeUpdate(insert_sql);
			
		   
			//batch_code= bg_id+batch_code;
			//String update_batch_code = "update batch_group set batch_code='"+batch_code+"' where id ="+bg_id+";";
			//util.executeUpdate(update_batch_code);
			
			 response.sendRedirect("orgadmin/organization/dashboard.jsp?org_id="+org_id);
		}
		
		
       
        
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


		doGet(request, response);
	}
	public static int getRandomInteger(int maximum, int minimum){ return ((int) (Math.random()*(maximum - minimum))) + minimum; }
}
