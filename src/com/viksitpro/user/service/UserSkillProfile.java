package com.viksitpro.user.service;

import java.util.ArrayList;
import java.util.List;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.CoursePOJO;
import com.istarindia.android.pojo.ModulePOJO;
import com.istarindia.android.pojo.SkillReportPOJO;

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
				out.append("<div class='carousel-item " + (j == 0 ? temp : "") + "'>");
				j++;
				out.append("<div class='row custom-no-margins'>");
				for (CoursePOJO role : list) {

					out.append("<div class='col text-center'>");
					out.append(
							" <img class='img-circle custom-skill-badge-img' src='http://cdn.talentify.in:9999//course_images/6.png' alt='No Image Available'>");
					out.append(
							" <h3 style='margin: auto;' class='custom-skill-badge-title' >" + role.getName() + "</h3>");
					out.append(" </div>");
				}

				out.append("</div></div>");
			}

		}

		return out;

	}
	
	public StringBuffer getSkillList(ComplexObject cp) {
	
		StringBuffer out = new StringBuffer();
		int count = 0 ;
		String parentactiveclass ="";
		String childactiveclass ="";
		for(SkillReportPOJO skillobj :cp.getSkills()) {
			
			if(count == 0) {
				
				parentactiveclass = "skill_list_active active";	
				childactiveclass ="custom-skill-list-active";
				
			}else {
				
				parentactiveclass = "disabled";	
				childactiveclass ="custom-skill-list-disabled";
				
			}
			
			
		
		out.append("<div class='nav-link skill_list "+parentactiveclass+" pt-0 pb-0 pl-0' data-skillId='"+skillobj.getId()+"'>");
		out.append("<div class='card "+childactiveclass+" justify-content-md-center'>");
		out.append("<div class='card-block'>");
		out.append("<div class='row custom-no-margins'>");
		out.append("<div class='col-4'>");
		out.append("<img class='img-circle custom-skill-tree-img' src='"+skillobj.getImageURL()+"' alt='No Image Available'>");
		out.append("</div>");
		out.append("<div class='col-8 my-auto'>");
		out.append("<h3 class='custom-skill-tree-title'>"+skillobj.getName()+"</h3>");
		out.append("</div>");
		out.append("</div>");
		out.append("</div>");
		out.append("</div>");
		out.append("</div>");
		
		count++;
	}
		return out;
		
		
	}

	public StringBuffer StudentModuleList(ComplexObject cp, int course_id) {

		StringBuffer out = new StringBuffer();

		

		int count = 0;
		for (CoursePOJO student_course : cp.getCourses()) {
			if (student_course.getId() == course_id) {

				for (ModulePOJO module : student_course.getModules()) {

					out.append("<div id='accordion" + count + "' role='tablist' aria-multiselectable='true'>");
					out.append("<div class='card custom-card-height-expand'>");
					out.append(
							"<div class='card-header custom-module_card-header' role='tab' id='heading" + count + "'>");
					out.append("<div class='row justify-content-md-center mt-3'>");
					out.append("<div class='col-2 my-auto custom-no-padding text-center'>");
					out.append("<img class='img-circle custom-beginskill-module-img' src='" + module.getImageURL()
							+ "' alt='No Image Available'>");
					out.append("</div>");
					out.append("<div class='col-8 my-auto custom-no-padding text-center'>");
					out.append("<div class='row'>");
					out.append("<h1 class='custom-beginskill-module-title'>" + module.getName() + "</h1>");
					out.append("</div>");
					out.append("<div class='row '>");

					for (String skillObj : module.getSkillObjectives()) {

						out.append(
								"<span class='badge badge-pill badge-default custom-beginskill-badge text-center mr-2'>"
										+ skillObj + "</span>");
					}
					out.append("</div>");

					out.append("</div>");

					out.append("<div class='col-2 my-auto custom-no-padding text-center'>");
					out.append("<a data-toggle='collapse' data-parent='#accordion" + count + "' href='#collapse" + count
							+ "' aria-expanded='true' aria-controls='collapse" + count
							+ "'><img class='img-circle custom-beginskill-collapsed-img' src='/assets/images/collapsed.png' alt='No Image Available'></a>");
					out.append("</div>");
					out.append("</div>");
					out.append("</div>");

					out.append("<div id='collapse" + count
							+ "' class='collapse show' role='tabpanel' aria-labelledby='heading" + count + "'>");

					out.append("<div id='carouselExampleControls" + count
							+ "' class='carousel slide'data-interval='false' data-ride='carousel'>");
					out.append("<div class='carousel-inner' role='listbox'>");

					

					for (int i =0; i<3;i++) {
						
						
						out.append("<div class='carousel-item "+(i == 0 ? "active" : "")+"'>");
						out.append("<div class='card-block'>");
						out.append("<div class='row custom-beginskill-row'>");
						out.append("<div class='col-4 my-auto custom-no-padding'>");
						out.append("<div class='card custom-beginskill-lesson-cards-background-left'>");
						out.append("<div class='card-block'>");
						out.append("<h1 class='card-title custom-task-title mt-5'>Direct Tax Skill Work shop Direct Tax</h1>");
						out.append("<h1 class=' ml-2 mr-2'>71%</h1>");
						out.append("<h2>Accuracy</h2>");
						out.append("<p class=' dont-stop-There-is'>Don't stop! There is still room to grow.</p>");
						out.append("</div>");
						out.append("<div class='custom-beginskill-leftbutton'>");
						out.append(
								"<button type='button' class='btn btn-danger custom-beginskill-button'>Improve Score</button>");
						out.append("</div>");
						out.append("</div>");
						out.append("</div>");
						out.append("<div class='col-4 my-auto custom-no-padding text-center'>");
						out.append("<div class='card mb-5 mt-5 custom-beginskill-lesson-cards-forground'>");
						out.append("<div class='card-block '>");
						out.append("<div class='progress'>");
						out.append(
								"<div class='progress-bar' role='progressbar'tyle='width: 25%' aria-valuenow='25' aria-valuemin='0' aria-valuemax='100'></div>");
						out.append("</div>");
						out.append(
								"<h1 class='card-title custom-task-title mt-5 text-center'>Direct Tax Skill Work shop Direct Tax</h1>");
						out.append(
								"<p class='card-text custom-task-desc ml-2 mr-2'>A brief introduction to the various channels of banking operations</p>");
						out.append("<h2 class='take-a-shortcut'>TAKE A SHORTCUT</h2>");
						out.append("</div>");
						out.append("<div class='custom-beginskill-forgroundbutton'>");
						out.append(
								"<button type='button' class='btn btn-danger custom-beginskill-button'>Begin Skill</button>");
						out.append("</div>");
						out.append("</div>");
						out.append("</div>");
						out.append("<div class='col-4 my-auto custom-no-padding'>");
						out.append("<div class='card custom-beginskill-lesson-cards-background-right'>");
						out.append("<div class='card-block text-right'>");
						out.append(
								"<h1 class='card-title custom-task-title mt-5'>Direct Tax Skill Work shop Direct Tax</h1>");
						out.append("<h1 class=' ml-2 mr-2'>71%</h1>");
						out.append("<h2>Accuracy</h2>");
						out.append("<p class=' dont-stop-There-is'>Don't stop! There is still room to grow.</p>");
						out.append("</div>");
						out.append("<div class='custom-beginskill-rightbutton'>");
						out.append(
								"<button type='button' class='btn btn-danger custom-beginskill-button'>Improve Score</button>");
						out.append("</div>");
						out.append("</div>");
						out.append("</div>");
						out.append("</div>");
						out.append("</div>");
						out.append("</div>");

					}
					out.append("</div>");

					out.append("<a class='carousel-control-next custom-right-prev' href='#carouselExampleControls"
							+ count
							+ "' role='button' data-slide='next'> <img class='' src='/assets/images/992180-200-copy.png' alt=''></a>");
					out.append("<a class='carousel-control-prev custom-left-prev' href='#carouselExampleControls"
							+ count
							+ "' role='button' data-slide='prev'> <img class='' src='/assets/images/992180-2001-copy.png' alt=''> </a>");
					out.append("</div>");
					out.append("</div>");

					out.append("</div>");
					out.append("</div>");

					count++;
				}
			}
		}

		return out;
	}

}
