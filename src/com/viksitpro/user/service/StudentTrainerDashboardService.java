package com.viksitpro.user.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.TaskSummaryPOJO;
import com.sun.net.httpserver.Filter;
import com.viksitpro.cms.utilities.URLServices;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TaskItemCategory;

public class StudentTrainerDashboardService {

	public StringBuffer DashBoardCard(ComplexObject cp) throws ParseException {

		StringBuffer out = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		List<TaskSummaryPOJO> taskSummaryPOJOList = cp.getTasks();
		int count = 0;
		try {
			Collections.sort(taskSummaryPOJOList, new Comparator<TaskSummaryPOJO>() {
				public int compare(TaskSummaryPOJO o1, TaskSummaryPOJO o2) {
					if (o1.getDate() == null) {
						return (o2.getId() == null) ? 0 : 1;
					}
					if (o2.getDate() == null) {
						return -1;
					}
					return o2.getDate().compareTo(o1.getDate());
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
		List<TaskSummaryPOJO> filteredList = new ArrayList<>();

		for (TaskSummaryPOJO task : taskSummaryPOJOList) {
			// System.out.println("task.getStatus() "+task.getStatus());
			if (!task.getStatus().equalsIgnoreCase("COMPLETED")) {
				//System.out.println("today date" + task.getDate());
				//System.out.println("today itemType " + task.getItemType());
				if ((sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) == 0)
						&& (task.getItemType().equalsIgnoreCase(TaskItemCategory.CLASSROOM_SESSION_STUDENT)
								|| task.getItemType().equalsIgnoreCase(TaskItemCategory.REMOTE_CLASS_STUDENT)
								|| task.getItemType().equalsIgnoreCase(TaskItemCategory.WEBINAR_STUDENT)
								|| task.getItemType().equalsIgnoreCase(TaskItemCategory.WEBINAR_TRAINER)
								|| task.getItemType().equalsIgnoreCase(TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWEE)
								|| task.getItemType().equalsIgnoreCase(TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWER))) {

					filteredList.add(task);

				}
			}
		}

		for (TaskSummaryPOJO task : taskSummaryPOJOList) {
			if (!(sdf.parse(sdf.format(task.getDate())).compareTo(sdf.parse(sdf.format(new Date()))) > 0)
					&& !task.getStatus().equalsIgnoreCase("COMPLETED")) {
				// System.out.println("previous date " + task.getDate());
				// System.out.println("previous itemType " + task.getItemType());
				if (task.getItemType().equalsIgnoreCase(TaskItemCategory.LESSON_PRESENTATION)
						|| task.getItemType().equalsIgnoreCase(TaskItemCategory.ASSESSMENT)
						|| task.getItemType().equalsIgnoreCase(TaskItemCategory.CUSTOM_TASK)) {

					filteredList.add(task);

				}
			}
		}
		
		

		if (filteredList != null && filteredList.size() != 0) {

			List<List<TaskSummaryPOJO>> partitions = new ArrayList<>();
			int totalcount = 12;
			if( filteredList.size() <= 12) {
				
				totalcount = filteredList.size();
				
			}

			for (int j = 0; j < totalcount; j += 3) {
				partitions.add(filteredList.subList(j, Math.min(j + 3, filteredList.size())));
			}

			int j = 0;

			String temp = "active";
			
			
			out.append("<div class='carousel-inner' role='listbox'>");
			for (List<TaskSummaryPOJO> list : partitions) {
				
				
				out.append("<div class='carousel-item " + (j==0?temp:"") + "' >");
				j++;
				
				out.append("<div class='row custom-no-margins'>");
				for (TaskSummaryPOJO task : list) {
					
					String tsakImg = task.getImageURL();
					String url = "";
					String courseName = "";
					String taskName = "";
					String taskIcon = "/assets/images/presentation-icon.png";
					if(task.getHeader().trim().length() >17) {
						courseName = task.getHeader().toUpperCase().substring(0,18)+"..."; 
						}else {
							courseName = task.getHeader().toUpperCase();
							
						}
					if(task.getTitle().trim().length() >25) {
						taskName = task.getTitle().substring(0,25)+"..."; 
						}else {
							taskName = task.getTitle();							
						}
					
					if(task.getItemType().equalsIgnoreCase("ASSESSMENT")) {
						URLServices services = new URLServices();
						String cdnPath = services.getAnyProp("cdn_path");
						tsakImg = cdnPath+"course_images/assessment.png";	
						url = "#";
						taskIcon = "/assets/images/ic_assignment_white_48dp.png";//
					}
					else if(task.getItemType().equalsIgnoreCase("LESSON_PRESENTATION")) {
						url = "/student/presentation.jsp?task_id="+task.getId()+"&lesson_id="+task.getItemId();	
						taskIcon = "/assets/images/presentation-icon.png";
					}
					else if(task.getItemType().equalsIgnoreCase("CUSTOM_TASK")) {
						url = "#";	
						taskIcon = "/assets/images/presentation-icon.png";
					}
					out.append("<div class='col custom-no-padding custom-colmd-css'>");
					out.append("<div class='card custom-cards_css'>");

					out.append("<h6 class='card-subtitle custom-card-subtitle mb-2 text-muted popover-dismiss' data-toggle='popover' data-trigger='hover' data-placement='top' data-content='"+task.getHeader().toUpperCase()+"'>"
							+ courseName + "</h6>");
					out.append("<h4 class='card-title custom-card-title popover-dismiss' data-toggle='popover' data-trigger='hover' data-placement='top' data-content='"+task.getTitle()+"'>" + task.getTitle() + "</h4>");
					out.append("<img class='card-img-top custom-primary-img' src='" + tsakImg + "' alt='No Image Available'>");
					String descriptionText = task.getDescription();
					if(task.getDescription() == null || task.getDescription().equalsIgnoreCase("") || task.getDescription().equalsIgnoreCase("null")) {
						
						descriptionText = "Description Not Available";
					}
					out.append("<p class='card-text custom-card-text'>" + descriptionText + "</p>");
					out.append("<a href='"+url+"' class='btn btn-danger custom-primary-btn btn-round-lg btn-lg'><img class='card-img-top custom-secoundary-img'src='"+taskIcon+"' alt=''><span class='custom-primary-btn-text'>"
									+ task.getItemType().replaceAll("_", " ").replaceAll("LESSON", "WATCH").replaceAll("ASSESSMENT", "START ASSESSMENT") + "</span></a>");
					out.append("</div></div>");
				}
				
				out.append("</div></div>");
					
				
			}
			
			out.append("</div>");
			out.append("<a class='carousel-control-next custom-right-prev' href='#carouselExampleControls' role='button' data-slide='next'> <img class='' src='/assets/images/992180-200-copy.png' alt=''> </a> "
					+ "<a class='carousel-control-prev custom-left-prev' href='#carouselExampleControls' role='button' data-slide='prev'> <img class='' src='/assets/images/992180-2001-copy.png' alt=''></a>");			
			
		}else {
			
			out.append("<div class='carousel-inner' role='listbox'>");
			
			out.append("<div class='carousel-item active' >");
			out.append("<div class='row custom-no-margins'>");
			out.append("<div class='col-12 custom-no-padding custom-colmd-css'>");
			out.append("<div class='card custom-cards_css mx-auto'>");
			out.append("<div class='row mx-auto'>");
			out.append("<h1 class=' text-muted text-center mx-auto custom-font-family-tag '>You don�t have any tasks lined up for today.</h4>");
			out.append("</div>");
			out.append("<div class='row mx-auto my-auto'>");
			out.append("<img class='card-img-top custom-notask-imgtag mx-auto' src='/assets/images/zzz_graphic.png' alt=''>");
			out.append("</div>");
			out.append("<div class='row mx-auto'>");
			out.append("<h1 class=' text-muted text-center mx-auto custom-font-family-tag'>Get out and have some fun.</h4>");
			out.append("</div>");

			out.append("</div></div>");
			out.append("</div></div>");
			out.append("</div>");
			
		
		}
		
		
		return out;

	}
	
	public List<HashMap<String, Object>> EventDetailsForCalendar(int event_id) {
		
		DBUTILS util = new DBUTILS();
		String sql = "SELECT 	course.course_name, 	batch_group. NAME as section_name FROM 	batch_schedule_event, 	course, 	batch_group WHERE 	batch_group_code IN "
				+ "( 		SELECT 			batch_group_code 		FROM 			batch_schedule_event 		WHERE 			ID = "+event_id+" 	) "
				+ "AND batch_schedule_event. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND course. ID = batch_schedule_event.course_id AND batch_group. ID = batch_schedule_event.batch_group_id";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;		
	}
	

}
