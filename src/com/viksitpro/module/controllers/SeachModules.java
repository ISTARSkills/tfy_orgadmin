package com.viksitpro.module.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.Module;
import com.viksitpro.core.dao.entities.ModuleDAO;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class SeachModules
 */
@WebServlet("/SeachModules")
public class SeachModules extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SeachModules() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONArray module_array = new JSONArray();
		if (request.getParameterMap().containsKey("searchString")) {
			String[] searchString = request.getParameter("searchString").toString().split(" ");
			Set<Module> modules = new HashSet<Module>();
			ModuleDAO dao = new ModuleDAO();
			Module module;
			List all_modules = dao.findAll();
			for (Object object : all_modules) {
				module = (Module) object;
				boolean is_contained = false;
				for (String search : searchString) {
					if (module.getModuleName().toLowerCase().contains(search)) {
						is_contained = true;
					}
					if (module.getModule_description().toLowerCase().contains(search)) {
						is_contained = true;
					}
					if (module.getId().toString().contains(search)) {
						is_contained = true;
					}					
				}
				if (is_contained) {
					modules.add(module);
				}
			}
			for (Module m : modules) {
				JSONObject module_object = new JSONObject();
				try {
					module_object.put("id", m.getId());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					module_object.put("name", m.getModuleName());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				module_array.put(module_object);
			}
		}
		JSONObject resp = new JSONObject();
		try {
			resp.put("modules", module_array);
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
