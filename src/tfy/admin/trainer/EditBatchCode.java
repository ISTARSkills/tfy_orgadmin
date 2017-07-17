package tfy.admin.trainer;

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
 * Servlet implementation class EditBatchCode
 */
@WebServlet("/edit_batch_code")
public class EditBatchCode extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditBatchCode() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		String userId = request.getParameter("student_id");
		String batchCode =  request.getParameter("batch_code");
		DBUTILS util = new DBUTILS();
		String findGroupIdForCode ="select id from batch_group where batch_code='"+batchCode+"'";
		
		List<HashMap<String, Object>> grpData = util.executeQuery(findGroupIdForCode);
		for(HashMap<String, Object> row: grpData)
		{
			int groupId = (int)row.get("id");
			String checkIfMappingExist ="select cast(count(*) as integer) as cnt from batch_students where student_id ="+userId+" and batch_group_id="+groupId+"";
			List<HashMap<String, Object>> mappins =   util.executeQuery(checkIfMappingExist);
			if(mappins.size()>0 && (int)mappins.get(0).get("cnt")==0)
			{
				String insertIntoBatchStudents ="insert into batch_students (id, student_id, batch_group_id) values((select COALESCE(max(id),0)+1 from batch_students),"+userId+","+groupId+")";
				util.executeUpdate(insertIntoBatchStudents);
			}
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
