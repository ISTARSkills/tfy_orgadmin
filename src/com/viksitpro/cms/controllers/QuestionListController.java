package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.dao.entities.Question;
import com.viksitpro.core.dao.entities.QuestionDAO;
import com.viksitpro.core.utilities.DBUTILS;

@WebServlet("/question_list")
public class QuestionListController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public QuestionListController() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		DBUTILS db = new DBUTILS();
		StringBuffer out = new StringBuffer();

		if (request.getParameter("key") != null && request.getParameter("key").equalsIgnoreCase("get_all_question")) {

			String limit = "11";
			String offset = "0";
			offset = request.getParameter("offset") != null ? request.getParameter("offset") : "0";
			
			String sql = "SELECT DISTINCT 	CAST (COUNT(*) OVER() AS INTEGER) AS total_rows, 	question. ID, 	question.question_text, 	question.question_type, 	question.difficulty_level, 	COALESCE ( 		string_agg (skill_objective. NAME, ', '), 		'&lt;a href=''#''&gt;Link &lt;i class=''fa fa-pencil''&gt;&lt;/i&gt;&lt;/a&gt;' 	) AS skills, 	LOWER(COALESCE (context.title,'n_a')) as context_title FROM 	question LEFT JOIN question_skill_objective ON ( 	question. ID = question_skill_objective.questionid ) LEFT JOIN skill_objective ON ( 	skill_objective. ID = question_skill_objective.learning_objectiveid 	AND skill_objective. TYPE = 'LEARNING_OBJECTIVE' ) LEFT JOIN context ON ( 	context. ID = question.context_id ) GROUP BY 	question. ID, 	question.question_text, 	question.question_type, 	question.difficulty_level, 	context.title ORDER BY 	ID DESC LIMIT 11 OFFSET '"+offset+"';";
			
			List<HashMap<String, Object>> question_lists = db.executeQuery(sql);
			//System.err.println(sql);
			if (question_lists.size() != 0) {
				for (HashMap<String, Object> question_list : question_lists) {
					int pageination = (int) question_list.get("total_rows") / 11;
					pageination = pageination + 1;
					out.append(
							"<tr>" + "<td id='total_rows' style='display:none'>" + pageination + "</td>" + "<td>"
									+ question_list.get("id") + "</td>" + "<td>" + question_list.get("question_text")
									+ "</td>" + "<td>"
									+ question_list.get("skills").toString().replaceAll("&lt;", "<").replaceAll("&gt;",
											">")
									+ "</td>" + "<td>" + question_list.get("question_type") + "</td>" + "<td>"
									+ question_list.get("difficulty_level") + "</td>"
									+ "<td><a class='question-edit-popup' data-question_id='"+question_list.get("id")+"'href='#'>Edit <i class='fa fa-pencil'></i></a></td>" + "</tr>");

				}

			}else {
				out.append(	"<div style='text-align: center;    width: 100%; position: absolute;'> No Data Available</div>");
			}
		}if (request.getParameter("key") != null && request.getParameter("key").equalsIgnoreCase("difficult_level_type")) {
			String offset = "0";
			offset = request.getParameter("offset") != null ? request.getParameter("offset") : "0";
			int difficult_level = request.getParameter("difficult_level") != null ? Integer.parseInt(request.getParameter("difficult_level")) : 1;
			
			String sql = "SELECT DISTINCT 	CAST (COUNT(*) OVER() AS INTEGER) AS total_rows, 	question. ID, 	question.question_text, 	question.question_type, 	question.difficulty_level, 	COALESCE ( 		string_agg (skill_objective. NAME, ', '), 		'&lt;a href=''#''&gt;Link &lt;i class=''fa fa-link''&gt;&lt;/i&gt;&lt;/a&gt;' 	) AS skills FROM 	question LEFT JOIN question_skill_objective ON ( 	question. ID = question_skill_objective.questionid ) LEFT JOIN skill_objective ON ( 	skill_objective. ID = question_skill_objective.learning_objectiveid 	AND skill_objective. TYPE = 'LEARNING_OBJECTIVE' ) WHERE question.difficulty_level = "+difficult_level+" GROUP BY 	question. ID, 	question.question_text, 	question.question_type, 	question.difficulty_level ORDER BY 	ID DESC LIMIT 11 OFFSET '"
					+ offset + "';";
			//System.err.println(sql);
			List<HashMap<String, Object>> question_lists = db.executeQuery(sql);
			
			if (question_lists.size() != 0) {
				for (HashMap<String, Object> question_list : question_lists) {
					int pageination = (int) question_list.get("total_rows") / 11;
					pageination = pageination + 1;
					out.append(
							"<tr>" + "<td id='total_rows' style='display:none'>" + pageination + "</td>" + "<td>"
									+ question_list.get("id") + "</td>" + "<td>" + question_list.get("question_text")
									+ "</td>" + "<td>"
									+ question_list.get("skills").toString().replaceAll("&lt;", "<").replaceAll("&gt;",
											">")
									+ "</td>" + "<td>" + question_list.get("question_type") + "</td>" + "<td>"
									+ question_list.get("difficulty_level") + "</td>"
									+ "<td><a class='question-edit-popup' data-question_id='"+question_list.get("id")+"' href='#'>Edit <i class='fa fa-pencil'></i></a></td>" + "</tr>");

				}

			}else {
				out.append(	"<div style='text-align: center;    width: 100%; position: absolute;'> No Data Available</div>");
			}
			
		}

		out.append("");
		// System.err.println(">>> "+out.toString());
		response.getWriter().print(out.toString());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
