package com.viksitpro.user.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.TaskSummaryPOJO;
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
				System.out.println("today date" + task.getDate());
				System.out.println("today itemType " + task.getItemType());
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

		for (TaskSummaryPOJO task : filteredList) {

			String temp = "active";
			if (count == 0) {
				temp = "active";
			} else {
				temp = "";
			}

			if (count % 3 == 0) {

				out.append("<div class='carousel-item " + temp + "' >");
				out.append("<div class='row custom-no-margins'>");
			}

			out.append("<div class='col-md-4 custom-no-padding custom-colmd-css'>");
			out.append("<div class='card custom-cards_css'>");

			out.append("<h6 class='card-subtitle custom-card-subtitle mb-2 text-muted'>" + task.getHeader() + "</h6>");
			out.append("<h4 class='card-title custom-card-title'>" + task.getTitle().toUpperCase() + "</h4>");
			out.append(
					"<img class='card-img-top custom-primary-img' src='"+task.getImageURL()+"' alt='No Image Available'>");
			out.append("<p class='card-text custom-card-text'>" + task.getDescription() + "</p>");
			out.append(
					"<a href='#' class='btn btn-danger custom-primary-btn '><img class='card-img-top custom-secoundary-img'src='/assets/images/presentation-icon.png' alt=''><span class='custom-primary-btn-text'>"+task.getItemType()+"</span></a>");
			out.append("</div></div>");
			if (count % 3 == 2) {
				out.append("</div></div>");
			}
			count++;

		}

		return out;

	}

}