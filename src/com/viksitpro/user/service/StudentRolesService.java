package com.viksitpro.user.service;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.CoursePOJO;
import com.istarindia.android.pojo.TaskSummaryPOJO;

public class StudentRolesService {
	
	
	public StringBuffer StudentRoles(ComplexObject cp) {
		
		StringBuffer out = new StringBuffer();
		
		
		if (cp.getCourses() != null && cp.getCourses().size() != 0) {

			List<List<CoursePOJO>> partitions = new ArrayList<>();

			for (int j = 0; j < cp.getCourses().size(); j += 3) {
				partitions.add(cp.getCourses().subList(j, Math.min(j + 3, cp.getCourses().size())));
			}
			
			for (List<CoursePOJO> list : partitions) {
				out.append("<div class='row custom-margin-rolescard'>");
				out.append("<div class='card-deck'>");
				for (CoursePOJO role :list) {
					
					out.append("<div class='card custom-roles-cards' data-course_id='"+role.getId()+"'>");
					out.append("<img class='custom-roles-img' src='"+role.getImageURL()+"' alt='No Image Available'>");
					out.append("<div class='card-block'>");	
					out.append("<h4 class=' custom-roles-subtitle'>"+role.getCategory()+"</h4>");
					out.append("<h1 class='card-title custom-roles-titletext'>"+role.getName()+"</h1>");
					out.append("<h4 class='custom-roles-progress'>"+role.getMessage()+"</h4>");
					out.append("</div>");
					out.append("<div class='progress custom-progressbar'><div class='progress-bar ' role='progressbar' style='width: "+role.getProgress()+"%' aria-valuenow='"+role.getProgress()+"' aria-valuemin='0' aria-valuemax='100'></div> </div>");
					out.append("</div>");
					
				}
				
				out.append("</div></div>");
			}
			
		}	
		
		return out;
	}
	
	
	

}
