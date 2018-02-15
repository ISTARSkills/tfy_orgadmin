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

@WebServlet("/assessment_list")
public class AssessmentListController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public AssessmentListController() {
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
				offsetnew = offsetnew * 10;
			}
			String context_id = request.getParameter("context_id") != null ? request.getParameter("context_id") : "5";
			
			String sql = "SELECT 	CAST (COUNT(*) OVER() AS INTEGER) AS total_rows, id, question_text, 	question_type, 	difficulty_level FROM 	question WHERE 	context_id = "+context_id+" ORDER BY 	ID DESC LIMIT 10 OFFSET '"+offsetnew+"';";
			
			List<HashMap<String, Object>> question_lists = db.executeQuery(sql);
			ViksitLogger.logMSG(this.getClass().getName(),sql);
			if (question_lists.size() != 0) {
				for (HashMap<String, Object> question_list : question_lists) {
					int pageination = (int) question_list.get("total_rows") / 10;
					pageination = pageination + 1;
					out.append(
							"<tr>" + "<td id='total_rows' style='display:none'>" + pageination + "</td>" + "<td>"
									+ question_list.get("id") + "</td>" + "<td>" + question_list.get("question_text")
									+ "</td>" 
									+ "<td>" + question_list.get("question_type") + "</td>" + "<td>"
									+ question_list.get("difficulty_level") + "</td>"
									+ "<td><a class='question-edit-popup' data-question_id='"+question_list.get("id")+"'href='#'>Edit <i class='fa fa-pencil'></i></a></td>" + "</tr>");

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
