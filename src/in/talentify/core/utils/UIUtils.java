
package in.talentify.core.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.CmsessionDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.xmlbeans.MenuHolder;
import in.talentify.core.xmlbeans.ParentLink;

public class UIUtils {
	
	
	public HashMap<String, String> getALLEventDetails(String eventID) {
		DBUTILS util = new DBUTILS();
		HashMap<String, String> hashMap  = new HashMap<String, String>();
		String listOfassociateTrainer = "NONE";
		hashMap.put("asoctraineremail", listOfassociateTrainer);
		hashMap.put("asoctrainername", listOfassociateTrainer);
		
		 
		String sessionsCovered="none";
		String nextSession="none";
		String assessmentTitle="none";
		
		hashMap.put("sessions_covered", sessionsCovered);
		hashMap.put("next_session", nextSession);
		
		hashMap.put("assessment_title", assessmentTitle);
		String sql = "SELECT 	batch_schedule_event. ACTION, 	batch. ID AS batchid, 	batch. NAME AS batchname,   course.course_name AS coursename, 	classroom_details.classroom_identifier AS classroom,  "
				+ " organization.name AS colname, 	user_profile.first_name AS trainername, 	istar_user.email AS traineremail,  CAST ( 		batch_schedule_event.eventdate AS VARCHAR 	) AS evedate, 	batch_schedule_event.eventhour AS hours, "
				+ "	 batch_schedule_event.eventminute AS MINUTE, 	batch_schedule_event.status, 	batch_schedule_event.associate_trainee FROM 	batch_schedule_event, 	batch, 	user_profile,   istar_user, 	organization, 	classroom_details, 	course "
				+ "WHERE 	batch_schedule_event.batch_id = batch. ID AND batch_schedule_event.classroom_id = classroom_details. ID AND classroom_details.organization_id = organization. ID AND istar_user. ID = batch_schedule_event.actor_id AND course. ID = batch.course_id AND istar_user.id = user_profile.user_id AND batch_schedule_event. ID = '"+ eventID +"'";
		
		
		
		
		
		
		 System.out.println(sql);
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		if(res.size() > 0){
			hashMap.put("batchname", res.get(0).get("batchname").toString());
			hashMap.put("coursename", res.get(0).get("coursename").toString());
			hashMap.put("classroom", res.get(0).get("classroom").toString());
			hashMap.put("trainername", res.get(0).get("trainername").toString());
			hashMap.put("traineremail", res.get(0).get("traineremail").toString());
			hashMap.put("evedate", res.get(0).get("evedate").toString());
			hashMap.put("duration", res.get(0).get("hours").toString()+" hour "+ res.get(0).get("minute").toString()+" minute");
			hashMap.put("status", res.get(0).get("status").toString());
			hashMap.put("colname", res.get(0).get("colname").toString());
		//	hashMap.put("associate_trainee", res.get(0).get("associate_trainee").toString());
			
			
			
			sql = "SELECT 	COUNT(batch_students.student_id) as totstudent FROM 	batch, 	batch_group, 	batch_students WHERE 	batch_group. ID = batch.batch_group_id AND batch_group. ID = batch_students.batch_group_id AND batch.id = "+res.get(0).get("batchid")+" AND batch_students.user_type = 'STUDENT'";
			List<HashMap<String, Object>> res1 = util.executeQuery(sql);
			hashMap.put("totstudent", res1.get(0).get("totstudent").toString());
			
			if(res.get(0) != null && res.get(0).get("associate_trainee") != null && res.get(0).get("associate_trainee").toString() != null && !res.get(0).get("associate_trainee").toString().equalsIgnoreCase("NONE") && !res.get(0).get("associate_trainee").toString().equalsIgnoreCase("0")){
				
				listOfassociateTrainer = res.get(0).get("associate_trainee").toString();
				 if (listOfassociateTrainer.contains(",")) {
					 for (String retval: listOfassociateTrainer.split(",")) {
						
						 
						 sql = "SELECT 	istar_user.email AS asoctraineremail, 	user_profile.first_name AS asoctrainername FROM 	istar_user, 	user_profile WHERE 	istar_user.ID = user_profile.user_id AND istar_user.ID ="+Integer.parseInt(retval);
						 List<HashMap<String, Object>> res2 = util.executeQuery(sql);
						 
						 hashMap.put("asoctraineremail", res2.get(0).get("asoctraineremail").toString());
						 hashMap.put("asoctrainername", res2.get(0).get("asoctrainername").toString());
						 
				      }
					 
				 }else{
					 
					 sql = "SELECT 	istar_user.email AS asoctraineremail, 	user_profile.first_name AS asoctrainername FROM 	istar_user, 	user_profile WHERE 	istar_user.ID = user_profile.user_id AND istar_user.ID  ="+Integer.parseInt(listOfassociateTrainer);
					 List<HashMap<String, Object>> res3 = util.executeQuery(sql);
					 hashMap.put("asoctraineremail", res3.get(0).get("asoctraineremail").toString());
					 hashMap.put("asoctrainername", res3.get(0).get("asoctrainername").toString());
				 }
				
			}else{
				
				hashMap.put("associate_trainee", listOfassociateTrainer);
				
			}
			
			String batch_id = res.get(0).get("batchid").toString();
			String getLastSessionId = "select cmsession_id from event_session_log where batch_id= "+batch_id+" ORDER BY id desc limit 1";
			List<HashMap<String, Object>> lastSessionData = util.executeQuery(getLastSessionId);
			int  lastSessionId = -1;
			if(lastSessionData.size()>0)
			{
				lastSessionId = (int)lastSessionData.get(0).get("cmsession_id");
			}
			String orderedLessonInCourse ="SELECT 	cmsession_module.cmsession_id AS cm_id FROM 	lesson_cmsession, 	task, 	cmsession_module,   module_course WHERE 	module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND lesson_cmsession.lesson_id = task.item_id AND module_course .course_id = ( 	SELECT 		course_id 	FROM 		batch 	WHERE 		ID = "+batch_id+" )";
			 System.out.println(orderedLessonInCourse);
			List<HashMap<String, Object>> orderLessonData = util.executeQuery(orderedLessonInCourse); 
			int nextSesionId= -1;
			boolean gotCurrentSesison = false;
			if(lastSessionId!=-1)
			{
				//has previous logs
				for(HashMap<String, Object> rr: orderLessonData)
				{
					if(!gotCurrentSesison && rr.get("cm_id").toString().equalsIgnoreCase(lastSessionId+""))
					{
						gotCurrentSesison= true;						
					}
					if(gotCurrentSesison)
					{
						if(!rr.get("cm_id").toString().equalsIgnoreCase(lastSessionId+""))
						{
							nextSesionId = (int)rr.get("cm_id");
							break;
						}
					}
				}
			}
			else
			{
				//not yet started
				nextSesionId = (int)orderLessonData.get(0).get("cm_id");
				nextSession = new CmsessionDAO().findById(nextSesionId).getTitle();
			}	
			
			
			
			if(nextSesionId!=-1)
			{
				nextSession = new CmsessionDAO().findById(nextSesionId).getTitle();						
			}
			else
			{
				nextSession ="All cmsessions are covered";
			}
			
			hashMap.put("next_session", nextSession);
			
			if(res.get(0).get("status").toString().equalsIgnoreCase("ASSESSMENT")){
				
				System.out.println("ASSESSMENT");
				String action = res.get(0).get("action").toString();
				String getAssessmentId[] = action.split("__");		
				int assessment_id = Integer.parseInt(getAssessmentId[1]);
				Assessment assess = new AssessmentDAO().findById(assessment_id);
				sql = "SELECT COUNT(actor_id) as totstudent FROM istar_assessment_event WHERE batch_id ="+res.get(0).get("batchid")+" AND assessment_id = "+assessment_id+" AND CAST (eventdate as VARCHAR) ='"+res.get(0).get("evedate")+"'";
				System.out.println(sql); 
				List<HashMap<String, Object>> res4 = util.executeQuery(sql);
				hashMap.put("totstudent", res4.get(0).get("totstudent").toString());
				hashMap.put("assessment_title", assess.getAssessmenttitle());
				
			}
			else if(res.get(0).get("status").toString().equalsIgnoreCase("TEACHING") ||res.get(0).get("status").toString().equalsIgnoreCase("ATTENDANCE") || res.get(0).get("status").toString().equalsIgnoreCase("FEEDBACK") || res.get(0).get("status").toString().equalsIgnoreCase("COMPLETED"))
			{
				String getSessionTaught="select string_agg(DISTINCT cmsession.title,', ')  as sessions from event_log , cmsession where event_log.event_id = '"+eventID+"' and event_log.cmsession_id = cmsession.id";
				List<HashMap<String, Object>> sessionTaught = util.executeQuery(getSessionTaught);
				sessionsCovered = (String)sessionTaught.get(0).get("sessions");
				hashMap.put("sessions_covered", sessionsCovered);
			}
			
		}
		
		
		
		return hashMap;
	}

	public List<HashMap<String, Object>> getJobMasterLevelForCourse(int course_id) {
		DBUTILS util = new DBUTILS();
		String sql = "SELECT 	job.title || ' at ' || organization. NAME AS title, 	'http://api.talentify.in' || organization.image AS company_image, 	CAST ( 		AVG ( 			job_role_skill_benchmark.wizard_level 		) AS INTEGER 	) AS wizard_level, 	CAST ( 		AVG ( 			job_role_skill_benchmark.master_level 		) AS INTEGER 	) AS master_level, 	CAST ( 		AVG ( 			job_role_skill_benchmark.apprentice_level 		) AS INTEGER 	) AS apprentice_level, 	CAST ( 		AVG ( 			job_role_skill_benchmark.rookie_level 		) AS INTEGER 	) AS rookie_level FROM 	module_course, 	cmsession_module, 	lesson_cmsession, 	lesson_skill_objective, 	job_role_skill_benchmark, 	job, 	organization WHERE 	module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND lesson_cmsession.lesson_id = lesson_skill_objective.lessonid AND job_role_skill_benchmark.vacancy_id = job. ID AND job.organization = organization. ID AND lesson_skill_objective.learning_objectiveid = job_role_skill_benchmark.skill_id AND module_course.course_id = "
				+ course_id + " GROUP BY 	job.title || ' at ' || organization. NAME, 	company_image LIMIT 5";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getJobMasterLevelForBatch(int batch_id) {
		DBUTILS util = new DBUTILS();
		String sql = "SELECT 	job.title || ' at ' || organization. NAME AS title, 	organization.image AS company_image, 	CAST ( 		AVG ( 			job_role_skill_benchmark.wizard_level 		) AS INTEGER 	) AS wizard_level, 	CAST ( 		AVG ( 			job_role_skill_benchmark.master_level 		) AS INTEGER 	) AS master_level, 	CAST ( 		AVG ( 			job_role_skill_benchmark.apprentice_level 		) AS INTEGER 	) AS apprentice_level, 	CAST ( 		AVG ( 			job_role_skill_benchmark.rookie_level 		) AS INTEGER 	) AS rookie_level FROM 	module_course, 	cmsession_module, 	lesson_cmsession, 	lesson_skill_objective, 	job_role_skill_benchmark, 	job, 	organization, 	batch WHERE 	module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND lesson_cmsession.lesson_id = lesson_skill_objective.lessonid AND job_role_skill_benchmark.vacancy_id = job. ID AND job.organization = organization. ID AND organization.org_type = 'COMPANY' AND lesson_skill_objective.learning_objectiveid = job_role_skill_benchmark.skill_id AND module_course.course_id = batch.course_id AND batch. ID = "
				+ batch_id + " GROUP BY 	job.title || ' at ' || organization. NAME, 	company_image LIMIT 5";
		List<HashMap<String, Object>> data = util.executeQuery(sql);
		return data;
	}

	public ArrayList<ParentLink> getMenuLinks(String roleName) {
		ArrayList<ParentLink> links = new ArrayList<>();

		MenuHolder.generateMenu();

		for (ParentLink link : MenuHolder.getMenu().getLinks()) {
			try {
				if (link.getValid_role().equalsIgnoreCase(roleName)) {
					links.add(link);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return links;
	}

	public StringBuffer getAllAssessments() {
		String sql = "SELECT id,assessmenttitle FROM assessment";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		out.append("<option value='null'>Select Assessment</option>");
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("assessmenttitle") + "</option>");
		}
		out.append("");
		return out;
	}
	
	public StringBuffer getEventStats(int orgID) {
		String sql = "SELECT count(*) as totEvent, COUNT (*) FILTER ( WHERE bse.status = 'COMPLETED' ) AS COMPLETED, "
				+ " COUNT (*) FILTER ( WHERE bse.status = 'SCHEDULED' ) AS SCHEDULED, COUNT (*) FILTER ( WHERE bse.status = 'TEACHING' ) AS "
				+ " TEACHING, COUNT (*) FILTER ( WHERE bse.status = 'CANCELLED' ) AS CANCELLED FROM batch_schedule_event bse, "
				+ " classroom_details cd WHERE bse.eventdate >= CURRENT_DATE + INTERVAL '24 hour' AND  "
				+ " bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' AND "
				+ " bse.classroom_id = cd.id AND cd.organization_id = " + orgID;
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		StringBuffer out = new StringBuffer();
		// cancelled=0, teaching=0, completed=0, totevent=0, scheduled=0
		out.append("<div class='col-lg-3'> <div class='widget style1 navy-bg'> "
				+ "<div class='row'> <div class='col-xs-2'> <i class='fa fa-calendar fa-2x'></i>"
				+ " </div> <div class='col-xs-9 text-right'> <span> Events Today </span> " + "<h2 class='font-bold'>"
				+ data.get(0).get("totevent") + "</h2> </div> </div> </div> </div>");

		out.append("<div class='col-lg-3'> <div class='widget style1 navy-bg'> "
				+ "<div class='row'> <div class='col-xs-2'> <i class='fa fa-calendar fa-2x'></i>"
				+ " </div> <div class='col-xs-9 text-right'> <span> Events Cancelled </span> "
				+ "<h2 class='font-bold'>" + data.get(0).get("cancelled") + "</h2> </div> </div> </div> </div>");

		out.append("<div class='col-lg-3'> <div class='widget style1 navy-bg'> "
				+ "<div class='row'> <div class='col-xs-2'> <i class='fa fa-calendar fa-2x'></i>"
				+ " </div> <div class='col-xs-9 text-right'> <span> SCHEDULED </span> " + "<h2 class='font-bold'>"
				+ data.get(0).get("scheduled") + "</h2> </div> </div> </div> </div>");

		out.append("<div class='col-lg-3'> <div class='widget style1 navy-bg'> "
				+ "<div class='row'> <div class='col-xs-2'> <i class='fa fa-calendar fa-2x'></i>"
				+ " </div> <div class='col-xs-9 text-right'> <span> Events Inprogress </span> "
				+ "<h2 class='font-bold'>" + data.get(0).get("teaching") + "</h2> </div> </div> </div> </div>");
		/*
		 * out.append(
		 * "<div class='col-lg-2'> <div class='widget style1 navy-bg'> " +
		 * "<div class='row'> <div class='col-xs-2'> <i class='fa fa-calendar fa-2x'></i>"
		 * +
		 * " </div> <div class='col-xs-9 text-right'> <span> Events Pending </span> "
		 * + "<h2 class='font-bold'>" + data.get(0).get("totevent") +
		 * "</h2> </div> </div> </div> </div>");
		 */

		return out;
	}

	public StringBuffer getProgressView(int orgId) {
		StringBuffer out = new StringBuffer();
		out.append("");
		return out;
	}

	public int getOrgPrincipal(int orgId) {

		String sql = "SELECT 	istar_user.id as uid FROM 	istar_user, 	ROLE, 	user_role, user_org_mapping WHERE 	istar_user. ID = user_role.user_id AND user_role.role_id = ROLE . ID AND ROLE .role_name = 'ORG_ADMIN' AND user_org_mapping.user_id = istar_user.id AND user_org_mapping.organization_id ="
				+ orgId;
		DBUTILS db = new DBUTILS();
		int user_id = 0;
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		for (HashMap<String, Object> item : data) {

			user_id = (int) item.get("uid");
		}
		return user_id;

	}

	public StringBuffer getAllSkillForTrainer() {
		String sql = "SELECT DISTINCT id,name FROM skill_objective WHERE type = 'TASK_BASED'";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
		}
		out.append("");
		return out;
	}

	public List<HashMap<String, Object>> getProgramTabTable() {
		String sql = "SELECT 	T1.cname, 	T1.sumapprentice / countapprentice AS avgapp, 	T1.sumrookie / countrookie AS avgrooki, 	T1.summaster / countmaster AS avgmaaster, 	T1.sumwizard / countwizard AS avgwiz FROM 	( 		SELECT 			organization. NAME AS cname, 			SUM ( 				mastery_level_per_course.apprentice 			) AS sumapprentice, 			SUM ( 				mastery_level_per_course.rookie 			) AS sumrookie, 			SUM ( 				mastery_level_per_course.master 			) AS summaster, 			SUM ( 				mastery_level_per_course.wizard 			) AS sumwizard, 			COUNT ( 				mastery_level_per_course.apprentice 			) AS countapprentice, 			COUNT ( 				mastery_level_per_course.rookie 			) AS countrookie, 			COUNT ( 				mastery_level_per_course.master 			) AS countmaster, 			COUNT ( 				mastery_level_per_course.wizard 			) AS countwizard 		FROM 			mastery_level_per_course, 			organization 		WHERE 			organization. ID = mastery_level_per_course.college_id 		GROUP BY 			cname 	) T1";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		return data;
	}

	public StringBuffer getOrganization() {
		// System.err.println(orgId);
		String sql = "SELECT id,name FROM organization";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
		}
		out.append("");
		return out;
	}

	public List<HashMap<String, Object>> getAllOrganization() {
		// System.err.println(orgId);
		String sql = "SELECT id,name FROM organization limit 6";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		return data;
	}

	public StringBuffer getCourses(int orgId) {
		// System.err.println(orgId);
		String sql = "";
		if (orgId == -3) {

			sql = "SELECT DISTINCT id,course_name FROM course";

		} else {

			sql = "select DISTINCT course.id , course.course_name from batch_group , batch ,course where batch_group.college_id="
					+ orgId + " and batch_group.id = batch.batch_group_id and batch.course_id = course.id";

		}

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("course_name") + "</option>");
		}
		out.append("");
		return out;
	}

	public StringBuffer getCoursesForBatches(int orgId) {
		System.err.println(orgId);
		String sql = "SELECT DISTINCT batch.id as bid, course. ID as cid ,course.course_name as cname FROM batch,course,batch_group WHERE batch.course_id = course.id AND batch_group.id = batch.batch_group_id AND batch_group.college_id ="
				+ orgId;
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		out.append("<option value=''> Select Course...</option>");
		for (HashMap<String, Object> item : data) {
			out.append("<option data-course='" + item.get("cid") + "' value='" + item.get("bid") + "'>"
					+ item.get("cname") + "</option>");
		}
		out.append("");
		return out;
	}

	public StringBuffer getBatchGroups(int orgId, ArrayList<Integer> selectedBg) {
		// <option value="">Data Analytics</option>
		String sql = "select batch_group.id, batch_group.name from batch_group " + "where batch_group.college_id="
				+ orgId;
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {

			if (selectedBg != null) {
				out.append("<option " + checkAlreadyExist(selectedBg, (int) item.get("id")) + "  value='"
						+ item.get("id") + "'>" + item.get("name") + "</option>");
			} else {
				out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
			}
		}
		out.append("");
		return out;
	}

	public StringBuffer getBatchs(int orgId) {
		// <option value="">Data Analytics</option>
		String sql = "SELECT id,name FROM batch WHERE batch_group_id in (SELECT id FROM batch_group WHERE college_id ="
				+ orgId + ")";
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
		}
		out.append("");
		return out;
	}

	public List<HashMap<String, Object>> getEventDetails(String eventID) {
		DBUTILS util = new DBUTILS();
		String sql = "SELECT 	batch_schedule_event.batch_id,batch_schedule_event.classroom_id as classroomid,   batch_schedule_event.actor_id as userid,   batch_schedule_event.eventdate as evedate,   batch_schedule_event.eventhour as hours,   batch_schedule_event.eventminute as min,   batch.course_id as courseid,batch_schedule_event.associate_trainee FROM 	batch_schedule_event, 	batch WHERE 	batch_schedule_event. ID = '"
				+ eventID + "' AND batch_schedule_event.batch_id = batch. ID";
		// System.out.println(sql);
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		return res;
	}

	public StringBuffer getAllTrainer(ArrayList<Integer> selectedTrainer) {
		// <option value="">Data Analytics</option>
		String sql = "SELECT 	istar_user. ID, 	istar_user.email, 	user_profile.first_name FROM 	istar_user, 	user_role,   user_profile WHERE 	istar_user. ID = user_role.user_id AND user_role.role_id = 14 AND user_profile.user_id = istar_user. ID";

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		for (HashMap<String, Object> item : data) {

			if (selectedTrainer != null) {
				out.append("<option " + checkAlreadyExist(selectedTrainer, (int) item.get("id")) + "  value='"
						+ item.get("id") + "'>" + item.get("email") + " (" + item.get("id") + ")</option>");
			} else {
				out.append("<option value='" + item.get("id") + "'>" + item.get("email") + "</option>");
			}
		}
		out.append("");
		return out;
	}

	/*
	 * public StringBuffer getAllTrainer(int trainerID) { // <option
	 * value="">Data Analytics</option> String sql =
	 * "SELECT id,email,name FROM student WHERE student.user_type = 'TRAINER'";
	 * 
	 * DBUTILS db = new DBUTILS(); List<HashMap<String, Object>> data =
	 * db.executeQuery(sql); StringBuffer out = new StringBuffer(); out.append(
	 * "<option value='" + trainerID + "'>" + trainerName + "</option>"); for
	 * (HashMap<String, Object> item : data) { out.append("<option value='" +
	 * item.get("id") + "," + item.get("name") + "'>" + item.get("email") +
	 * "</option>"); } out.append(""); return out; }
	 */

	public StringBuffer getLessons(int batch_id, int course_id) {
		DBUTILS util = new DBUTILS();

		StringBuffer out = new StringBuffer();

		String sql1 = "SELECT DISTINCT	lesson. ID AS ID, 	lesson.title AS title, 	task.state AS status FROM 	event_log, 	lesson, 	task WHERE 	event_log.lesson_id = lesson. ID AND task.item_id = lesson. ID AND batch_id = "
				+ batch_id + " ORDER BY 	ID DESC LIMIT 1;";
		List<HashMap<String, Object>> res1 = util.executeQuery(sql1);
		if (res1.size() > 0) {
			for (HashMap<String, Object> item : res1) {
				out.append("<option value='" + item.get("id") + "'>" + item.get("title") + "--" + item.get("status")
						+ "</option>");
			}

		} else {

			String sql2 = "SELECT 	l. ID AS ID, 	l.title AS title, 	tsk.state AS status FROM 	module_course mc, 	cmsession_module cm, 	lesson_cmsession lcms, 	task tsk, 	lesson l WHERE 	mc.module_id = cm.module_id AND cm.cmsession_id = lcms.cmsession_id AND lcms.lesson_id = l. ID AND tsk.item_id = l. ID AND  mc.course_id = "
					+ course_id + " ORDER BY 	l.title";

			List<HashMap<String, Object>> res2 = util.executeQuery(sql2);
			if (res2.size() > 0) {
				for (HashMap<String, Object> item : res2) {
					out.append("<option value='" + item.get("id") + "'>" + item.get("title") + "--" + item.get("status")
							+ "</option>");
				}
			}
		}

		out.append("");
		return out;
	}

	public StringBuffer getAllClassroom(int orgId) {
		// <option value="">Data Analytics</option>
		String sql = "SELECT id,classroom_identifier FROM classroom_details WHERE classroom_details.organization_id="
				+ orgId;

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("classroom_identifier") + "</option>");
		}
		out.append("");
		return out;
	}

	/*
	 * public StringBuffer getAllClassrooms(int classroomID) { // <option
	 * value="">Data Analytics</option> String sql =
	 * "SELECT id,classroom_identifier FROM classroom_details WHERE organization_id in (SELECT organization_id FROM classroom_details WHERE id = "
	 * + classroomID + ")";
	 * 
	 * DBUTILS db = new DBUTILS(); List<HashMap<String, Object>> data =
	 * db.executeQuery(sql); StringBuffer out = new StringBuffer(); out.append(
	 * "<option value='" + classroomID + "'>" + classroomName + "</option>");
	 * for (HashMap<String, Object> item : data) { out.append("<option value='"
	 * + item.get("id") + "'>" + item.get("classroom_identifier") +
	 * "</option>"); } out.append(""); return out; }
	 */

	public StringBuffer getEventPerOrganization(Organization c) {

		String sql = "SELECT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s.first_name AS trainer_name, 	bse.batch_id AS batch_id, 	s.user_id AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	user_profile s,   user_role ur, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID AND org. ID = "
				+ c.getId()
				+ " AND s.user_id = ur.user_id AND ur.role_id = 14 AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate";

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		for (HashMap<String, Object> item : data) {
			/*
			 * String part1[] = (item.get("event_name")).toString().split("-");
			 * String status = (String) item.get("bse_status"); int batch_id =
			 * (int) item.get("batch_id"); String batch_name = (String)
			 * item.get("batch_name"); int class_id = (int)
			 * item.get("class_id"); String classroom_identifier = (String)
			 * item.get("classroom_identifier"); classroom_identifier =
			 * classroom_identifier + "-" + class_id; int duration = (int)
			 * item.get("bse_eventhour") * 60 + (int) item.get("bse_eventmin");
			 * String tt = (String) item.get("batch_name") + ", Trainer: " +
			 * (String) item.get("trainer_name"); long t = ((Timestamp)
			 * item.get("eventdate")).getTime(); long m = duration * 60 * 1000;
			 * Timestamp end_time = new Timestamp(t + m); String desc = ""; desc
			 * = desc + "Batch Name: " + batch_name + "<br/>Org Name: " +
			 * (String) item.get("org_name") + "<br/>Classroom (ID): " +
			 * classroom_identifier + "(" + class_id + ").<br/>Duration: " +
			 * duration + " mins.<br/> Event Time: " + t + "<br/>Trainer: " +
			 * (String) item.get("trainer_name") + "<br/> Status: " + status;
			 * String col = "#A9CCE3"; if (status.equalsIgnoreCase("SCHEDULED"))
			 * { col = "#A9CCE3"; } else if
			 * (status.equalsIgnoreCase("TEACHING")) { col = "#58D68D"; } else
			 * if (status.equalsIgnoreCase("ATTENDENCE")) { col = "#F7DC6F"; }
			 * else if (status.equalsIgnoreCase("FEEDBACK")) { col = "#DC7633";
			 * } else if (status.equalsIgnoreCase("COMPLETED")) { col =
			 * "#626567"; } else if (status.equalsIgnoreCase("STARTED")) { col =
			 * "#C0392B"; } else if (status.equalsIgnoreCase("REACHED")) { col =
			 * "#FF00FF"; out.append(""); }
			 */
		}
		out.append("");
		return out;
	}

	public JSONArray getCourseReportEvent(int org_id, int course_id, String type) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer sb = new StringBuffer();
		String sql = "";
		if (type.equalsIgnoreCase("Program")) {

			sql = "SELECT DISTINCT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. first_name AS trainer_name, 	bse.batch_id AS batch_id, 	s.user_id AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	user_profile s,   user_role ur, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID AND  org. ID = "
					+ org_id + " AND B.course_id = " + course_id
					+ " AND s.user_id = ur.user_id AND ur.role_id = 14 AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate";
		} else {
			sql = "SELECT DISTINCT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. first_name AS trainer_name, 	bse.batch_id AS batch_id, 	s.user_id AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	user_profile s,   user_role ur, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	organization org WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID AND "
					+ " org. ID = " + org_id + " AND B.course_id = " + course_id
					+ " AND s.user_id = ur.user_id AND ur.role_id = 14 AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate";
		}
		// System.out.println("101 -> " + sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		System.out.println("102 -> " + data.size());

		ArrayList<CourseReportEvent> course_event_list = new ArrayList<>();
		for (HashMap<String, Object> item : data) {
			Date eventdate = null;
			try {
				eventdate = sdf.parse(item.get("eventdate").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if (eventdate != null) {
				CourseReportEvent course_report_event = new CourseReportEvent(item.get("event_name").toString(),
						sdf.format(eventdate), "#58D68D");
				course_event_list.add(course_report_event);
			} else {
				if (item.get("event_name") != null)
					System.out.println("Event not added due to dateformat issue " + item.get("event_name").toString());
			}
		}
		JSONArray arr_strJson = new JSONArray(course_event_list);
		// System.out.println(arr_strJson);

		return arr_strJson;
	}

	public StringBuffer getCourseEventCard(int college_id) {
		StringBuffer out = new StringBuffer();
		String sql = "";

		sql = "select distinct course_name,course_description,attendance_perc,avg_feedback,completion_perc,stu_enrolled,course_id from course_stats where college_id="
				+ college_id;

		// System.out.println("sql " + sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			String course_description = "";
			if (item.get("course_description") != null
					&& !item.get("course_description").toString().equalsIgnoreCase("")) {
				if (item.get("course_description").toString().length() > 140) {
					course_description = item.get("course_description").toString().substring(0, 140) + " ...";
				} else {
					course_description = item.get("course_description").toString();
				}
			}

			String attendance = "0";
			try {
				attendance = item.get("attendance_perc").toString();

			} catch (Exception e) {
				// TODO: handle exception
			}

			String avg_feedback = "0";
			try {
				avg_feedback = item.get("avg_feedback").toString();

			} catch (Exception e) {
				// TODO: handle exception
			}

			String stu_enrolled = "0";
			try {
				stu_enrolled = item.get("stu_enrolled").toString();

			} catch (Exception e) {
				// TODO: handle exception
			}
			String completion_perc = "";
			try {
				completion_perc = item.get("completion_perc").toString();

			} catch (Exception e) {
				// TODO: handle exception
			}

			out.append("<a href='programs_report_details.jsp?course_id=" + item.get("course_id") + "&headname="
					+ item.get("course_name") + "&college_id=" + college_id
					+ "' class='btn-link ' ><div class='col-lg-3' id='program_info_1'>"
					+ "<div class='panel panel-default product-box course-card-height'><div class='panel-heading custom-theme-panal-color font-bold' style='color: white;'>"
					+ item.get("course_name").toString()
					+ "</div><div class='panel-body' style='width: 315px'><p class='course-desc'>" + course_description
					+ "</p><div class='row'><div class='col-lg-6'>Attendance</div><div class='col-lg-6 text-center'>"
					+ attendance
					+ "</div></div><div class='row m-t-sm'><div class='col-lg-6'>Feedback</div><div class='col-lg-6 text-center' style= 'float:right;'>"
					+ "<div class='course_rating' data-report='" + avg_feedback.toString()
					+ "' style='float:right;'><div class='rateYo" + avg_feedback + "' ></div>"
					+ "</div></div></div><div class='row m-t-sm'><div class='col-lg-6'>Student Enrolled</div><div class='col-lg-6 text-center'>"
					+ stu_enrolled
					+ "</div></div><div class='progress progress-striped active m-t-sm'><div style='width: "
					+ completion_perc + "%" + "' aria-valuemax='100'aria-valuemin='0' aria-valuenow='" + completion_perc
					+ "' role='progressbar'class='progress-bar progress-bar-danger'><span class='text-center'>" + completion_perc + " %"
					+ "</span></div></div></div></div></div></a> ");

		}
		return out;
	}

	public StringBuffer getBatchCard(int college_id) {
		StringBuffer out = new StringBuffer();
		String sql = "";

		sql = "select distinct batch_name,stu_enrolled,completion_perc,avg_feedback,attendance_perc,batch_id from batch_stats where college_id ="
				+ college_id;

		// System.out.println("sql " + sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			out.append("<a href='programs_report_details.jsp?batch_id=" + item.get("batch_id") + "&headname="
					+ item.get("batch_name") + "&college_id=" + college_id
					+ "' class='btn-link '><div class='col-lg-3' id='program_info_1'><div class='panel panel-default product-box batch-card-height'><div class='panel-heading custom-theme-panal-color font-bold'  style='color: white;'>"
					+ item.get("batch_name").toString()
					+ "</div><div class='panel-body'><div class='row'><div class='col-lg-6'>Attendance</div><div class='col-lg-6 text-center'>"
					+ item.get("attendance_perc").toString()
					+ "</div></div><div class='row m-t-sm'><div class='col-lg-6'>Feedback</div><div class='col-lg-6 text-center'>"
					+ "<div class='course_rating pull-right' data-report='" + item.get("avg_feedback").toString()
					+ "'><div class='rateYo" + item.get("avg_feedback").toString() + "' ></div></div>"
					+ "</div></div><div class='row m-t-sm'><div class='col-lg-6'>Student Enrolled</div><div class='col-lg-6 text-center'>"
					+ item.get("stu_enrolled").toString()
					+ "</div></div><div class='progress progress-striped active m-t-sm'><div style='width: "
					+ item.get("completion_perc").toString() + "%"
					+ "' aria-valuemax='100'aria-valuemin='0' aria-valuenow='" + item.get("completion_perc").toString()
					+ "' role='progressbar'class='progress-bar progress-bar-danger'><span class='text-center'>"
					+ item.get("completion_perc").toString() + " %" + "</span></div></div></div></div></div></a> ");

		}
		return out;
	}

/*	public StringBuffer getAllGroups(int orgId) {
		String sql = "select T1.bg_id, T1.bg_name,T1.bg_desc,T1.batch_code, COALESCE(T2.batches,0) as batches, COALESCE(T3.students,0) as students from (select batch_group.id as bg_id, batch_group.name as bg_name, batch_group.bg_desc as bg_desc,batch_group.batch_code from batch_group where  "
				+ "batch_group.college_id =" + orgId
				+ ")T1  left join (select count(batch.id) as batches, batch.batch_group_id  from batch where batch.batch_group_id in (select batch_group.id from batch_group where  "
				+ "batch_group.college_id =" + orgId
				+ ") group by batch.batch_group_id )T2 on (T2.batch_group_id= T1.bg_id) left join (select batch_students.batch_group_id, count(batch_students.student_id) as students from batch_students where batch_students.batch_group_id in (select batch_group.id from batch_group where  "
				+ "batch_group.college_id =" + orgId
				+ ") GROUP BY batch_students.batch_group_id )T3 on (T3.batch_group_id = T1.bg_id)";

		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		for (HashMap<String, Object> item : data) {
			out.append("<tr class='group_item'>" + "<td>" + item.get("batch_code") + "</td><td>" + item.get("bg_name")
					+ "</td>" + "	<td>" + item.get("students") + "</td>" + "	<td>" + item.get("batches") + "</td>"
					+ "	<td><div class='btn-group'>"
					+ "<button data-toggle='dropdown' class='btn btn-default btn-xs dropdown-toggle'> <span class='fa fa-ellipsis-v'></span> 	</button>"
					+ " <ul class='dropdown-menu pull-right'> <li><a href='./partials/modal/admin_batch_group_modal.jsp?bg_id="
					+ item.get("bg_id") + "' data-toggle='modal' data-target='#edit_group_model_" + item.get("bg_id")
					+ "'" + " id=edit_bg_button_" + item.get("bg_id") + ">Edit</a></li>	"
					+ "<div class='modal inmodal edit_modal' id='edit_group_model_" + item.get("bg_id")
					+ "' tabindex='-1' 		role='dialog' aria-hidden='true'> 		<div class='modal-dialog modal-lg'> 			<div class='modal-content animated flipInY'> 				 				<!-- Content will be loaded here from 'admin_batch_roup_modal.jsp' file --> 				 			</div> 		</div> 	</div>"

					+ "</ul>" + " </div></td>" + "	</tr>");
		}
		out.append("");
		return out;
	}*/

	public StringBuffer getAllStudentsForBatch(int orgId, ArrayList<Integer> selectedStudents) {
		String sql = "SELECT 	istar_user. ID, email FROM 	user_org_mapping, 	istar_user, user_role WHERE 	istar_user. ID = user_org_mapping.user_id AND user_role.user_id = istar_user. ID AND user_org_mapping.organization_id = "
				+ orgId + " AND user_role.role_id = 12";

		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		for (HashMap<String, Object> item : data) {

			if (selectedStudents != null) {
				out.append("<option " + checkAlreadyExist(selectedStudents, (int) item.get("id")) + "  value='"
						+ item.get("id") + "'>" + item.get("email") + " (" + item.get("id") + ")</option>");
			} else {
				out.append("<option value='" + item.get("id") + "'>" + item.get("email") + " (" + item.get("id")
						+ ")</option>");
			}

		}
		out.append("");
		return out;
	}

	private String checkAlreadyExist(ArrayList<Integer> selected, int object) {
		if (selected.contains(object)) {
			return "selected";
		} else {
			return "";
		}
	}

}