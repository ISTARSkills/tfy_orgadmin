package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.utils.DummyStudent;

/**
 * Servlet implementation class GetAllStudentByCourse
 */
@WebServlet("/GetAllStudentByCourse")
public class GetAllStudentByCourse extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GetAllStudentByCourse() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		StringBuffer sb = new StringBuffer();
		System.out.println("hh h hhh " + request.getParameter("type").toString());

		int count = 6 * (Integer.parseInt(request.getParameter("page")));
		String sql = "";

		if (request.getParameter("type").toString().equalsIgnoreCase("true")) {
			sql = "SELECT DISTINCT 	s. ID AS student_id, 	sp.first_name, 	COALESCE (s.mobile,0) as mobile, 	s.email, 	COALESCE ( 		NULLIF (sp.last_name, ''), 		'Not Available' 	) AS lastname, 	COALESCE ( 		NULLIF (CAST(sp.dob AS VARCHAR), ''), 		'Not Available' 	) AS dob, 	CASE WHEN ( 	sp.gender IS NULL 	OR sp.gender LIKE '%null%' ) THEN 	CASE WHEN (sp.gender IS NULL) THEN 	'NA' ELSE 	sp.gender END ELSE 	sp.gender END AS gender,  CASE WHEN sp.profile_image LIKE 'null' OR sp.profile_image IS NULL THEN 	'http://api.talentify.in/video/android_images/' || UPPER (SUBSTRING(sp.first_name FROM 1 FOR 1)) || '.png' ELSE 	'http://api.talentify.in/' || sp.profile_image END AS profile_image,  COALESCE ( 	NULLIF (pp.company_name, ' '), 	'Not Available' ) AS company_name,  col. NAME AS college_name FROM 	batch b, 	batch_students bs, 	batch_group bg, 	istar_user s, 	user_profile sp, professional_profile pp, 	organization col WHERE 	bs.student_id = s. ID AND bg. ID = b.batch_group_id AND bg. ID = bs.batch_group_id AND bg.college_id = "
					+ request.getParameter("college_id").toString() + " AND b.course_id = "
					+ request.getParameter("id").toString()
					+ " AND sp.user_id = s. ID AND col. ID = bg.college_id AND pp.user_id = s. ID ORDER BY 	sp.first_name LIMIT 6"
					+ "OFFSET  " + count;
		} else {
			sql = "SELECT DISTINCT 	s. ID AS student_id, 	sp.first_name, 	COALESCE (s.mobile,0) as mobile, 	s.email, 	COALESCE ( 		NULLIF (sp.last_name, ''), 		'Not Available' 	) AS lastname, 	COALESCE ( 		NULLIF (CAST(sp.dob AS VARCHAR), ''), 		'Not Available' 	) AS dob, 	CASE WHEN ( 	sp.gender IS NULL 	OR sp.gender LIKE '%null%' ) THEN 	CASE WHEN (sp.gender IS NULL) THEN 	'NA' ELSE 	sp.gender END ELSE 	sp.gender END AS gender,  CASE WHEN sp.profile_image LIKE 'null' OR sp.profile_image IS NULL THEN 	'http://api.talentify.in/video/android_images/' || UPPER (SUBSTRING(sp.first_name FROM 1 FOR 1)) || '.png' ELSE 	'http://api.talentify.in/' || sp.profile_image END AS profile_image,  COALESCE ( 	NULLIF (pp.company_name, ' '), 	'Not Available' ) AS company_name,  col. NAME AS college_name FROM 	batch b, 	batch_students bs, 	batch_group bg, 	istar_user s, 	user_profile sp, professional_profile pp, 	organization col WHERE 	bs.student_id = s. ID AND bg. ID = b.batch_group_id AND bg. ID = bs.batch_group_id AND bg.college_id = "
					+ request.getParameter("college_id").toString() + " AND b.id = "
					+ request.getParameter("id").toString()
					+ " AND sp.user_id = s. ID AND col. ID = bg.college_id AND pp.user_id = s. ID ORDER BY 	sp.first_name LIMIT 6 "
					+ "OFFSET  " + count;
			
		}

		System.out.println("paginated  sql " + sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			sb.append(
					"<div class='col-lg-2'> <div class='product-box p-xl b-r-lg border-left-right border-top-bottom text-center student_holder'> <div class='holder-data' data-toggle='modal' data-target='"
							+ "#" + item.get("student_id").toString()
							+ "'><img alt='image' class='img-circle m-t-sm' src='"
							+ item.get("profile_image").toString()
							+ "' style='width: 40px; height: 40px;' /> <p class='m-r-sm m-t-sm'>"
							+ item.get("first_name").toString() + "</p></div></div></div><div class='modal inmodal' id='"
							+ item.get("student_id").toString()
							+ "' tabindex='-1' role='dialog' aria-hidden='true'> <div class='modal-dialog'>                                     <div class='modal-content animated flipInY'>                                         <div class='modal-header'>                                             <button type='button' class='close' data-dismiss='modal'><span aria-hidden='true'>&times;</span><span class='sr-only'>Close</span></button>                                             <h4 class='modal-title'>"
							+ item.get("first_name").toString()
							+ "</h4>                                         </div>                                         <div class='modal-body'>                                             <p><strong>First Name: </strong>"
							+ item.get("first_name").toString()
							+ "</p>                                             <p><strong>Last Name: </strong>"
							+ item.get("lastname").toString()
							+ "</p>                                             <p><strong>Email: </strong>"
							+ item.get("email").toString()
							+ " </p>                                             <p><strong>Mobile: </strong>"
							+ item.get("mobile").toString()
							+ " </p>                                             <p><strong>Gender: </strong>"
							+ item.get("gender").toString().toUpperCase()
							+ "</p>                                             <p><strong>College Name: </strong>"
							+ item.get("college_name").toString()

							+ " </p> </div><div class='modal-footer'><button type='button' class='btn btn-primary' data-dismiss='modal'>Close</button> </div></div></div></div>");
		}
		response.getWriter().println(sb);

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
