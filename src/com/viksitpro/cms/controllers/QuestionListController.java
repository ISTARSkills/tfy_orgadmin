package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.logger.ViksitLogger;
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

			String limit = "10";
			String offset = "0";
			offset = request.getParameter("offset") != null ? request.getParameter("offset") : "0";
			int offsetnew = 0;
			if(!offset.equalsIgnoreCase("0")) {
				offsetnew =  Integer.parseInt(offset) -1;
				offsetnew = offsetnew * 11;
			}
			String sql = "SELECT 	question. ID, 	question.question_text, 	question.question_type, 	question.difficulty_level, 	COALESCE ( 		string_agg (skill_objective. NAME, ', '), 		'&lt;a href=''#''&gt;Link &lt;i class=''fa fa-link''&gt;&lt;/i&gt;&lt;/a&gt;' 	) AS skills, CAST (COUNT(*) OVER() AS INTEGER) AS total_rows FROM 	question LEFT JOIN question_skill_objective ON ( 	question. ID = question_skill_objective.questionid ) LEFT JOIN skill_objective ON ( 	skill_objective. ID = question_skill_objective.learning_objectiveid ) GROUP BY 	question. ID, 	question.question_text, 	question.question_type, 	question.difficulty_level  ORDER BY 	ID DESC LIMIT 11 OFFSET '"+offsetnew+"';";
			
			List<HashMap<String, Object>> question_lists = db.executeQuery(sql);
			ViksitLogger.logMSG(this.getClass().getName(),sql);
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
			int offsetnew = 0;
			if(!offset.equalsIgnoreCase("") && !offset.equalsIgnoreCase("0")) {
				offsetnew =  Integer.parseInt(offset) -1;
				offsetnew = offsetnew * 11;
			}
			
			String difficult_level = request.getParameter("difficult_level") != null ? request.getParameter("difficult_level") : "0";
			String context_filter = request.getParameter("context_filter") != null ? request.getParameter("context_filter") : "0";
			String search_tearm = request.getParameter("search_tearm") != null ? request.getParameter("search_tearm") : "";
			String finalSearchTearm = "";
			String filterTearm = "";
			
			 if( !search_tearm.trim().equalsIgnoreCase("")) {
				finalSearchTearm = search_tearm;	
			}
			
			if(!difficult_level.equalsIgnoreCase("0") && !difficult_level.trim().equalsIgnoreCase("") && !context_filter.equalsIgnoreCase("0") && !context_filter.trim().equalsIgnoreCase("")) {
				filterTearm = "WHERE question.difficulty_level in ("+difficult_level+") AND question.context_id in ("+context_filter+")";	
			}
			else if(!context_filter.equalsIgnoreCase("0") && !context_filter.trim().equalsIgnoreCase("")) {
				filterTearm = "WHERE question.context_id in ("+context_filter+")";	
			}
			else if(!difficult_level.equalsIgnoreCase("0") && !difficult_level.trim().equalsIgnoreCase("")) {
				filterTearm = "WHERE question.difficulty_level in ("+difficult_level+")";	
			}
			
			String sql = "SELECT 	CAST (COUNT(*) OVER() AS INTEGER) AS total_rows, TF.* FROM 	( 		SELECT DISTINCT 	question. ID, 			question.question_text, 			question.question_type, 			question.difficulty_level, 			COALESCE ( 				string_agg (skill_objective. NAME, ', '), 				'&lt;a href=''#''&gt;Link &lt;i class=''fa fa-link''&gt;&lt;/i&gt;&lt;/a&gt;' 			) AS skills 		FROM 			question 		LEFT JOIN question_skill_objective ON ( 			question. ID = question_skill_objective.questionid 		) 		LEFT JOIN skill_objective ON ( 			skill_objective. ID = question_skill_objective.learning_objectiveid 		) "+filterTearm+" 		 GROUP BY 			question. ID, 			question.question_text, 			question.question_type, 			question.difficulty_level  	) TF WHERE   CAST(TF.id as VARCHAR) LIKE '%"+finalSearchTearm+"%' OR	TF.question_text LIKE '%"+finalSearchTearm+"%' OR TF.question_type LIKE '%"+finalSearchTearm+"%' OR TF.skills LIKE '%"+finalSearchTearm+"%' ORDER BY 			TF.ID DESC 		LIMIT 11 OFFSET '"+offsetnew+"';";
			ViksitLogger.logMSG(this.getClass().getName(),sql);
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
		// ViksitLogger.logMSG(this.getClass().getName(),(">>> "+out.toString());
		response.getWriter().print(out.toString());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
