package com.viksitpro.user.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.android.pojo.ComplexObject;
import com.viksitpro.user.service.UserSkillProfile;


@WebServlet("/get_user_service")
public class UserServiceUtility extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public UserServiceUtility() {
        super();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		StringBuffer out  = new StringBuffer();
		
		if(request.getParameter("skill_id") != null){
			
			System.err.println(">>>> "+request.getParameter("skill_id"));
			UserSkillProfile userSkillProfile = new UserSkillProfile();
			
			int skill_id = 	Integer.parseInt(request.getParameter("skill_id"));
			int user_id = Integer.parseInt(request.getParameter("user_id"));
					
			out.append(userSkillProfile.getSkillTree(skill_id,user_id));
					
			System.err.println(">>>> "+ out.toString());
		}
		
		
	response.getWriter().print(out.toString());
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
