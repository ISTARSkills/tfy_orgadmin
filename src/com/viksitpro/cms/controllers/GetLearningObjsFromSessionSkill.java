package com.viksitpro.cms.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class GetLearningObjsFromSessionSkill
 */
@WebServlet("/get_learning_objectives")
public class GetLearningObjsFromSessionSkill extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GetLearningObjsFromSessionSkill() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String sql = "SELECT * FROM public.skill_objective";
		if (request.getParameterMap().containsKey("session_skill_id") && request.getParameterMap().containsKey("context_id")) {
			sql = "select * from skill_objective where type = 'LEARNING_OBJECTIVE' AND parent_skill = " + Integer.parseInt(request.getParameter("session_skill_id").toString()) + " and context = " + Integer.parseInt(request.getParameter("context_id").toString()) + " order by order_id";
		}
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> results = dbutils.executeQuery(sql);
		JSONObject resp = new JSONObject();
		JSONArray array = new JSONArray();
		for (HashMap<String, Object> hashMap : results) {
			JSONObject item = new JSONObject();
			try {
				item.put("id", hashMap.get("id"));
				item.put("text", /* hashMap.get("id") + " " + */hashMap.get("name"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			array.put(item);
		}
		try {
			resp.put("skills", array);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("application/json");
		response.getWriter().write(resp.toString());
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
