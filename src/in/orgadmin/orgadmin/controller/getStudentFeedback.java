package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class getStudentFeedback
 */
@WebServlet("/get_student_feedback")
public class getStudentFeedback extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getStudentFeedback() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sql = "";
		StringBuffer out = new StringBuffer();
		
		String param= "";
		
		String collegeQuery ="select distinct id from organization";
		if(request.getParameterMap().containsKey("college_id"))
		{
			collegeQuery=request.getParameter("college_id");
		}
		if(request.getParameterMap().containsKey("param"))
		{
			param= request.getParameter("param");
		}
		
		if(param.equalsIgnoreCase("rating"))
		{
			sql = "";
		}
		else if (param.equalsIgnoreCase("stuData"))
		{
			String limit = "15";
			if(request.getParameterMap().containsKey("limit"))
			{
				limit =request.getParameter("limit");
			}
			String tablesql = "SELECT 	af. ID AS student_id, 	ups.first_name AS student_name, 	upt.first_name AS trainer_name, 	af.rating AS rating, 	af.internet, 	af.projector, 	af.trainer_knowledge, 	af.trainer_too_fast, 	af.too_tough_content, 	af.too_much_theoritic, 	af.no_fun_in_class, 	af.enough_examples, 	af.outside_disturbance FROM 	student_feedback af, 	user_profile ups,   user_profile upt, 	user_org_mapping uo WHERE  af.student_id = ups.user_id AND af.trainer_id = upt.user_id AND uo.organization_id IN ("+collegeQuery+") LIMIT "+limit;
			System.out.println(tablesql);
			
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(tablesql);

	

			for (HashMap<String, Object> item : data) {
				out.append(""
						+ "<tr><td>"+item.get("student_id")+"</td>"
								+ "<td>"+item.get("student_name")+"</td>"
						+ "<td>"+item.get("trainer_name")+"</td>"
						+ "<td>"+item.get("rating")+"</td>"
						+ "<td>"+item.get("enough_examples")+"</td>"
						+ "</tr>"
						+ "");
			}
			
		}
		else
		{
			sql ="select (case when TFINAL.total !=0 then (TFINAL.satisfied*100/TFINAL.total ) else 	0 end) as S, ( case when TFINAL.total !=0 then (TFINAL.not_satisfied*100/TFINAL.total ) else  0 end  ) as NS	  from (select  count(*) filter (where student_feedback."+param+" ='t') as not_satisfied,  count(*) filter (where student_feedback."+param+" ='f') as satisfied,  count(*) filter (where student_feedback."+param+" ='t') +  count(*) filter (where student_feedback."+param+" ='f') as total  from student_feedback where event_id in (select id from batch_schedule_event where classroom_id in (select id from classroom_details where organization_id in ("+collegeQuery+"))) ) TFINAL";
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			out.append(
					"<table id='datatable_"+param+"'>     <thead>         <tr>             <th>Category</th>             <th>Percentage</th>         </tr>     </thead>     "
							+ "<tbody>        ");

			if(data.size()>0)
			{
				out.append(" <tr>             <th>Satisfied</th>             <td>"+data.get(0).get("s")+"</td>         </tr>   ");
				out.append(" <tr>             <th>Not Satisfied</th>             <td>"+data.get(0).get("ns")+"</td>         </tr>   ");
			}
			else
			{
				out.append(" <tr>             <th>Satisfied</th>             <td>0</td>         </tr>   ");
				out.append(" <tr>             <th>Not Satisfied</th>             <td>0</td>         </tr>   ");
			}	
			
			

			out.append("</tbody> </table>");
			
		}			
		
		System.out.println(sql);
		System.out.println(out);
		response.getWriter().print(out);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
