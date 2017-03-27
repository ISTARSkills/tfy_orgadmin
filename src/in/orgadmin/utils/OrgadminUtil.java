/**
 * 
 */
package in.orgadmin.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.hibernate.Query;

import com.istarindia.apps.UserTypes;
import com.istarindia.apps.dao.Batch;
import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.BatchScheduleEvent;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.Course;
import com.istarindia.apps.dao.CourseDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarCoordinator;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.OrgAdmin;
import com.istarindia.apps.dao.Organization;
import com.istarindia.apps.dao.Pincode;
import com.istarindia.apps.dao.PincodeDAO;
import com.istarindia.apps.dao.PlacementOfficer;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.TrainerBatch;
import com.istarindia.apps.dao.TrainerCourse;

/**
 * @author Mayank
 *
 */
public class OrgadminUtil {

	public ArrayList<HashMap<String, String>> getAssessmentListForBatch(Batch b) {
		DBUTILS util = new DBUTILS();
		ArrayList<HashMap<String, String>> data = new ArrayList<>();
		String sql = "SELECT 	lesson.title AS title, 	lesson.dtype AS TYPE, 	cmsession.title AS session_title, 	task.status AS status,  assessment.id as assess_id FROM 	lesson, 	cmsession, 	MODULE, 	course, 	task, assessment WHERE 	lesson.session_id = cmsession. ID AND cmsession.module_id = MODULE . ID AND course. ID = MODULE .course_id AND task.item_id = lesson. ID AND task.status != 'DELETED' AND task.item_type = 'LESSON' AND lesson.dtype != 'sds' AND course. ID = "
				+ b.getCourse().getId()
				+ " and assessment.lesson_id =  lesson.id ORDER BY 	MODULE .order_id, 	cmsession.order_id, 	lesson.order_id  ";
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		for (HashMap<String, Object> row : res) {
			int assessment_id = (int) row.get("assess_id");
			String lesson_title = (String) row.get("title");
			String status = (String)row.get("status");
			String session_tittle = (String) row.get("session_title");
			String finalTile = "Session Title: " + session_tittle + " ,  Assessment Title: " + lesson_title
					+ ", assess_id: " + assessment_id;
			HashMap<String, String> ass_details = new HashMap<>();
			ass_details.put("assess_id", assessment_id + "");
			ass_details.put("title", finalTile);
			ass_details.put("status", status);
			data.add(ass_details);
		}

		return data;
	

	}
	
	
	public ArrayList<HashMap<String, String>> getAllTrainerAssessmentListForBatch() {
		DBUTILS util = new DBUTILS();
		ArrayList<HashMap<String, String>> data = new ArrayList<>();
		String sql = "SELECT DISTINCT 	assessment. ID AS assess_id, 	cmsession.title AS session_title, 	cmsession. ID AS cmsession_id, 	assessment.assessmenttitle FROM 	assessment, 	lesson, 	cmsession	 WHERE 	lesson.session_id = cmsession. ID AND assessment.lesson_id = lesson. ID AND assessment.category='TRAINER_ASSESSMENT' AND lesson.dtype != 'sds' ORDER BY 	assessment. ID, 	cmsession.title";
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		for (HashMap<String, Object> row : res) {
			int assessment_id = (int) row.get("assess_id");
			String lesson_title = (String) row.get("assessmenttitle");
			String session_tittle = (String) row.get("session_title");
			String finalTile = "Session Title: " + session_tittle + " ,  Assessment Title: " + lesson_title
					+ ", assess_id: " + assessment_id;
			HashMap<String, String> ass_details = new HashMap<>();
			ass_details.put("assess_id", assessment_id + "");
			ass_details.put("title", finalTile);
			data.add(ass_details);
		}

		return data;
		
		
		
		

	}

	@SuppressWarnings("unchecked")
	public ArrayList<College> getOrgInFilter(IstarUser user, String baseURl) {
		
		ArrayList<College> colleges= new ArrayList<>();
		

		if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")
				|| user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR")) {
			
			colleges = (ArrayList<College>)new CollegeDAO().findAll();
			
		}
		else if(user.getUserType().equalsIgnoreCase("ORG_ADMIN"))
		{
				OrgAdmin orgadmin = (OrgAdmin)user;
				
				colleges.add(orgadmin.getCollege());
		}
		else if(user.getUserType().equalsIgnoreCase("PlacementOfficer")){
			PlacementOfficer placementOfficer = (PlacementOfficer) user;
			colleges.add(placementOfficer.getCollege());			
		}
	
		return colleges;
		}
		
		
	

	
	public StringBuffer getOrgInHeader(IstarUser user, String baseURl) {
		StringBuffer sb = new StringBuffer();
		
		if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")
				|| user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR") ) {
			
			sb.append("<li><a href='"+baseURl+"orgadmin/organization/edit_organization.jsp' >"
					+ "<button class='btn btn-info btn-xs' type='button' onClick='"+baseURl+"orgadmin/organization/edit_organization.jsp'>"
							+ "<i class='fa fa-paste'></i> Add College</button></a></li>");
			sb.append("<li><a href='"+baseURl+"orgadmin/company/create_new_company.jsp' >"
					+ "<button class='btn btn-info btn-xs' type='button' onClick='"+baseURl+"orgadmin/company/create_new_company.jsp'>"
							+ "<i class='fa fa-paste'></i> Add Company</button></a></li>");
			
			sb.append("     <li class='dropdown home-icon'>");
			sb.append("<a class='dropdown-toggle count-info' data-toggle='dropdown' href='#'>");
			
			ArrayList<College> orgss = getOrgForUser(user);
			sb.append(
					"<i class='fa fa-university'></i>  <span class='label label-primary'>" + orgss.size() + "</span>");
			sb.append("   </a>");
			sb.append("<ul class='dropdown-menu dropdown-alerts'>");
			for (Organization org : orgss) {
				sb.append("  <li>" + "      <a href='" + baseURl + "update_org_insession?org_id=" + org.getId() + "'>"
						+ "        <div>" + "          <i class='fa fa-envelope fa-fw'></i>" + org.getName()
						// + " <span class='pull-right text-muted small'>4
						// minutes ago</span>"
						+ "  </div>" + " </a>" + "</li>" + "<li class='divider'></li>");

			}
			sb.append("</ul>");
			sb.append("  </li>");
		} else if(user.getUserType().equalsIgnoreCase("ORG_ADMIN")) {
			
			sb.append("     <li class='dropdown'>");
			sb.append("<a class='dropdown-toggle count-info' data-toggle='dropdown' href='#'>");
			
			ArrayList<College> orgss = getOrgForUser(user);
			sb.append(
					"<i class='fa fa-university'></i>  <span class='label label-primary'>" + orgss.size() + "</span>");
			sb.append("   </a>");
			sb.append("<ul class='dropdown-menu dropdown-alerts'>");
			for (Organization org : orgss) {
				sb.append("  <li>" + "      <a href='" + baseURl + "update_org_insession?org_id=" + org.getId() + "'>"
						+ "        <div>" + "          <i class='fa fa-envelope fa-fw'></i>" + org.getName()
						// + " <span class='pull-right text-muted small'>4
						// minutes ago</span>"
						+ "  </div>" + " </a>" + "</li>" + "<li class='divider'></li>");
				
			}
			sb.append("</ul>");
			sb.append("  </li>");

		}
		
		
		
		return sb;

	}

	public StringBuffer getCourseLink(IstarUser user, String baseURL) {
		StringBuffer sb = new StringBuffer();
		if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")
				|| user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR")) {
			sb.append("	 <li>"
					+ "<a href='#'><i class='fa fa-bar-chart-o'></i> <span class='nav-label'>Courses</span><span class='fa arrow'></span></a>"
					+ " <ul class='nav nav-second-level collapse'>");

			for (Course c : getCourseForUser(user)) {

				sb.append("<li><a href='" + baseURL + "orgadmin/courses/dashboard.jsp?course_id=" + c.getId() + "'>"
						+ c.getCourseName() + "</a></li>");

			}

			sb.append("</ul> </li>");
		}

		return sb;
	}

	public StringBuffer getTrinerLink(String baseURL, IstarUser user) {
		StringBuffer sb = new StringBuffer();
		if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")
				|| user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR")) {
			sb.append("<li>" + "<a href='" + baseURL
					+ "orgadmin/trainer/trainer_list.jsp'><i class='fa fa-bar-chart-o'></i> <span class='nav-label'>Trainers</span></a>"
					+ "           </li>");
		}

		return sb;
	}

	public ArrayList<Student> getTrainersForUser(IstarUser user) {

		return (ArrayList<Student>) new StudentDAO().findByUserType("TRAINER");

	}

	public ArrayList<College> getOrgForUser(IstarUser user) {
		ArrayList<College> orgs = new ArrayList<>();
		if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")) {
			orgs = (ArrayList<College>) new CollegeDAO().findAll();
		} else if (user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR")) {
			IstarCoordinator u = (IstarCoordinator) user;
			orgs.add(u.getCollege());
		} else if (user.getUserType().equalsIgnoreCase("ORG_ADMIN")) {
			OrgAdmin u = (OrgAdmin) user;
			orgs.add(u.getCollege());
		}

		return orgs;

	}

	public ArrayList<Course> getCourseForUser(IstarUser user) {
		ArrayList<Course> courses = new ArrayList<>();
		if (user.getUserType().equalsIgnoreCase("SUPER_ADMIN")) {
			courses = (ArrayList<Course>) new CourseDAO().findAll();
		} else if (user.getUserType().equalsIgnoreCase("ISTAR_COORDINATOR")) {

			IstarCoordinator u = (IstarCoordinator) user;
			for (BatchGroup bg : u.getCollege().getBatchGroups()) {
				for (Batch b : bg.getBatchs()) {
					if (!courses.contains(b.getCourse())) {
						courses.add(b.getCourse());
					}

				}
			}

		}

		return courses;
	}

	public int completionStatus(Batch b) {
		int last_lesson = -99;
		DBUTILS util = new DBUTILS();
		String get_last_lesson = "select lesson_id from event_session_log where batch_id =  " + b.getId()
				+ " order by id desc limit 1;";
		// System.out.println(get_last_lesson);
		List<HashMap<String, Object>> prev_detail = util.executeQuery(get_last_lesson);
		for (HashMap<String, Object> row : prev_detail) {
			last_lesson = (int) row.get("lesson_id");
		}

		int status = 0;
		int completed = 0;
		int total = 0;
		if (last_lesson != -99) {
			String sql = "SELECT 	  lesson.ID FROM 	lesson, 	cmsession, 	MODULE, 	course, 	task WHERE lesson.session_id = cmsession. ID AND cmsession.module_id = MODULE . ID AND course. ID = MODULE .course_id AND task.item_id = lesson. ID AND task.status != 'DELETED' AND task.item_type = 'LESSON' AND course.ID = "
					+ b.getCourse().getId() + " ORDER BY module.order_id, cmsession.order_id, lesson.order_id";
			List<HashMap<String, Object>> res = util.executeQuery(sql);
			for (HashMap<String, Object> row : res) {
				// System.out.println("(int)row.get(id)"+(int)row.get("id"));
				// System.out.println("last_lesson"+last_lesson);
				if ((int) row.get("id") == last_lesson) {
					completed = total;
				} else {
					total++;
				}
			}
			// System.out.println("completed"+completed);
			// System.out.println("total"+total);

			status = (int) (completed * 100 / total);

		}

		return status;
	}

	public int getCompletionStatus(Batch b) {
		int status = 0;
		String sql = "SELECT 	cast(COUNT (*) as integer) FROM 	batch_schedule_event WHERE 	batch_id = " + b.getId()
				+ " and 	event_name NOT LIKE '%TESTING%' AND TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' and CURRENT_TIMESTAMP > eventdate ";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> prev_detail = util.executeQuery(sql);
		status = (int) prev_detail.get(0).get("count");
		status = (status * 100) / 30;
		return status;
	}

	public StringBuffer PrintCourseTrainerList(Course c, String baseURL) {
		StringBuffer sb = new StringBuffer();
		Set<TrainerCourse> results = c.getTrainercourse();
		for (TrainerCourse b : results) {
			sb.append("	<div class='col-lg-3' style='    padding-right: 7px;padding-left: 12px;'>"
					+ "  <div class='contact-box center-version' style='margin-bottom: 6px;'>"

					+ "   <a href='profile.html'>"

					+ "    <img style='width: 59px;height: 61px;' alt='image' class='img-circle' src='" + baseURL
					+ "img/a3.jpg'>"

					+ "  <h3 class='m-b-xs' style='font-size: 11px;'><strong>" + b.getTrainer().getName()
					+ "</strong></h3>" + "  <h3 class='m-b-xs' style='font-size: 10px;'><strong>"
					+ b.getTrainer().getEmail() + "</strong></h3>"
					+ "  <h3 class='m-b-xs' style='font-size: 10px;'><strong>" + b.getTrainer().getMobile()
					+ "</strong></h3>"

					+ " </a>"

					+ " </div>" + " </div>");
		}
		return sb;
	}

	public StringBuffer PrintBatchList(Course c, String baseURL) {
		StringBuffer sb = new StringBuffer();
		IstarUserDAO dao = new IstarUserDAO();
		String hql = "from Batch isss where isss.course=:course_id order by isss.order_id";
		Query query = dao.getSession().createQuery(hql);
		query.setInteger("course_id", c.getId());
		System.err.println("course_id --> "+query.getQueryString());
		List<Batch> results = query.list();

		for (Batch b : results) {
			sb.append(" <tr>"

					+ "          <td class='project-title'>" + "          <a href='#'>" + b.getName()
					+ "-" + b.getId() + "</a>" + "                                          <br/>"
					+ "                                        <small>" + b.getBatchGroup().getCollege().getName()
					+ "</small>" + "                                  </td>"
					+ "                                  <td class='project-completion'>"
					+ "                                        <small>Completion with: " + getCompletionStatus(b)
					+ "%</small>" + "                                      <div class='progress progress-mini'>"
					+ "                                        <div style='width: " + getCompletionStatus(b)
					+ "%;' class='progress-bar'></div>" + "                                  </div>"
					+ "                        </td>" + "                      <td class='project-people'>");

			for (TrainerBatch tb : b.getTrainerBatches()) {
				Student st = tb.getTrainer();
				String image_url = "img/a3.jpg";
				if (st.getImageUrl() != null) {
					image_url = st.getImageUrl();
				}
				sb.append("<a href='" + baseURL + "orgadmin/trainer/dashboard.jsp?trainer_id=" + st.getId()
						+ "'><img title='" + st.getName() + "' alt='" + st.getName() + "' class='img-circle' src='"
						+ baseURL + image_url + "'></a>");
			}
			sb.append("          </td>" + "        <td class='project-actions'>" + "          <a href='" + baseURL
					+ "orgadmin/batch/dashboard.jsp?batch_id=" + b.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
					+ "        <a target='_blank' href='/orgadmin/batch/edit_batch.jsp?batch_id=" + b.getId() +"&course_id=" + c.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-pencil'></i> Edit  </a>" + "  </td>" + "</tr>");
		}

		return sb;
	}

	public List<HashMap<String, Object>> getEventPerCourse(Course c) {
		String sql = "SELECT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	bse.batch_id AS batch_id, 	s. ID AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	student s, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' and B.course_id = "
				+ c.getId() + " ORDER BY 	bse.eventdate ";
		DBUTILS utilss = new DBUTILS();
		List<HashMap<String, Object>> res = utilss.executeQuery(sql);
		return res;
	}

	public List<HashMap<String, Object>> getEventPerBatch(Batch b) {
		String sql = "SELECT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	bse.batch_id AS batch_id, 	s. ID AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	student s, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' and B.id = "
				+ b.getId() + " ORDER BY 	bse.eventdate ";
		DBUTILS utilss = new DBUTILS();
		List<HashMap<String, Object>> res = utilss.executeQuery(sql);
		return res;
	}

	public StringBuffer PrintEventList(Course c, String baseURL) {
		StringBuffer sb = new StringBuffer();
		IstarUserDAO dao = new IstarUserDAO();
		for (Batch b : c.getBatches()) {
			String hql = "from BatchScheduleEvent isss where isss.batch_id=:batch_id order by isss.eventdate desc";
			Query query = dao.getSession().createQuery(hql);
			query.setInteger("course_id", c.getId());
			System.err.println(query.getQueryString());
			List<BatchScheduleEvent> results = query.list();

			for (BatchScheduleEvent be : results) {
				sb.append(" <tr>"

						+ "          <td class='project-title'>" + "          <a href='project_detail.html'>"
						+ be.getEventName() + "</a>" + "                                          <br/>"
						+ "                                        <small>"
						+ be.getClassroom().getCollege().getName() + "</small>"
						+ "                                  </td>"
						+ "                                  <td class='project-completion'>"
						+ "                                        <small>Completion with: " + be.getStatus()
						+ "%</small>" + "                                  </div>" + "                        </td>"
						+ "                      <td class='project-people'>");

				String image_url = "img/a3.jpg";
				if (be.getActor().getImageUrl() != null) {
					image_url = be.getActor().getImageUrl();
				}
				sb.append("<a href=''><img alt='image' class='img-circle' src='" + baseURL + image_url + "'></a>");
				sb.append("          </td>" + "        <td class='project-actions'>"
						+ "          <a href='#' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
						+ "        <a href='#' class='btn btn-primary btn-xs'><i class='fa fa-pencil'></i> Edit </a>"
						+ "  </td>" + "</tr>");
			}
		}

		return sb;
	}

	public StringBuffer PrinSessionList(int course_id, String baseURL) {
		DBUTILS util = new DBUTILS();
		String sql = "SELECT 	lesson. ID AS lesson_id,cmsession.description as session_desc, 	lesson.title AS title, lesson.dtype as type, 	cmsession.title as session_title, 	task.status AS status, 	task.created_at as updated_at FROM 	lesson, 	cmsession, 	MODULE, 	course, 	task WHERE 	lesson.session_id = cmsession. ID AND cmsession.module_id = MODULE . ID AND course. ID = MODULE .course_id AND task.item_id = lesson. ID AND task.status != 'DELETED' AND task.item_type = 'LESSON' AND course. ID = "
				+ course_id + " ORDER BY module.order_id, cmsession.order_id, 	lesson.order_id ";
		// System.out.println(sql);
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		StringBuffer sb = new StringBuffer();
		sb.append("<div class=''><ul class='list-group elements-list'>");
		for (HashMap<String, Object> row : res) {
			String lesson_title = (String) row.get("title");
			String session_title = (String) row.get("session_title");
			String lesson_type = (String) row.get("type");
			String status = (String) row.get("status");
			String session_desc = (String) row.get("session_desc");
			if (lesson_type.equals("sds")) {
				lesson_type = baseURL + "img/custom/ppt.png";
			} else {
				lesson_type = baseURL + "img/custom/exam.png";
			}

			sb.append("<li class='list-group-item'>                                 "
					+ "<a data-toggle='tab' href='#tab-4'>                                     " + " <strong>"
					+ lesson_title + "</strong>" + "<div class='small m-t-xs'>" + "<p class='m-b-xs'>" + session_desc
					+ "</p>" + "<p class='m-b-none'>" + "<i class='fa fa-map-marker'>" + "</i> " + session_title
					+ "</p>" + "<span class='label pull-right label-primary'>" + status + "</span>" + "</div> </a>" + ""
					+ "" + "<img alt='image' style='width: 25px; margin-top: 7px;' src='" + lesson_type + "'>"
					+ "</li>");
		}

		sb.append("   </ul>                    </div>");
		return sb;
	}

	public ArrayList<HashMap<String, Object>> getSessionListForBatch(Batch batch) {
		ArrayList<HashMap<String, Object>> result = new ArrayList<>();

		DBUTILS util = new DBUTILS();
		ArrayList<Integer> delivered_lesson_list = new ArrayList<>();

		String sql = "select distinct lesson_id from event_session_log where batch_id =" + batch.getId()
				+ " and created_at < CURRENT_TIMESTAMP ";
		List<HashMap<String, Object>> lessons_from_log = util.executeQuery(sql);
		for (HashMap<String, Object> row : lessons_from_log) {
			delivered_lesson_list.add((int) row.get("lesson_id"));
		}

		sql = "SELECT 	lesson. ID AS lesson_id,cmsession.description as session_desc, 	lesson.title AS title, lesson.dtype as type, 	cmsession.title as session_title, 	task.status AS status, 	task.created_at as updated_at FROM 	lesson, 	cmsession, 	MODULE, 	course, 	task WHERE 	lesson.session_id = cmsession. ID AND cmsession.module_id = MODULE . ID AND course. ID = MODULE .course_id AND task.item_id = lesson. ID AND task.status != 'DELETED' AND task.item_type = 'LESSON' AND course. ID = "
				+ batch.getCourse().getId() + " ORDER BY module.order_id, cmsession.order_id, 	lesson.order_id ";
		List<HashMap<String, Object>> lessons_in_course = util.executeQuery(sql);

		for (HashMap<String, Object> lesson : lessons_in_course) {
			int lesson_id = (int) lesson.get("lesson_id");
			String lesson_type = (String) lesson.get("type");
			String teaching_staus = "PENDING";

			if (delivered_lesson_list.contains(lesson_id)) {
				teaching_staus = "DELIVERED";
			}

			if (lesson_type.equals("sds")) {
				lesson_type = "img/custom/ppt.png";
			} else {
				lesson_type = "img/custom/exam.png";
			}
			lesson.put("lesson_type", lesson_type);
			lesson.put("teaching_status", teaching_staus);

			result.add(lesson);
		}

		return result;
	}

	public ArrayList<HashMap<String, Object>> getSessionListInCourse(Course course) {
		ArrayList<HashMap<String, Object>> result = new ArrayList<>();

		DBUTILS util = new DBUTILS();

		String sql = "SELECT 	lesson. ID AS lesson_id,cmsession.description as session_desc, 	lesson.title AS title, lesson.dtype as type, 	cmsession.title as session_title, 	task.status AS status, 	task.created_at as updated_at FROM 	lesson, 	cmsession, 	MODULE, 	course, 	task WHERE 	lesson.session_id = cmsession. ID AND cmsession.module_id = MODULE . ID AND course. ID = MODULE .course_id AND task.item_id = lesson. ID AND task.status != 'DELETED' AND task.item_type = 'LESSON' AND course. ID = "
				+ course.getId() + " ORDER BY module.order_id, cmsession.order_id, 	lesson.order_id ";
		List<HashMap<String, Object>> lessons_in_course = util.executeQuery(sql);

		for (HashMap<String, Object> lesson : lessons_in_course) {
			int lesson_id = (int) lesson.get("lesson_id");
			String lesson_type = (String) lesson.get("type");

			if (lesson_type.equals("sds")) {
				lesson_type = "img/custom/ppt.png";
			} else {
				lesson_type = "img/custom/exam.png";
			}
			lesson.put("lesson_type", lesson_type);

			result.add(lesson);
		}

		return result;
	}

	public StringBuffer PrinSessionListForBatch(Batch b, String baseURL) {
		DBUTILS util = new DBUTILS();
		ArrayList<Integer> lesson_list = new ArrayList<>();
		String lesson_from_log = "select distinct lesson_id from event_session_log where batch_id =" + b.getId()
				+ " and created_at < CURRENT_TIMESTAMP ";
		List<HashMap<String, Object>> prev_lesson = util.executeQuery(lesson_from_log);
		for (HashMap<String, Object> row : prev_lesson) {
			lesson_list.add((int) row.get("lesson_id"));
		}

		String sql = "SELECT 	lesson. ID AS lesson_id,cmsession.description as session_desc, 	lesson.title AS title, lesson.dtype as type, 	cmsession.title as session_title, 	task.status AS status, 	task.created_at as updated_at FROM 	lesson, 	cmsession, 	MODULE, 	course, 	task WHERE 	lesson.session_id = cmsession. ID AND cmsession.module_id = MODULE . ID AND course. ID = MODULE .course_id AND task.item_id = lesson. ID AND task.status != 'DELETED' AND task.item_type = 'LESSON' AND course. ID = "
				+ b.getCourse().getId() + " ORDER BY module.order_id, cmsession.order_id, 	lesson.order_id ";
		// System.out.println(sql);
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		StringBuffer sb = new StringBuffer();
		sb.append("<div class=''><ul class='list-group elements-list'>");
		for (HashMap<String, Object> row : res) {
			int lesson_id = (int) row.get("lesson_id");
			String lesson_title = (String) row.get("title");
			String session_title = (String) row.get("session_title");
			String lesson_type = (String) row.get("type");
			String status = (String) row.get("status");
			String session_desc = (String) row.get("session_desc");
			String teaching_staus = "PENDING";
			String li_bg = "#1ab394";
			if (lesson_list.contains(lesson_id)) {
				teaching_staus = "DELIVERED";
				li_bg = "#1a7bb9";
			}
			if (lesson_type.equals("sds")) {
				lesson_type = baseURL + "img/custom/ppt.png";
			} else {
				lesson_type = baseURL + "img/custom/exam.png";
			}

			sb.append("<li class='list-group-item' " + ">                                 "
					+ "<a data-toggle='tab' href='#tab-4'>                                     " + " <strong>"
					+ lesson_title + "</strong>" + "<div class='small m-t-xs'>" + "<p class='m-b-xs'>" + session_desc
					+ "</p>" + "<p class='m-b-none'>" + "<i class='fa fa-map-marker'>" + "</i> " + session_title
					+ "</p>" + "<span class='label pull-right label-primary' style='background-color:" + li_bg + ";'>"
					+ teaching_staus + "</span>" + "<span class='label pull-right label-primary '  >" + status
					+ "</span>" + "</div> </a>" + "" + ""
					+ "<img alt='image' style='width: 25px; margin-top: 7px;' src='" + lesson_type + "'>" + "</li>");
		}

		sb.append("   </ul>                    </div>");
		return sb;
	}

	public StringBuffer getUserInOrganization(int org_id) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "select id as stu_id, name, email, user_type from student where user_type!='PRESENTOR' and organization_id ="
				+ org_id + " order by name";
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("<div class='table-responsive'>			  " + "<table class='table table-striped'>         "
				+ "    <thead>                                 " + "    <tr style='font-size:13px'>             "
				+ "                                            " + "        <th>ID </th>                        "
				+ "        <th>Student</th>                    " + "        <th>Email</th>                    "
				+ "			<th>User Type</th>                         " + "        <th>Select</th>                 "
				+ "    </tr>                                   " + "    </thead>");

		for (HashMap<String, Object> row : data) {
			int id = (int) row.get("stu_id");
			String name = (String) row.get("name");
			String email = (String) row.get("email");
			String user_type = (String) row.get("user_type");
			String check_status = "";

			sb.append("    <tbody>                                 " + "    <tr style='font-size:13px'>             "
					+ "                                            " + "        <td>" + id
					+ "</td>                           " + "		<td>" + name + "</td>                             "
					+ "		<td>" + email + "</td>                             " + "		<td>" + user_type
					+ "</td>                             " + "        <td><input type='checkbox' " + check_status
					+ " class='i-checks' value='" + id + "' name='user_id'></td> "
					+ "    </tr>                                   " + "                                            "
					+ "    </tbody>                                ");

		}

		sb.append("<tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "        <th>ID </th>                        " + "        <th>Student</th>                    "
				+ "        <th>Email</th>                    " + "		<th>Task</th>                         "
				+ "        <th>Select</th>                 "
				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                    " + "</div>                                      ");

		return sb;
	}
	public StringBuffer getUserInbatchGroup(int batch_id) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		
		
		
		String sql = "SELECT 	student.id as stu_id, student.name as name, student.email as email, student.user_type as user_type FROM 	batch_group, 	batch_students,   student WHERE 	"
				+ "batch_students.batch_group_id = batch_group. ID AND batch_group. ID = "+batch_id+" AND batch_students.student_id = student.id";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		
		
	

		sb.append("<div class=' table-responsive'>			  " + "<table class='datatable_report table table-striped'>         "
				+ "    <thead>                                 " + "    <tr style='font-size:13px'>             "
				+ "                                            " + "        <th>ID </th>                        "
				+ "        <th>Student</th>                    " + "        <th>Email</th>                    "
				+ "			<th>User Type</th>                         " + "        <th>Select</th>                 "
				+ "    </tr>                                   " + "    </thead><tbody> ");

		for (HashMap<String, Object> row : data) {
			int id = (int) row.get("stu_id");
			String name = (String) row.get("name");
			String email = (String) row.get("email");
			String user_type = (String) row.get("user_type");
			String check_status = "";

			sb.append("                                    " + "    <tr style='font-size:13px'>             "
					+ "                                            " + "        <td>" + id
					+ "</td>                           " + "		<td>" + name + "</td>                             "
					+ "		<td>" + email + "</td>                             " + "		<td>" + user_type
					+ "</td>                             " + "        <td><input type='checkbox' " + check_status
					+ " class='i-checks' value='" + id + "' name='user_id'></td> "
					+ "    </tr>                                   " + "                                            "
					+ "                                   ");

		}

		sb.append("</tbody> <tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "        <th>ID </th>                        " + "        <th>Student</th>                    "
				+ "        <th>Email</th>                    " + "		<th>Task</th>                         "
				+ "        <th>Select</th>                 "
				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                    " + "</div>                                      ");

		return sb;
	}
	public List<HashMap<String, Object>> getEventPerUser(Student uid) {
		String sql = "SELECT 	eventdate, sum((batch_schedule_event.eventhour*60 + batch_schedule_event.eventminute) )as duration, "
				+ " 	batch.name as batchname,   batch_schedule_event.type,   batch_group.name  as batchgroupname "
				+ "FROM 	batch_schedule_event, 	batch,   batch_group WHERE 	actor_id = "+uid.getId()+" AND batch_schedule_event.batch_id = batch. ID "
				+ "AND batch.batch_group_id = batch_group.id GROUP BY eventdate,batch.name,batch.name,batch_schedule_event.type,batch_group.name  "
				+ "UNION 	"
				+ "SELECT 		eventdate, sum((istar_assessment_event.eventhour*60 + istar_assessment_event.eventminute) )as duration, 		"
				+ "batch.name as batchname,     istar_assessment_event.type, batch_group.name as batchgroupname 	"
				+ "FROM 		istar_assessment_event,  batch, batch_group 	WHERE 		actor_id = "+uid.getId()+" 	AND istar_assessment_event.batch_id = batch. ID   "
				+ "AND batch.batch_group_id = batch_group.id GROUP BY eventdate,batch.name,istar_assessment_event.type,batch_group.name";
		DBUTILS utilss = new DBUTILS();
		System.out.println("------------------cal-------------------------"+sql);
		List<HashMap<String, Object>> res = utilss.executeQuery(sql);
		return res;
	}
	
	/**
	 * Method to get all the User Types for Org Admin
	 * @return ArrayList of all the UserType Names
	 * @author ravy
	 */
public ArrayList<String> getAllUserTypes(){
		
		ArrayList<String> userTypesList = new ArrayList<String>();		

//		userTypesList.add(UserTypes.CONTENT_ADMIN);
		userTypesList.add(UserTypes.TRAINER);
		userTypesList.add(UserTypes.STUDENT);
//		userTypesList.add(UserTypes.CONTENT_CREATOR);
//		userTypesList.add(UserTypes.CONTENT_ADMIN);
//		userTypesList.add(UserTypes.SUPER_ADMIN);
//		userTypesList.add(UserTypes.ISTAR_COORDINATOR);
//		userTypesList.add(UserTypes.CREATIVE_CREATOR);
//		userTypesList.add(UserTypes.CREATIVE_ADMIN);
//		userTypesList.add(UserTypes.CONTENT_REVIEWER);
//		
//		userTypesList.add(UserTypes.ORG_ADMIN);
//		userTypesList.add(UserTypes.RECRUITER);
//		userTypesList.add(UserTypes.PRESENTOR);
		
		return userTypesList;
	}

public StringBuffer getCreateUserLinks(IstarUser user, String baseURL){
	StringBuffer htmlList = new StringBuffer();
	String userTypeURL="";
	
	if(user.getUserType().equalsIgnoreCase("SUPER_ADMIN")){
		htmlList.append("	 <li>"
				+ "<a href='#'><i class='fa fa-bar-chart-o'></i> <span class='nav-label'>Create User</span><span class='fa arrow'></span></a>"
				+ " <ul class='nav nav-second-level collapse'>");
	
		
		for(String userType: getAllUserTypes()){	
			if(userType.equals("TRAINER"))
				userTypeURL = "orgadmin/user_types/trainer.jsp";
			else if (userType.equals("STUDENT"))
				userTypeURL = "orgadmin/user_types/student.jsp";	
			else if(userType.equals("ORG_ADMIN"))
				userTypeURL = "";
			
			
//		switch(userType){
//		case "TRAINER": userTypeURL = "orgadmin/trainer/edit_trainerlist.jsp";
//		case UserTypes.TRAINER: userTypeURL = "hi.jsp";
//		case UserTypes.STUDENT: userTypeURL = "orgadmin/recruiter/company/create_user.jsp";	
//		case UserTypes.ORG_ADMIN: userTypeURL = "";
//		case UserTypes.TPO: userTypeURL = "";
//		case UserTypes.RECRUITER: userTypeURL = "";
//		case UserTypes.CONTENT_CREATOR: userTypeURL = "";	 
//		case UserTypes.CONTENT_ADMIN: userTypeURL = "";	
//		System.out.println("inside switch "+userType);
//		System.out.println("inside switch URL: " + userTypeURL);
//		System.out.println("User Type URL After Switch Case in For Loop is" +userTypeURL);
//		htmlList.append("<li><a href='" + baseURL + userTypeURL +"'>" + userType + "</a></li>");
//		System.out.println("----------------------------------------------------------------------------");
//		}	
//		System.out.println("User Type URL After Switch Case in For Loop is" +userTypeURL);
//		htmlList.append("<li><a href='" + baseURL + userTypeURL +"'>" + userType + "</a></li>");
		htmlList.append("<li><a href='" + baseURL + userTypeURL +"'>" + userType + "</a></li>");

		}
		
		htmlList.append("</ul></li>");
		
			
	}
	
	return htmlList;
}

	
	
}
