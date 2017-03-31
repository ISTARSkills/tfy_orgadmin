package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class CreateOrUpdateBatchController
 */
@WebServlet("/create_or_update_batch")
public class CreateOrUpdateBatchController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateOrUpdateBatchController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		if (request.getParameterMap().containsKey("batch_group")
				&& !request.getParameter("batch_group").equalsIgnoreCase("")
				&& request.getParameterMap().containsKey("couse_id")
				&& !request.getParameter("couse_id").equalsIgnoreCase("")) {

			int batch_group = Integer.parseInt(request.getParameter("batch_group"));
			int couse_id = Integer.parseInt(request.getParameter("couse_id"));

			BatchGroup bg = new BatchGroupDAO().findById(batch_group);
			Course c = new CourseDAO().findById(couse_id);

			if (bg != null && c != null) {
				StringBuffer out=new StringBuffer();
				DBUTILS db = new DBUTILS();
				
				String batchGroupName = bg.getName();
				String courseName = c.getCourseName();
				String batchName=batchGroupName+"_"+courseName;
						
				String sql="select * from batch where batch_group_id="+batch_group+" and course_id="+couse_id;
				System.err.println(sql);
				
				List<HashMap<String, Object>> data = db.executeQuery(sql);
				
				if(data.size()==0){
				sql = "INSERT INTO batch ( 	ID, 	createdat, 	NAME, 	updatedat, 	batch_group_id, 	course_id ) VALUES 	((select COALESCE(max(id),0)+1 from batch) 		, 		'now()', 		'"+batchName+"', 		'now()', 		'"+batch_group+"', 		'"+couse_id+"')returning id";
				System.err.println(sql);
				int batchId = (int) db.executeUpdateReturn(sql);
				
				sql="UPDATE batch SET order_id='"+batchId+"' WHERE (id='"+batchId+"')";
				System.err.println(sql);
				db.executeUpdate(sql);
				
				out.append("<div class='alert alert-dismissable gray-bg'><button aria-hidden='true' data-dismiss='alert' data-role='"+batch_group+"' data-role_skill='"+batchId+"' class='close role-map' type='button'></button>"+batchName+"</div>");
				response.getWriter().print(out);
				}else{
					System.out.println("Batch already created for batch_group:"+batch_group+" course:"+couse_id);
				}
			}

		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
