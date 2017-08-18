package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class QuestionEngineController
 */
@WebServlet("/question_engine")
public class QuestionEngineController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public QuestionEngineController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
		// printParams(request);
		DBUTILS db = new DBUTILS();
		String question_passage = "";
		boolean isCreate = true;
		if (request.getParameter("operation_mode") != null && request.getParameter("operation_mode").equalsIgnoreCase("Edit")) {
			isCreate = false;
		}

		if (request.getParameter("question_text") != null && !request.getParameter("question_text").equalsIgnoreCase("")) {
			try {

				String question_text = request.getParameter("question_text");
				String question_explain = request.getParameter("question_explain").equalsIgnoreCase("") ? "Not Available" : request.getParameter("question_explain");
				String question_type = request.getParameter("question_type");
				String question_diffculty = request.getParameter("question_diffculty");
				if (request.getParameter("question_passage") != null) {
					question_passage = request.getParameter("question_passage");
				}
				String question_lob[] = request.getParameter("question_lob").toString().split(",");
				String context_id = request.getParameter("context");
				ArrayList<Integer> lobList = new ArrayList<Integer>();
				if (question_lob != null) {
					if (question_lob.length > 0) {
						for (int i = 0; i < question_lob.length; i++) {
							try {
								lobList.add(Integer.parseInt(question_lob[i]));

							} catch (Exception e) {

							}
						}
					}
				}
				int questionId = 0;
				String sql = "";
				if (isCreate) {
					sql = "INSERT INTO question ( 	ID, 	question_text, 	question_type, 	created_at, 	difficulty_level, 	specifier, 	duration_in_sec, 	explanation, 	comprehensive_passage_text, 	points , context_id) VALUES" + " 	( 		(select COALESCE(max(id),0)+1 from question), 		'" + question_text + "', 		'" + question_type + "', 		'now()', 		'"
							+ question_diffculty + "', 		'1',		'60', 		'" + question_explain + "', 		'" + question_passage + "', 		'1' 	, " + context_id + ") returning id";

					// System.err.println(sql);
					questionId = (int) db.executeUpdateReturn(sql);
				} else {
					questionId = Integer.parseInt(request.getParameter("question_id"));

					sql = "UPDATE question SET question_text='" + question_text + "', question_type='" + question_type + "', created_at='now()', difficulty_level='" + question_diffculty + "',explanation='" + question_explain + "', comprehensive_passage_text='" + question_passage + "' WHERE (id='" + questionId + "')";
					// System.err.println(sql);
					db.executeUpdate(sql);
				}

				if (!isCreate) {
					// delete all options related questionId
					sql = "delete from assessment_option where question_id=" + questionId;
					db.executeUpdate(sql);

					// delete all learning_objective_question related questionId
					sql = "delete from question_skill_objective where questionid=" + questionId;
					db.executeUpdate(sql);
				}

				for (int lobj_id : lobList) {
					sql = "INSERT INTO question_skill_objective (learning_objectiveid, questionid) VALUES (" + lobj_id + "," + questionId + ")";
					// System.err.println("sKILL QUESTION QUERY
					// >>>>>>>>>>>>>"+sql);
					db.executeUpdate(sql);
				}

				if (request.getParameter("optionCount") != null && !request.getParameter("optionCount").equalsIgnoreCase("")) {
					int optinCount = Integer.parseInt(request.getParameter("optionCount"));

					// System.out.println("optinCount--------"+optinCount);

					for (int i = 0; i <= optinCount; i++) {
						if (request.getParameter("option_" + i) != null && !request.getParameter("option_" + i).equalsIgnoreCase("")) {

							String optionText = request.getParameter("option_" + i);
							int markingScheme = 0;
							try {
								if (request.getParameter("option_correct_" + i) != null && request.getParameter("option_correct_" + i).equalsIgnoreCase("on")) {
									markingScheme = 1;
								}
							} catch (Exception e) {

							}

							sql = "INSERT INTO assessment_option (id, text, question_id, marking_scheme) VALUES ((select COALESCE(max(id),0)+1 from assessment_option), '" + optionText + "', " + questionId + ", '" + markingScheme + "')";
							// System.err.println(sql);
							db.executeUpdate(sql);
						}
					}
				}
				response.setContentType("text/html");
				PrintWriter out = response.getWriter();
				out.println(questionId);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
