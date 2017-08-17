package com.viksitpro.cmsession.controllers;

import java.io.IOException;
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

import com.viksitpro.core.dao.entities.Cmsession;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;

/**
 * Servlet implementation class SearchSessions
 */
@WebServlet("/SearchSessions")
public class SearchSessions extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchSessions() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONArray session_array = new JSONArray();
		if (request.getParameterMap().containsKey("searchString")) {
			String[] searchString = request.getParameter("searchString").toString().split(" ");
			Set<Cmsession> cmsessions = new HashSet<Cmsession>();
			CmsessionDAO dao = new CmsessionDAO();
			Cmsession cmsession;
			List all_sessions = dao.findAll();
			for (Object object : all_sessions) {
				cmsession = (Cmsession) object;
				boolean is_contained = false;
				for (String search : searchString) {
					if (cmsession.getTitle().toLowerCase().contains(search)) {
						is_contained = true;
					}
					if (cmsession.getDescription().toLowerCase().contains(search)) {
						is_contained = true;
					}
					if (cmsession.getId().toString().contains(search)) {
						is_contained = true;
					}					
				}
				if (is_contained) {
					cmsessions.add(cmsession);
				}
			}
			for (Cmsession c : cmsessions) {
				JSONObject cmcmsessions_object = new JSONObject();
				try {
					cmcmsessions_object.put("id", c.getId());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					cmcmsessions_object.put("name", c.getTitle());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				session_array.put(cmcmsessions_object);
			}
		}
		JSONObject resp = new JSONObject();
		try {
			resp.put("sessions", session_array);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("application/json");
		response.getWriter().write(resp.toString());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
