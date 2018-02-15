package in.talentify.core.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class DashboardGraphController
 */
@WebServlet("/dashboard_report")
public class DashboardGraphController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DashboardGraphController() {
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

		StringBuffer out = new StringBuffer();
		String reportName = request.getParameter("report_name");
		DBUTILS dbutils = new DBUTILS();

		switch (reportName) {
		case "PROGRAMVIEWREPORT":

			out.append(
					"<table id='program_view_datatable' style='display: none'><thead><tr><th></th><th>Rookie</th><th>Apprentice</th><th>Master</th><th>Wizard</th></tr></thead><tbody>");

			int courseId = Integer.parseInt(request.getParameter("courseId"));
			int collegeId = Integer.parseInt(request.getParameter("collegeId"));

			String sql12 = "SELECT 	batch_group.name, 	CAST (AVG(master) * 100 AS INTEGER) AS master, 	CAST (AVG(rookie) * 100 AS INTEGER) AS rookie, 	CAST ( 		AVG (apprentice) * 100 AS INTEGER 	) AS apprentice, 	CAST (AVG(wizard) * 100 AS INTEGER) AS wizard, 	CAST ( 		( 			AVG (master) + AVG (rookie) + AVG (apprentice) + AVG (wizard) 		) AS INTEGER 	) AS total FROM 	mastery_level_per_course, batch_group WHERE "
					+ "	mastery_level_per_course.college_id = "+collegeId+" AND course_id = "+courseId+" AND batch_group.id = mastery_level_per_course.batch_group_id GROUP BY 	batch_group.name ORDER BY total";
			
			////ViksitLogger.logMSG(this.getClass().getName(),"sql2------->" + sql12);
			List<HashMap<String, Object>> program_scores = dbutils.executeQuery(sql12);

			if (program_scores.size() > 0) {

				for (HashMap<String, Object> program_score : program_scores) {
					
					
					////ViksitLogger.logMSG(this.getClass().getName(),">>>>>>>>>>>>>>>>>>>200"+program_score.get("rookie").toString());
					if(Integer.parseInt(program_score.get("total").toString()) > 0)
					{
						out.append(
								"<tr> <th>" + program_score.get("name") + "</th> <td>"
										+ Integer.parseInt(program_score.get("rookie").toString())
												/ Integer.parseInt(program_score.get("total").toString())
										+ "</td> <td>"
										+ Integer.parseInt(program_score.get("apprentice").toString())
												/ Integer.parseInt(program_score.get("total").toString())
										+ "</td> <td>"
										+ Integer.parseInt(program_score.get("master").toString())
												/ Integer.parseInt(program_score.get("total").toString())
										+ "</td> <td>"
										+ Integer.parseInt(program_score.get("wizard").toString().toString())
												/ Integer.parseInt(program_score.get("total").toString().toString())
										+ "</td> " + "</tr> ");
					}else{
						
						out.append("<tr> <th>0</th><td>0</td><td>0</td><td>0</td><td>0</td></tr>");
					}
					
					
					
				}
			} else {
				out.append("<tr> <th>0</th><td>0</td><td>0</td><td>0</td><td>0</td></tr>");
			}
			out.append("</tbody></table>");
			////ViksitLogger.logMSG(this.getClass().getName(),"PROGRAMVIEWREPORT------->" + out);
			break;
		case "COURSEVIEWREPORT":

			out.append("<table id='course_view_datatable' style='display: none'>"
					+ "<thead><tr><th></th><th>Rookie</th><th>Apprentice</th><th>Master</th><th>Wizard</th></tr></thead>");

			int batchGroupId = Integer.parseInt(request.getParameter("batchGroupId"));
			collegeId = Integer.parseInt(request.getParameter("collegeId"));

			String sql14 = "SELECT 	course.course_name, 	CAST (AVG(master) * 100 AS INTEGER) AS master, 	CAST (AVG(rookie) * 100 AS INTEGER) AS rookie, 	CAST ( 		AVG (apprentice) * 100 AS INTEGER 	) AS apprentice, 	CAST (AVG(wizard) * 100 AS INTEGER) AS wizard, 	CAST ( 		( 			AVG (master) + AVG (rookie) + AVG (apprentice) + AVG (wizard) 		) AS INTEGER 	) AS total FROM 	mastery_level_per_course,course WHERE"
					+ " 	 mastery_level_per_course.college_id = "+collegeId+" AND batch_group_id = "+batchGroupId+" AND course.id = mastery_level_per_course.course_id GROUP BY 	course.course_name ORDER BY 	total";
			
			////ViksitLogger.logMSG(this.getClass().getName(),"sql------->" + sql14);
			List<HashMap<String, Object>> course_scores = dbutils.executeQuery(sql14);

			if (course_scores.size() > 0) {
				for (HashMap<String, Object> course_score : course_scores) {
					
					if(Integer.parseInt(course_score.get("total").toString()) > 0){
						
						out.append(
								"<tbody><tr><th>" + course_score.get("course_name") + "</th>" + "<td>"
										+ Integer.parseInt(course_score.get("rookie").toString().replaceAll("NaN", "0"))
												/ Integer.parseInt(course_score.get("total").toString().replaceAll("NaN", "0"))
										+ "</td>" + "<td>"
										+ Integer.parseInt(course_score.get("apprentice").toString().replaceAll("NaN", "0"))
												/ Integer.parseInt(course_score.get("total").toString().replaceAll("NaN", "0"))
										+ "</td>" + "<td>"
										+ Integer.parseInt(course_score.get("master").toString().replaceAll("NaN", "0"))
												/ Integer.parseInt(course_score.get("total").toString().replaceAll("NaN", "0"))
										+ "</td>" + "<td>"
										+ Integer.parseInt(course_score.get("wizard").toString().replaceAll("NaN", "0"))
												/ Integer.parseInt(course_score.get("total").toString().replaceAll("NaN", "0"))
										+ "</td>" + "</tr>");
					}
					else{
						
						out.append("<tr> <th>0</th><td>0</td><td>0</td><td>0</td><td>0</td></tr>");
					}

					

				}
			} else {
				out.append("<tr> <th>0</th><td>0</td><td>0</td><td>0</td><td>0</td></tr>");
			}
			out.append("</tbody></table>");
			////ViksitLogger.logMSG(this.getClass().getName(),"COURSEVIEWREPORT------->" + out);
			break;
		case "PROGRESSVIEWREPORT":
			
			collegeId = Integer.parseInt(request.getParameter("collegeId"));
			
			out.append("<table id='progress_view_datatable' data-college="+collegeId+" style='display: none'><thead><tr><th></th>");
			String sql9 = "select id, created_at, batch_group_name, avg_score from bg_progress where college_id ="
					+ collegeId + " ORDER BY created_at";
			////ViksitLogger.logMSG(this.getClass().getName(),"sql------->" + sql9);
			List<HashMap<String, Object>> progress_views = dbutils.executeQuery(sql9);

			String bg_name = "FALSE";
			for (HashMap<String, Object> progress_view : progress_views) {
				
				
				if (bg_name.equalsIgnoreCase("FALSE")) {
					bg_name = progress_view.get("batch_group_name").toString();

					out.append("<th>" + bg_name + "</th>");
				} else if (bg_name.equalsIgnoreCase(progress_view.get("batch_group_name").toString())) {
					continue;
				} else {
					bg_name = progress_view.get("batch_group_name").toString();
					out.append("<th>" + bg_name + "</th>");
				}
			}

			out.append("</tr></thead><tbody>");

			for (HashMap<String, Object> progress_view : progress_views) {
				

				out.append("<tr><th>" + progress_view.get("created_at").toString() + "</th>" + "<td>"
						+ progress_view.get("avg_score").toString() + "</td></tr>");

			}

			out.append("</tbody></table>");
			////ViksitLogger.logMSG(this.getClass().getName(),"PROGRESSVIEWREPORT------->" + out);
			break;
	  	case "COMPETITIONVIEWREPORT":
			
			collegeId = Integer.parseInt(request.getParameter("collegeId"));
			
			Organization college = new OrganizationDAO().findById(collegeId);
			String orgName = college.getName();
			
			String sql10 = "SELECT DISTINCT 	csobj .skill_objective_id, 	c.course_name, 	CAST ( 		AVG (sp.percentage) AS INTEGER 	) FROM 	batch_group AS bg, 	batch AS b, 	course_skill_objective AS csobj, course c, 	skill_precentile sp, 	batch_students AS bs WHERE 	bg.college_id = "+collegeId+" AND b.batch_group_id = bg. ID AND bs.batch_group_id = b.batch_group_id AND b.course_id = csobj .course_id AND csobj .course_id = c.id AND csobj .skill_objective_id = sp.skill_id AND bs.student_id = sp.student_id GROUP BY 	c .course_name, 	csobj .skill_objective_id ORDER BY 	AVG";
			
		//	//ViksitLogger.logMSG(this.getClass().getName(),"sql------->" + sql10);
			
			out.append("<table id='competition_view_datatable' style='display: none'>"
					+ "<thead><tr><th></th>");
			
			List<HashMap<String, Object>> current_college_scores = dbutils.executeQuery(sql10);
			for (HashMap<String, Object> current_college_score : current_college_scores) {
				
			
				out.append("<th>"+current_college_score.get("course_name")+"</th>");
				
			}
			
			out.append("</tr></thead><tbody><tr>"
					+ "<th>"+orgName+"</th>");
			
			for (HashMap<String, Object> current_college_score : current_college_scores) {
				
				
				out.append("<td>"+ current_college_score.get("avg").toString() +"</td>");
			}
			
			out.append("</tr></tbody></table>");
			////ViksitLogger.logMSG(this.getClass().getName(),"last out------->" + out);
			break;
		default:
			break;
		}
		
		////ViksitLogger.logMSG(this.getClass().getName(),"out------->" + out);
		response.getWriter().print(out);
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
