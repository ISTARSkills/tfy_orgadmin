package tfy.admin.trainer;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes;
import com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes;

import in.orgadmin.utils.report.CustomReportUtils;

public class TaskCardFactoryRecruitment {
	SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
	DBUTILS util = new DBUTILS();

	/*
	 * stageNames.add("Telephonic Interview"); stageNames.add("Trainer SignUp");
	 * stageNames.add("Trainer Assessment"); stageNames.add("SME Interview");
	 * stageNames.add("Demo"); stageNames.add("Fitment Interview");
	 */

	public StringBuffer showTrainerProfileCard(int trainerId) {
		IstarUser user = new IstarUserDAO().findById(trainerId);
		StringBuffer sb = new StringBuffer();
		CustomReportUtils repUtil = new CustomReportUtils();

		sb.append("<div class='product-box  ' style='    margin-bottom: 20px;'>			"
				+ "	<div class='ibox' style='height: 100%;margin-bottom: 0px !important; '> "
				+ "<div class='ibox-title'><h5>Profile Details</h5></div>"
				+ "<div class='ibox-content ' style='height: 100%; min-height:500px'> ");
		// sb.append("<small>You have "+cp.getEventsToday().size() +" events and
		// "+cp.getNotificationsValid()+" notifications.</small> ");
		sb.append("<ul class='list-group clear-list m-t'>  ");
		String[] class1 = { "primary", "information", "success", "warning", "danger" };

		sb.append(
				"<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>" + "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>Gender</b></div>" + "<div class='col-md-8	 no-padding'>"
				+ user.getUserProfile().getGender() + "</div></div>");
		sb.append("</li>");
		sb.append(
				"<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>" + "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>UG Degree</b></div>" + "<div class='col-md-8	 no-padding'>"
				+ user.getProfessionalProfile().getUnderGraduateDegreeName() + "</div></div>");
		sb.append("</li>");
		sb.append(
				"<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>" + "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>PG Degree</b></div>" + "<div class='col-md-8	 no-padding'>"
				+ user.getProfessionalProfile().getPgDegreeName() + "</div></div>");
		sb.append("</li>");
		sb.append(
				"<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>" + "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>Experience</b></div>" + "<div class='col-md-8	 no-padding'>"
				+ user.getProfessionalProfile().getExpereinceInYears() + " years "
				+ user.getProfessionalProfile().getExperienceInMonths() + " months</div></div>");
		sb.append("</li>");
		String interestedCourses = "";
		String getAlreadySelectedInterestedCourse = "select string_agg(distinct course_name,', ') as courses from trainer_intrested_course, course where trainer_intrested_course.course_id = course.id and trainer_id = "
				+ user.getId();
		List<HashMap<String, Object>> selectedIntrested = util.executeQuery(getAlreadySelectedInterestedCourse);
		for (HashMap<String, Object> row : selectedIntrested) {
			interestedCourses = row.get("courses").toString();
		}

		sb.append(
				"<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>" + "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>Interested  Courses</b></div>"
				+ "<div class='col-md-7	 no-padding'>" + interestedCourses + "</div></div>");
		sb.append("</li>");

		sb.append(
				"<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>" + "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-8 no-padding'><h3>Available Days and Time Slots</h3></div>"
				+ "<div class='col-md-3	 no-padding'></div></div>");
		sb.append("</li>");

		String sql = repUtil.getReport(44).getSql().replace(":trainer_id", user.getId() + "");
		List<HashMap<String, Object>> timeSlots = util.executeQuery(sql);
		for (HashMap<String, Object> row : timeSlots) {
			sb.append(
					"<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
			sb.append("<div class='row'>" + "<div class='col-md-1  no-padding'></div>"
					+ "<div class='col-md-3 no-padding'><b>" + row.get("day") + "</b></div>"
					+ "<div class='col-md-8	 no-padding'>"
					+ row.get("time_slots").toString().replaceAll("- 9am, 9am -", "-").replaceAll("- 10am, 10am -", "-")
							.replaceAll("- 11am, 11am -", "-").replaceAll("- 12pm, 12pm -", "-")
							.replaceAll("- 1pm, 1pm -", "-").replaceAll("- 2pm, 2pm -", "-")
							.replaceAll("- 3pm, 3pm -", "-").replaceAll("- 4pm, 4pm -", "-")
							.replaceAll("- 5pm, 5pm -", "-").replaceAll(", $", "")
					+ "</div></div>");
			sb.append("</li>");
		}

		sql = "select distinct trainer_empanelment_status.trainer_id, string_agg(distinct cluster_name,', ') as clusters from trainer_empanelment_status left join trainer_prefred_location on (trainer_empanelment_status.trainer_id =  trainer_prefred_location.trainer_id) left join pincode on (pincode.pin =  trainer_prefred_location.pincode) left join cluster_pincode_mapping on (cluster_pincode_mapping.pincode_id = pincode.id) left join cluster on (cluster.id = cluster_pincode_mapping.cluster_id) where trainer_empanelment_status.trainer_id="
				+ trainerId + " group by trainer_empanelment_status.trainer_id";

		List<HashMap<String, Object>> clusters = util.executeQuery(sql);

		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'>      "
				+ "<div class='row'><div class='col-md-1  no-padding'></div><div class='col-md-3 no-padding'><h3>Clusters</h3></div><div class='col-md-7 no-padding'>");
		for (HashMap<String, Object> row : clusters) {

			if (row.get("clusters") != null && !row.get("clusters").toString().equalsIgnoreCase("")) {
				String[] clustersData = row.get("clusters").toString().split(",");
				for (String cluster : clustersData) {
					if (!cluster.equalsIgnoreCase(""))
						sb.append("<button class='btn btn-white btn-xs m-b-xs m-r-xs' type='button'>" + cluster
								+ "</button>");
				}
			}else{
				sb.append("<button class='btn btn-white btn-xs m-b-xs m-r-xs' type='button'>N/A</button>");
			}
		}
		sb.append("</div></div></li>");

		sb.append("</ul>                                                                                    ");
		sb.append(
				"</div> </div> </div>                                                                                   ");

		return sb;
	}

	public StringBuffer showSummaryCard(int trainerID) {
		String empanelmentData = "SELECT course. ID, course.course_name FROM trainer_intrested_course, course WHERE trainer_intrested_course.trainer_id = "
				+ trainerID + " AND course. ID = trainer_intrested_course.course_id ";
		List<HashMap<String, Object>> data = util.executeQuery(empanelmentData);
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='product-box' style='    margin-top: -26px;' >                                        ");
		sb.append(
				" <div class='ibox' style='height: 100%;margin-bottom: -10px;>                                            ");
		sb.append(" <div class='ibox-content h-370 no-padding' style='height: 100%;'>                  ");
		sb.append(
				" <div class='task-complete-header' style='background-color:#eb384f;    color: white;'>                 ");
		sb.append(
				" <h6 class='p-xxs font-normal bg-muted m-l-xs m-t-none'> Placement Summary</h6>                                                 ");
		sb.append(" <h3 class='p-xxs m-l-xs' style='padding:20px;'>" + data.size()
				+ " courses applied.</h3>               ");
		sb.append(" </div>                                                        ");
		sb.append(" <div class='product-desc no-padding' style='margin-top: -10px;'>                         ");
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='ibox-content no-padding content-border'           ");
		sb.append(" id='ibox-content'>                                            ");
		sb.append(
				"<div id='vertical-timeline' class='vertical-container dark-timeline left-orientation'style=' margin-bottom: 10px !important;'>");
		// iterate

		for (HashMap<String, Object> row : data) {

			String getstatus = "select stage, empanelment_status, TP.first_name as trainer_name, IP.first_name as interviewer_name, created_at  from (select created_at, stage, empanelment_status, course_id, trainer_id from trainer_empanelment_status where course_id = "
					+ row.get("id") + " and trainer_id =" + trainerID
					+ " order by id desc limit 1 )T1 left join interview_rating on (interview_rating.trainer_id =T1.trainer_id and T1.course_id =interview_rating.course_id) left join user_profile TP on (interview_rating.trainer_id = TP.user_id) left join user_profile IP on (interview_rating.interviewer_id = IP.user_id) limit 1";
			List<HashMap<String, Object>> statusData = util.executeQuery(getstatus);
			System.err.println(statusData.size() + "---> getstatus -->" + getstatus);
			if (statusData.size() != 0) {
				String taskIcon = "fa fa-desktop";
				String bgStyle = " style='    background-color: #eb384f;color: white Important' ";
				String status = statusData.get(0).get("empanelment_status").toString();
				String stage = statusData.get(0).get("stage").toString();
				String interviewerName = "";
				Timestamp date = (Timestamp) statusData.get(0).get("created_at");
				if (statusData.get(0).get("interviewer_name") != null) {
					interviewerName = "by " + statusData.get(0).get("interviewer_name").toString();
				}
				String score = "";
				if (stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.ASSESSMENT_DONE)) {
					String getScore = "select cast (sum(score) as integer) as user_score, (select cast (count(assessment_question.id) as integer) as total from assessment_question where assessmentid in (select DISTINCT assessment_id from course_assessment_mapping where course_id ="
							+ row.get("id") + "))   from report where user_id = " + trainerID
							+ " and assessment_id in (select DISTINCT assessment_id from course_assessment_mapping where course_id ="
							+ row.get("id") + ")";
					List<HashMap<String, Object>> scoreL3 = util.executeQuery(getScore);
					if (scoreL3.size() > 0 && scoreL3.get(0).get("user_score") != null) {
						score = "with the score " + scoreL3.get(0).get("user_score").toString() + "/"
								+ scoreL3.get(0).get("total").toString();
					}
				} else if (stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.SME_INTERVIEW)
						|| stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.DEMO)
						|| stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.FITMENT_INTERVIEW)) {
					String getScore = "SELECT  CAST (AVG(rating) AS INTEGER) AS rating FROM interview_rating WHERE trainer_id = "
							+ trainerID + " AND course_id = " + row.get("id") + " and stage_type = '" + stage + "'";
					List<HashMap<String, Object>> scoreL3Plus = util.executeQuery(getScore);
					if (scoreL3Plus.size() > 0 && scoreL3Plus.get(0) != null
							&& scoreL3Plus.get(0).get("rating") != null) {
						score = "with the score " + scoreL3Plus.get(0).get("rating").toString() + "/5";
					}
				}

				String title = "The Candidate was <strong>" + StringUtils.capitalize(status) + "</strong>  in stage "
						+ stage + " for the position of " + "Trainer - <strong>"
						+ StringUtils.capitalize(row.get("course_name").toString()) + " " + score + " "
						+ interviewerName + "</strong>  on " + format.format(date) + " </p";

				if (status.equalsIgnoreCase(TrainerEmpanelmentStatusTypes.SELECTED)) {
					taskIcon = "fa fa-check";
					bgStyle = " style='    background-color: #18a689  !important;     color: white !important;' ";
				} else if (status.equalsIgnoreCase(TrainerEmpanelmentStatusTypes.REJECTED)) {
					taskIcon = "fa fa-times";
					bgStyle = " style='    background-color: #ec4758 !important;     color: white !important;' ";
				} else {
					taskIcon = "fa fa-hourglass-end";
					bgStyle = " style='    background-color: #f8ac59 !important;     color: white !important;' ";
				}

				sb.append("<div class='vertical-timeline-block no-padding' style='margin: 1em 0 !important;'>   ");
				sb.append("<div class='vertical-timeline-icon' " + bgStyle + " >       ");
				sb.append("<i class='" + taskIcon + "'></i>                    ");
				sb.append("</div>                                             ");
				sb.append("                                                   ");
				sb.append("<div class='vertical-timeline-content p-xxs'>      ");
				sb.append("<p>" + title + " </p>       ");
				sb.append("                                                   ");
				sb.append("                                                   ");

				sb.append("</div>                                             ");
				sb.append("</div>                                             ");
			}
		}
		sb.append(" </div>");

		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='m-l-lg'>                                          ");

		sb.append(" </div>                                                        ");
		sb.append(" </div>                                                        ");
		sb.append("                                                               ");
		sb.append(" </div>                                                        ");
		sb.append(" </div>                                                        ");
		sb.append("                                                               ");
		sb.append(" </div>                                                        ");
		sb.append(" </div>                                                        ");

		return sb;
	}

	public StringBuffer showCourseCard(int trainerID, int courseID, int interviewerid) {
		Course course = new CourseDAO().findById(courseID);

		StringBuffer sb = new StringBuffer();
		sb.append("<div class='col-lg-4 equalheight2' id='trainer_rating_" + trainerID + "_" + courseID
				+ "' >				");

		sb.append("<div class='card1' id='rate_list_" + courseID + "_" + trainerID
				+ "'>                                                                          ");
		sb.append("<div class='front'>                                                                      ");

		sb.append("<div class='ibox-title'><h5>" + course.getCourseName() + "</h5> "
				+ "<div class='ibox-tools'><span class='label label-info pull-right reverse_view'><i class='fa fa-exchange'></i></span></div>"
				+ "</div>");
		sb.append(
				"<div class='ibox-content product-box' id='ibox-content' style='margin-bottom:20px;'>                                             ");
		sb.append("<div id='vertical-timeline' class='vertical-container dark-timeline '>                   ");

		sb.append(getStatusForL1().toString());
		sb.append(getStatusForL2().toString());

		// l3 starts here
		Boolean L3isCompleted = checkL3Status(trainerID, course);
		sb.append(getStatusForL3(trainerID, course, L3isCompleted));
		if (L3isCompleted != null && L3isCompleted) {

			// l4 starts here
			Boolean L4isCompleted = checkL4Status(trainerID, course);
			sb.append(getStatusForL4(trainerID, course, L4isCompleted));
			if (L4isCompleted != null && L4isCompleted) {

				// l5 starts here
				Boolean L5isCompleted = checkL5Status(trainerID, course);
				sb.append(getStatusForL5(trainerID, course, L5isCompleted));
				if (L5isCompleted != null && L5isCompleted) {

					// l6 starts here
					Boolean L6isCompleted = checkL6Status(trainerID, course);
					sb.append(getStatusForL6(trainerID, course, L6isCompleted));
				}
			}
		}

		String sql1 = "select empanelment_status , stage from trainer_empanelment_status where course_id = " + courseID
				+ " and trainer_id=" + trainerID + " order by id desc limit 1";
		System.err.println(sql1);
		String stage = "";

		List<HashMap<String, Object>> lists = util.executeQuery(sql1);
		if (lists.get(0) != null && lists.get(0).get("stage") != null) {
			stage = lists.get(0).get("stage").toString();
		}

		String stage_string = "";
		switch (stage) {
		case "L1":
			stage_string = "Trainer SignUp";
			break;
		case "L2":
			stage_string = "Trainer Assessment";
			break;
		case "L3":
			stage_string = "SME Interview";
			break;
		case "L4":
			stage_string = "Demo";
			break;
		case "L5":
			stage_string = "Fitment Interview";
			break;
		}

		// feedback
		sb.append("</div></div></div>");
		sb.append("<div class='back'>");
		sb.append("<div class='ibox-title'><h5>Feedback for(" + stage_string + ")</h5> "
				+ "<div class='ibox-tools'><span class='label label-info pull-right reverse_view'><i class='fa fa-exchange'></i></span></div>"
				+ " </div>                                          ");
		sb.append("<div class='ibox-content' id='ibox-content' style='padding:10px !important;'>");

		if (!lists.get(0).get("empanelment_status").toString().equalsIgnoreCase("REJECTED")) {
			switch (stage) {
			case "L3":
				String sql2 = "select id, interview_skill_name from interview_skill where course_id = " + courseID
						+ " and stage_type='L4'";
				List<HashMap<String, Object>> items = util.executeQuery(sql2);
				for (HashMap<String, Object> item : items) {
					sb.append("<div class='row'><div class='col-md-10'>" + item.get("interview_skill_name") + "</div>");
					sb.append("<div class='rateYo col-md-2' data-course_id='" + courseID + "' data-user_id='"
							+ trainerID + "' data-skill_id='" + item.get("id") + "' " + " data-interviewer_id='"
							+ interviewerid
							+ "' data-stage='L4' ></div> </div>                                                               ");
				}
				sb.append("<div class='row p-xl'><textarea rows='4' cols='50' style='margin-top:10px;' id='comments_"
						+ trainerID + "_" + courseID + "' tool-tip='comments here' >");
				sb.append("</textarea></div>");

				sb.append("<div class='row'><div class='col-md-8'>");
				sb.append(" <div class='i-checks'><label> <input type='checkbox' value='SELECTED' id='selected_"
						+ trainerID + "_" + courseID + "' > <i></i> Selected </label></div>");
				sb.append("</div><div class='col-md-4'>");
				sb.append("<button data-_holer_id='trainer_rating_" + trainerID + "_" + courseID
						+ "' class='btn btn-primary submit_feedback pull-right btn-xs' data-course_id='" + courseID
						+ "' data-user_id='" + trainerID + "' " + " data-stage='L4' data-interviewer_id='"
						+ interviewerid + "' type='button'>Submit</button></div></div>");

				break;

			case "L4":
				String sql3 = "select id, interview_skill_name from interview_skill where  stage_type='L5'";
				List<HashMap<String, Object>> items1 = util.executeQuery(sql3);
				for (HashMap<String, Object> item : items1) {
					sb.append("<div class='row'><div class='col-md-10'>" + item.get("interview_skill_name") + "</div>");
					sb.append("<div class='rateYo col-md-2' data-course_id='" + courseID + "' data-user_id='"
							+ trainerID + "' data-skill_id='" + item.get("id") + "' " + " data-interviewer_id='"
							+ interviewerid + "' data-stage='L5' ></div> </div>");

				}
				sb.append("<div class='row'><textarea rows='4' cols='50' style='margin-top:10px;' id='comments_"
						+ trainerID + "_" + courseID + "' tool-tip='comments here'>");
				sb.append("</textarea></div>");

				sb.append("<div class='row p-xl'><div class='col-md-8'>");
				sb.append(" <div class='i-checks'><label> <input type='checkbox' value='SELECTED' id='selected_"
						+ trainerID + "_" + courseID + "' > <i></i> Selected </label></div>");
				sb.append("</div><div class='col-md-4'>");
				sb.append("<button data-_holer_id='trainer_rating_" + trainerID + "_" + courseID
						+ "' class='btn btn-primary submit_feedback pull-right btn-xs' data-course_id='" + courseID
						+ "' data-user_id='" + trainerID + "' " + "data-stage='L5' data-interviewer_id='"
						+ interviewerid + "' type='button'>Submit</button></div></div>");
				break;
			case "L5":
				String sql4 = "select id, interview_skill_name from interview_skill where stage_type='L6'";
				List<HashMap<String, Object>> items2 = util.executeQuery(sql4);
				for (HashMap<String, Object> item : items2) {
					sb.append("<div class='row'><div class='col-md-10'>" + item.get("interview_skill_name") + "</div>");
					sb.append("<div class='rateYo col-md-2' data-course_id='" + courseID + "' data-user_id='"
							+ trainerID + "' data-skill_id='" + item.get("id") + "' " + " data-interviewer_id='"
							+ interviewerid + "' data-stage='L6' ></div> </div>        "
							+ "                                                       ");

				}
				sb.append("<div class='row p-xl'><textarea rows='4' cols='50' style='margin-top:10px;' id='comments_"
						+ trainerID + "_" + courseID + "' tool-tip='comments here'>");
				sb.append("</textarea></div>");

				sb.append("<div class='row'><div class='col-md-8'>");
				sb.append(" <div class='i-checks'><label> <input type='checkbox' value='SELECTED' id='selected_"
						+ trainerID + "_" + courseID + "' > <i></i> Selected </label></div>");
				sb.append("</div><div class='col-md-4'>");
				sb.append("<button data-_holer_id='trainer_rating_" + trainerID + "_" + courseID
						+ "' class='btn btn-primary submit_feedback pull-right btn-xs' data-course_id='" + courseID
						+ "' data-user_id='" + trainerID + "' " + " data-stage='L6' data-interviewer_id='"
						+ interviewerid + "' type='button'>Submit</button></div></div>");
				break;
			default:
				break;
			}
		}

		sb.append("</div>");
		sb.append("</div>");
		sb.append("</div>");
		sb.append("</div>");

		return sb;
	}

	private Boolean checkL3Status(int trainerID, Course course) {
		Boolean L3isCompled = null;
		String sql = "select * from task where actor=" + trainerID
				+ " and item_type='ASSESSMENT' and item_id in (select assessment_id from course_assessment_mapping where course_id="
				+ course.getId()
				+ " UNION 	SELECT  CAST (regexp_split_to_table(constant_properties.property_value,E',') AS INTEGER) FROM constant_properties 	WHERE constant_properties.property_name = 'default_assessment_for_trainer')";

		List<HashMap<String, Object>> list = util.executeQuery(sql);
		for (HashMap<String, Object> item : list) {
			if (item.get("state").toString().equalsIgnoreCase("COMPLETED")) {
				L3isCompled = true;
			} else {
				L3isCompled = null;
				break;
			}
		}
		return L3isCompled;
	}

	private Boolean checkL4Status(int trainerID, Course course) {
		Boolean isCompled = null;

		String sql = "select * from trainer_empanelment_status where trainer_empanelment_status.trainer_id=" + trainerID
				+ "  and trainer_empanelment_status.course_id=" + course.getId() + " and stage='L4'";
		List<HashMap<String, Object>> list = util.executeQuery(sql);

		for (HashMap<String, Object> item : list) {
			if (item.get("empanelment_status").toString().equalsIgnoreCase("SELECTED")) {
				isCompled = true;
			} else {
				isCompled = false;
				break;
			}
		}

		return isCompled;
	}

	private Boolean checkL5Status(int trainerID, Course course) {
		Boolean isCompled = null;

		String sql = "select * from trainer_empanelment_status where trainer_empanelment_status.trainer_id=" + trainerID
				+ "  and trainer_empanelment_status.course_id=" + course.getId() + " and stage='L5'";
		List<HashMap<String, Object>> list = util.executeQuery(sql);
		for (HashMap<String, Object> item : list) {
			if (item.get("empanelment_status").toString().equalsIgnoreCase("SELECTED")) {
				isCompled = true;
			} else {
				isCompled = false;
				break;
			}
		}
		return isCompled;
	}

	private Boolean checkL6Status(int trainerID, Course course) {
		Boolean isCompled = null;
		String sql = "select * from trainer_empanelment_status where trainer_empanelment_status.trainer_id=" + trainerID
				+ "  and trainer_empanelment_status.course_id=" + course.getId() + " and stage='L6'";
		List<HashMap<String, Object>> list = util.executeQuery(sql);
		for (HashMap<String, Object> item : list) {
			if (item.get("empanelment_status").toString().equalsIgnoreCase("SELECTED")) {
				isCompled = true;
			} else {
				isCompled = false;
				break;
			}
		}
		return isCompled;
	}

	private StringBuffer getStatusForL1() {
		StringBuffer out = new StringBuffer();
		out.append(
				"<div class='vertical-timeline-block no-padding' style='margin: 1em 0px !important; backface-visibility: hidden;'>");
		out.append(
				"<div class='vertical-timeline-icon' style='background-color: rgb(24, 166, 137) !important; color: white !important; backface-visibility: hidden;'>");
		out.append("<i class='fa fa-check' style='backface-visibility: hidden;'></i>");
		out.append("</div>");
		out.append("<div class='vertical-timeline-content p-xxs' style='backface-visibility: hidden;'>");
		out.append("<h3 style='backface-visibility: hidden;'>Telephonic Interview (L1)</h3>");
		out.append("<p style='backface- visibility: hidden;'>Candidate successfully cleared stage L1.</p>");
		out.append("</div>");
		out.append("</div>");
		// TODO Auto-generated method stub
		return out;
	}

	private StringBuffer getStatusForL2() {
		StringBuffer out = new StringBuffer("");
		out.append(
				"<div class='vertical-timeline-block no-padding' style='margin: 1em 0px !important; backface-visibility: hidden;'>");
		out.append(
				"<div class='vertical-timeline-icon' style='background-color: rgb(24, 166, 137) !important; color: white !important; backface-visibility: hidden;'>");
		out.append("<i class='fa fa-check' style='backface-visibility: hidden;'></i>");
		out.append("</div>");
		out.append("<div class='vertical-timeline-content p-xxs' style='backface-visibility: hidden;'>");
		out.append("<h3 style='backface-visibility: hidden;'>Trainer SignUp (L2)</h3>");

		out.append("<p style='backface- visibility: hidden;'>Candidate Successfully cleared stage L2.</p>");

		out.append("</div>");
		out.append("</div>");
		return out;
	}

	private StringBuffer getStatusForL3(int trainerID, Course course, Boolean isCompleted) {

		String bgclolor = (isCompleted != null ? (isCompleted ? "rgb(24, 166, 137)" : "rgb(235, 56, 79)")
				: "rgb(232, 216, 19)");
		String timeLineIcon = (isCompleted != null ? (isCompleted ? "fa fa-check" : "fa fa-times")
				: "fa fa-hourglass-end");
		StringBuffer out = new StringBuffer();
		out.append(
				"<div class='vertical-timeline-block no-padding' style='margin: 1em 0px !important; backface-visibility: hidden;'>");
		out.append("<div class='vertical-timeline-icon' style='background-color: " + bgclolor
				+ "!important; color: white !important; backface-visibility: hidden;'>");
		out.append("<i class='" + timeLineIcon + "' style='backface-visibility: hidden;'></i>");
		out.append("</div>");

		out.append("<div class='vertical-timeline-content p-xxs' style='backface-visibility: hidden;'>");
		out.append("<h3 style='backface-visibility: hidden;'>Trainer Assessment (L3)</h3>");

		if (isCompleted != null) {
			if (isCompleted)
				out.append("<p style='backface- visibility: hidden;'>Candidate Successfully cleared stage L3.</p>");
			else
				out.append("<p style='backface- visibility: hidden;'>Candidate Rejected in stage L3.</p>");
		} else {
			out.append(
					"<p style='backface- visibility: hidden;'>Candidate Pending Trainer Assessment hence not cleared stage L3.</p>");
		}

		// assessment list
		String sql = "SELECT 	task.id as task_id,task.item_id,assessment.assessmenttitle,task.state FROM 	task,assessment WHERE 	actor = "
				+ trainerID
				+ " AND item_type = 'ASSESSMENT' AND  item_id IN ( 	SELECT 		assessment_id 	FROM 		course_assessment_mapping 	WHERE 		course_id = "
				+ course.getId()
				+ " union SELECT     CAST(regexp_split_to_table(constant_properties.property_value, E',') AS INTEGER) FROM constant_properties where constant_properties.property_name='default_assessment_for_trainer' ) and task.item_id=assessment.id and task.state='COMPLETED'";
		System.err.println(sql);
		List<HashMap<String, Object>> list = util.executeQuery(sql);
		for (HashMap<String, Object> item : list) {
			out.append(
					"<a target='_blank' class='btn btn-outline btn-warning btn-xs pull-right m-r-xs' href='/coordinator/assessment_report.jsp?assessment_id="
							+ item.get("item_id") + "&user_id=" + trainerID + "'>" + item.get("assessmenttitle")
							+ "</a>");

		}

		out.append("</div>");
		out.append("</div>");

		return out;
	}

	private StringBuffer getStatusForL4(int trainerID, Course course, Boolean isCompleted) {

		String bgclolor = (isCompleted != null ? (isCompleted ? "rgb(24, 166, 137)" : "rgb(235, 56, 79)")
				: "rgb(232, 216, 19)");
		String timeLineIcon = (isCompleted != null ? (isCompleted ? "fa fa-check" : "fa fa-times")
				: "fa fa-hourglass-end");

		StringBuffer out = new StringBuffer();
		out.append(
				"<div class='vertical-timeline-block no-padding' style='margin: 1em 0px !important; backface-visibility: hidden;'>");
		out.append("<div class='vertical-timeline-icon' style='background-color: " + bgclolor
				+ "!important; color: white !important; backface-visibility: hidden;'>");
		out.append("<i class='" + timeLineIcon + "' style='backface-visibility: hidden;'></i>");
		out.append("</div>");
		out.append("<div class='vertical-timeline-content p-xxs' style='backface-visibility: hidden;'>");
		out.append("<h3 style='backface-visibility: hidden;'>SME Interview (L4)</h3>");

		if (isCompleted != null) {
			if (isCompleted)
				out.append("<p style='backface- visibility: hidden;'>Candidate Successfully cleared stage L4.</p>");
			else
				out.append("<p style='backface- visibility: hidden;'>Candidate Rejected in stage L4.</p>");
		} else {
			out.append(
					"<p style='backface- visibility: hidden;'>Candidate Pending SME Interview hence not cleared stage L4.</p>");
		}

		if (isCompleted != null) {
			out.append(
					"<a target='_blank' class='btn btn-outline btn-warning btn-xs pull-right m-r-xs' href='/coordinator/interview_details.jsp?stage=L4"
							+ "&course_id=" + course.getId() + "&user_id=" + trainerID + "'>" + "Trainer Interview Info"
							+ "</a>");
		}

		out.append("</div>");
		out.append("</div>");

		return out;
	}

	private StringBuffer getStatusForL5(int trainerID, Course course, Boolean isCompleted) {

		String bgclolor = (isCompleted != null ? (isCompleted ? "rgb(24, 166, 137)" : "rgb(235, 56, 79)")
				: "rgb(232, 216, 19)");
		String timeLineIcon = (isCompleted != null ? (isCompleted ? "fa fa-check" : "fa fa-times")
				: "fa fa-hourglass-end");

		StringBuffer out = new StringBuffer();
		out.append(
				"<div class='vertical-timeline-block no-padding' style='margin: 1em 0px !important; backface-visibility: hidden;'>");
		out.append("<div class='vertical-timeline-icon' style='background-color: " + bgclolor
				+ "!important; color: white !important; backface-visibility: hidden;'>");
		out.append("<i class='" + timeLineIcon + "' style='backface-visibility: hidden;'></i>");
		out.append("</div>");
		out.append("<div class='vertical-timeline-content p-xxs' style='backface-visibility: hidden;'>");
		out.append("<h3 style='backface-visibility: hidden;'>Demo (L5)</h3>");

		if (isCompleted != null) {
			if (isCompleted)
				out.append("<p style='backface- visibility: hidden;'>Candidate Successfully cleared stage L5.</p>");
			else
				out.append("<p style='backface- visibility: hidden;'>Candidate Rejected in stage L5.</p>");
		} else {
			out.append(
					"<p style='backface- visibility: hidden;'>Candidate Pending Demo hence not cleared stage L5.</p>");
		}

		if (isCompleted != null) {
			out.append(
					"<a target='_blank' class='btn btn-outline btn-warning btn-xs pull-right m-r-xs' href='/coordinator/interview_details.jsp?stage=L4"
							+ "&course_id=" + course.getId() + "&user_id=" + trainerID + "'>" + "Trainer Demo Report"
							+ "</a>");
		}

		out.append("</div>");
		out.append("</div>");
		return out;
	}

	private StringBuffer getStatusForL6(int trainerID, Course course, Boolean isCompleted) {

		String bgclolor = (isCompleted != null ? (isCompleted ? "rgb(24, 166, 137)" : "rgb(235, 56, 79)")
				: "rgb(232, 216, 19)");
		String timeLineIcon = (isCompleted != null ? (isCompleted ? "fa fa-check" : "fa fa-times")
				: "fa fa-hourglass-end");
		StringBuffer out = new StringBuffer();
		out.append(
				"<div class='vertical-timeline-block no-padding' style='margin: 1em 0px !important; backface-visibility: hidden;'>");
		out.append("<div class='vertical-timeline-icon' style='background-color: " + bgclolor
				+ "!important; color: white !important; backface-visibility: hidden;'>");
		out.append("<i class='" + timeLineIcon + "' style='backface-visibility: hidden;'></i>");
		out.append("</div>");

		out.append("<div class='vertical-timeline-content p-xxs' style='backface-visibility: hidden;'>");
		out.append("<h3 style='backface-visibility: hidden;'>Fitment Interview (L6)</h3>");

		if (isCompleted != null) {
			if (isCompleted)
				out.append("<p style='backface- visibility: hidden;'>Candidate Successfully cleared stage L6.</p>");
			else
				out.append("<p style='backface- visibility: hidden;'>Candidate Rejected in stage L6.</p>");
		} else {
			out.append(
					"<p style='backface- visibility: hidden;'>Candidate Fitment Interview hence not cleared stage L6.</p>");
		}

		if (isCompleted != null) {
			out.append(
					"<a target='_blank' class='btn btn-outline btn-warning btn-xs pull-right m-r-xs' href='/coordinator/interview_details.jsp?stage=L4"
							+ "&course_id=" + course.getId() + "&user_id=" + trainerID + "'>"
							+ "Fitment Interview Report" + "</a>");
		}

		out.append("</div>");
		out.append("</div>");

		return out;
	}

}
