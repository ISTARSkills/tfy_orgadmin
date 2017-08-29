package com.viksitpro.user.service;

import java.util.ArrayList;
import java.util.List;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.CoursePOJO;

public class UserSkillProfile {
	
	
	public StringBuffer StudentRoles(ComplexObject cp) {
		
		StringBuffer out = new StringBuffer();
		
		if (cp.getCourses() != null && cp.getCourses().size() != 0) {

			List<List<CoursePOJO>> partitions = new ArrayList<>();

			for (int j = 0; j < cp.getCourses().size(); j += 6) {
				partitions.add(cp.getCourses().subList(j, Math.min(j + 6, cp.getCourses().size())));
			}
			
			int j = 0;

			String temp = "active";
			
			for (List<CoursePOJO> list : partitions) {
				out.append("<div class='carousel-item " + (j==0?temp:"") +"'>");
				j++;
				out.append("<div class='row custom-no-margins'>");
				for (CoursePOJO role :list) {
					
					out.append("<div class='col text-center'>");
					out.append(" <img class='img-circle custom-skill-badge-img' src='http://cdn.talentify.in:9999//course_images/6.png' alt='No Image Available'>");
					out.append(" <h3 style='margin: auto;' class='custom-skill-badge-title' >"+role.getName()+"</h3>");	
					out.append(" </div>");
				}
				
				out.append("</div></div>");
			}
			
		}
		
		return out;
		
		
	}
	
	
	

}
