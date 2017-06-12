package in.orgadmin.admin.services;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportUtils;

public class OrgAdminSkillService {

	ArrayList<Integer> lessonList = new ArrayList<>();

	public List<HashMap<String, Object>> getAllSkills() {

		String sql = "SELECT DISTINCT 	so. ID, 	so. NAME FROM 	skill_objective so, 	lesson_skill_objective lso WHERE 	so. NAME NOT LIKE '' AND so. TYPE = 'TASK_BASED' AND lso.learning_objectiveid = so.id ORDER BY 	NAME";

		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>>  getAllMappedSkills(int orgId, int entityId, String entityType)
	{
		CustomReportUtils repUtils   = new CustomReportUtils();
		String sql = "";
		if(entityType.equalsIgnoreCase("USER"))
		{
			sql = repUtils.getReport(42).getSql();
		}
		else
		{
			sql = repUtils.getReport(41).getSql();
		}	
		sql = sql.replaceAll(":college_id", orgId+"");
		sql = sql.replaceAll(":entity_id", entityId+"");
		sql = sql.replaceAll(":entity_type", entityType.toUpperCase());
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}
	
	
	public List<HashMap<String, Object>> getAllSkillsForEntity(int orgId, int entityId, String entityType)
	{
		CustomReportUtils repUtils   = new CustomReportUtils();
		String sql = "";
		if(entityType.equalsIgnoreCase("USER"))
		{
			sql = repUtils.getReport(40).getSql();
		}
		else
		{
			sql = repUtils.getReport(39).getSql();
		}	
		sql = sql.replaceAll(":college_id", orgId+"");
		sql = sql.replaceAll(":entity_id", entityId+"");
		sql = sql.replaceAll(":entity_type", entityType.toUpperCase());
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}
	public List<HashMap<String, Object>> getAllSkills(int orgId) {
		CustomReportUtils repUtils   = new CustomReportUtils();
		String sql = repUtils.getReport(12).getSql();
		sql = sql.replaceAll(":college_id", orgId+"");
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAdminRoleList(int orgId) {

		String sql = "SELECT DISTINCT 	t1. ID, 	t1.role_name, 	COUNT (t1.sid) AS role_skill_count FROM 	( 		SELECT DISTINCT 			C . ID, 			C .course_name AS role_name, 			skill_objective. ID AS sid 		FROM 			course C 		LEFT JOIN module_course ON ( 			module_course.course_id = C . ID 		) 		LEFT JOIN cmsession_module ON ( 			module_course.module_id = cmsession_module.module_id 		) 		LEFT JOIN lesson_cmsession ON ( 			cmsession_module.cmsession_id = lesson_cmsession.cmsession_id 		) 		LEFT JOIN lesson_skill_objective ON ( 			lesson_cmsession.lesson_id = lesson_skill_objective.lessonid 		) 		LEFT JOIN skill_objective ON ( 			skill_objective. ID = lesson_skill_objective.learning_objectiveid 			AND skill_objective. TYPE = 'TASK_BASED' 		) 		LEFT JOIN batch ON ( 			batch.course_id = module_course.course_id 		) 		LEFT JOIN batch_group ON ( 			batch.batch_group_id = batch_group. ID 			AND batch_group.college_id = "
				+ orgId + " 		) 	) t1 GROUP BY 	t1. ID, 	t1.role_name ORDER BY 	t1.role_name";

		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getSkillAssosicatedRoleList(int orgId, int roleId) {

		String sql = "SELECT DISTINCT 	skill_objective. NAME, 	skill_objective. ID, 	module_course.course_id FROM 	module_course, 	cmsession_module, 	lesson_cmsession, 	batch, 	batch_group, 	lesson_skill_objective, 	skill_objective WHERE 	module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND batch.course_id = module_course.course_id AND batch.batch_group_id = batch_group. ID AND lesson_cmsession.lesson_id = lesson_skill_objective.lessonid AND skill_objective. ID = lesson_skill_objective.learning_objectiveid AND batch_group.college_id = "
				+ orgId + " AND batch.course_id = " + roleId
				+ " AND skill_objective. TYPE = 'TASK_BASED' ORDER BY 	skill_objective. NAME, 	module_course.course_id";

		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;

	}

	public void deleteSkillAssosicatedRole(int roleskillId, int roll_id) {
		String sql = "DELETE FROM role_skill_mapping rs WHERE 	rs.role_id = " + roll_id + " AND rs. ID = "
				+ roleskillId;
		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		db.executeUpdate(sql);
	}

	public void createSkillAssosicatedRole(int skillId, int rollId) {

		try {
			DBUTILS db = new DBUTILS();

			// create cmssession
			String sql = "INSERT INTO cmsession ( 	ID, 	title,  description, 	order_id, 	is_deleted,   created_at ) VALUES 	( 		( 			SELECT 				COALESCE (MAX(ID), 0) + 1 			FROM 				cmsession 		), 		'skill_session_" 					+ skillId + rollId + "', 	 		'skill_desc" + skillId + rollId 					+ "', 		( 			SELECT 				COALESCE (MAX(ID), 0) + 1 			FROM 				cmsession 		), 		'f',   now() 	) RETURNING ID";
			int cmssession = (int) db.executeUpdateReturn(sql);

			// create module
			sql = "INSERT INTO module (id, module_name, order_id) VALUES ((select COALESCE(max(id),0)+1 from module), 'skill_session"
					+ skillId + rollId + "', (select COALESCE(max(id),0)+1 from module))returning id";
			int module_id = (int) db.executeUpdateReturn(sql);

			// create cmsession_module mapping
			sql = "INSERT INTO cmsession_module (cmsession_id, module_id) VALUES ('" + cmssession + "', '" + module_id
					+ "')";
			db.executeUpdate(sql);

			// create module_course mapping
			sql = "INSERT INTO module_course (module_id, course_id) VALUES ('" + module_id + "', '" + rollId + "')";
			db.executeUpdate(sql);

			// get list of lessons
			sql = "SELECT DISTINCT 	l_s_o.lessonid FROM 	skill_objective sk_obj, 	lesson_skill_objective l_s_o WHERE 	sk_obj. ID = " 					+ skillId + " AND l_s_o.learning_objectiveid = sk_obj. ID";
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			for (HashMap<String, Object> item : data) {
				
				sql = "INSERT INTO lesson_skill_objective (lessonid, learning_objectiveid) VALUES ('" + item.get("lessonid")+"', "+skillId+");";
				db.executeUpdate(sql);
				System.err.println("----->"+sql);
				sql = "INSERT INTO lesson_cmsession (lesson_id, cmsession_id) VALUES ('" + item.get("lessonid")
						+ "', '" + cmssession + "')";
				///System.err.println(sql);
				db.executeUpdate(sql);
				System.out.println(sql);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public int getTotalUsers(int orgId) {
		CustomReportUtils repoUtils = new CustomReportUtils();
		CustomReport rep = repoUtils.getReport(9);
		String sql = rep.getSql();
		sql = sql.replaceAll(":college_id", orgId+"");
		DBUTILS util = new DBUTILS();
		int count = (int)util.executeQuery(sql).get(0).get("count"); 
		return count;

	}

	public List<HashMap<String, Object>> getAllContentUserList(int orgId, String type, int offset, String searchKey, String limit) {
		String sql = "";
		CustomReportUtils repUtils = new CustomReportUtils();
		if (type.equalsIgnoreCase("User")) {
			CustomReport report = repUtils.getReport(10); 
			String searchquery = "";
			if (searchKey != null && !searchKey.equalsIgnoreCase("")) {
				searchquery = searchKey;
			}
			sql = report.getSql();
			sql = sql.replaceAll(":college_id", orgId+"");
			sql = sql.replaceAll(":limit", limit);
			sql = sql.replaceAll(":offset", offset+"");
			sql = sql.replaceAll(":search_term", searchquery);
			
			
		} else if (type.equalsIgnoreCase("Group")) {
			CustomReport report = repUtils.getReport(11); 
			sql = report.getSql();
			String searchquery = "";
			if (searchKey != null && !searchKey.equalsIgnoreCase("")) {
				searchquery = searchKey;
			}
			sql = sql.replaceAll(":college_id", orgId+"");
			sql = sql.replaceAll(":type", "SECTION");
			sql = sql.replaceAll(":limit", limit);
			sql = sql.replaceAll(":offset", offset+"");
			sql = sql.replaceAll(":search_term", searchquery);
		} else if (type.equalsIgnoreCase("Role")) {
			CustomReport report = repUtils.getReport(11); 
			sql = report.getSql();
			String searchquery = "";
			if (searchKey != null && !searchKey.equalsIgnoreCase("")) {
				searchquery = searchKey;
			}
			sql = sql.replaceAll(":college_id", orgId+"");
			sql = sql.replaceAll(":type", "ROLE");
			sql = sql.replaceAll(":limit", limit);
			sql = sql.replaceAll(":offset", offset+"");
			sql = sql.replaceAll(":search_term", searchquery);
		}
		System.out.println("final sql"+sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAllContentAssosicatedSkills(int orgId, int typeId, String type) {
		System.out.println(type);
		String sql = "";
		if (type.equalsIgnoreCase("User")) {
			sql = "SELECT DISTINCT 	lesson.title AS lesson_title, 	lesson. ID AS lesson_id, 	course. ID AS course_id, 	course.course_name AS course_name FROM 	student_playlist, 	lesson, 	course WHERE 	course. ID = student_playlist.course_id AND lesson. ID = student_playlist.lesson_id AND student_id = "
					+ typeId + " order by course_name, lesson_title";
		} else if (type.equalsIgnoreCase("Group")) {
			sql = "SELECT DISTINCT 	lesson.title AS lesson_title, 	lesson. ID AS lesson_id, 	course. ID AS course_id, 	course.course_name AS course_name FROM 	student_playlist, 	lesson, 	course WHERE 	course. ID = student_playlist.course_id AND lesson. ID = student_playlist.lesson_id AND student_id in (select student_id from batch_students where batch_group_id ="
					+ typeId + " ) order by course_name, lesson_title";
		} else if (type.equalsIgnoreCase("Role")) {
			sql = "SELECT DISTINCT 	lesson.title AS lesson_title, 	lesson. ID AS lesson_id, 	course. ID AS course_id, 	course.course_name AS course_name FROM 	student_playlist, 	lesson, 	course WHERE 	course. ID = student_playlist.course_id AND lesson. ID = student_playlist.lesson_id AND student_id in (select student_id from batch_students where batch_group_id ="
					+ typeId + " ) order by course_name, lesson_title";
		}
		
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public StringBuffer createContentAssosicatedSkill(String entityType, String skillType, int skillId, int entityId) {
		StringBuffer out = new StringBuffer();
		CustomReportUtils repUtils = new CustomReportUtils();
		try {
			DBUTILS db = new DBUTILS();
			String sql = "";
			List<HashMap<String, Object>> data = new ArrayList<>();

			if (skillType.equalsIgnoreCase("COURSE")) {
				//:skill_objective_id
				CustomReport rep = repUtils.getReport(13); 
				
				sql = rep.getSql();
				sql = sql.replaceAll(":skill_objective_id", skillId+"");
				System.err.println(sql);
				data = db.executeQuery(sql);

			} else if (skillType.equalsIgnoreCase("MODULE")) {
				CustomReport rep = repUtils.getReport(14); 				
				sql = rep.getSql();
				sql = sql.replaceAll(":skill_objective_id", skillId+"");
				System.err.println(sql);
				data = db.executeQuery(sql);
			} else if (skillType.equalsIgnoreCase("CMSESSION")) {
				CustomReport rep = repUtils.getReport(15); 				
				sql = rep.getSql();
				sql = sql.replaceAll(":skill_objective_id", skillId+"");
				System.err.println(sql);
				data = db.executeQuery(sql);
			}

			// user mapping
			if (entityType.equalsIgnoreCase("User")) {
				for (HashMap<String, Object> item : data) {
					out.append(updateStudentPlayList(entityId, (int) item.get("module_id"), (int) item.get("cmsession_id"),(int) item.get("course_id"), (int) item.get("lesson_id"),
							entityType, entityId));
				}
			}

			// batch group mapping
			else if (entityType.equalsIgnoreCase("Group") || entityType.equalsIgnoreCase("Role") ) {				
				//create Student PlayList
				CustomReport rep = repUtils.getReport(16); 				
				sql = rep.getSql();
				sql = sql.replaceAll(":batch_group_id", entityId+"");
					
				System.err.println(sql);
				List<HashMap<String, Object>> result = db.executeQuery(sql);

				for (HashMap<String, Object> item : result) {
					for (HashMap<String, Object> resultitem : data) {
						out.append(
								updateStudentPlayList((int) item.get("student_id"), (int) resultitem.get("module_id"),
										(int) resultitem.get("cmsession_id"), (int) resultitem.get("course_id"),
										(int) resultitem.get("lesson_id"), entityType, entityId));
					}
				}

			}
			
			
			//create batches
			if(skillType.equalsIgnoreCase("COURSE"))
			{
				if(entityType.equalsIgnoreCase("Role"))
				{
					BatchGroup role = new BatchGroupDAO().findById(entityId);
					// create batch in role and in group also
					CustomReport rep = repUtils.getReport(17); 				
					sql = rep.getSql();
					sql = sql.replaceAll(":batch_group_id", entityId+"");
					sql = sql.replaceAll(":skill_objective_id", skillId+"");					
					List<HashMap<String, Object>> getCourseIDs = db.executeQuery(sql);
					for(HashMap<String, Object> courseRow: getCourseIDs)
					{
						int courseId = (int) courseRow.get("course_id");
						Course course = new CourseDAO().findById(courseId);
						CustomReport rep2 = repUtils.getReport(18);
						String insertIntoBatch=rep2.getSql();
						insertIntoBatch = insertIntoBatch.replaceAll(":batch_name", role.getName()+" - "+course.getCourseName().replaceAll("'",""));
						insertIntoBatch = insertIntoBatch.replaceAll(":bg_id", entityId+"");
						insertIntoBatch = insertIntoBatch.replaceAll(":course_id", courseId+"");
						int year = Calendar.getInstance().get(Calendar.YEAR);
						insertIntoBatch = insertIntoBatch.replaceAll(":year", year+"");
						db.executeUpdate(insertIntoBatch);
						
						CustomReport childRep= repUtils.getReport(19);
						String getChildGroup=childRep.getSql();
						getChildGroup = getChildGroup.replaceAll(":parent_group_id", entityId+"");
						List<HashMap<String, Object>> childGroups = db.executeQuery(getChildGroup);
						for(HashMap<String, Object> childGroupRow : childGroups)
						{
							int childbgId = (int)childGroupRow.get("id");
							String childBGName = (String)childGroupRow.get("name").toString().replaceAll("'","");
							CustomReport dd = repUtils.getReport(20);
							String qq = dd.getSql().replaceAll(":course_id", courseId+"").replaceAll(":batch_group_id", childbgId+"");
							if((int)db.executeQuery(qq).get(0).get("count") == 0)
							{
								//create batch for child group
								CustomReport rep3 = repUtils.getReport(18);
								String insertIntoChildBatch=rep3.getSql();
								insertIntoChildBatch = insertIntoChildBatch.replaceAll(":batch_name", childBGName+" - "+course.getCourseName().replaceAll("'",""));
								insertIntoChildBatch = insertIntoChildBatch.replaceAll(":bg_id", childbgId+"");
								insertIntoChildBatch = insertIntoChildBatch.replaceAll(":course_id", courseId+"");							
								insertIntoChildBatch = insertIntoChildBatch.replaceAll(":year", year+"");
								db.executeUpdate(insertIntoChildBatch);
							}
							
						}
						
					}
					
				}
				else if(entityType.equalsIgnoreCase("Group"))
				{
					//create batch in only group
					BatchGroup section = new BatchGroupDAO().findById(entityId);
					// create batch in role and in group also
					CustomReport rep = repUtils.getReport(17); 				
					sql = rep.getSql();
					sql = sql.replaceAll(":batch_group_id", entityId+"");
					sql = sql.replaceAll(":skill_objective_id", skillId+"");					
					List<HashMap<String, Object>> getCourseIDs = db.executeQuery(sql);
					for(HashMap<String, Object> courseRow: getCourseIDs)
					{
						int courseId = (int) courseRow.get("course_id");
						Course course = new CourseDAO().findById(courseId);
						CustomReport rep2 = repUtils.getReport(18);
						String insertIntoBatch=rep2.getSql();
						insertIntoBatch = insertIntoBatch.replaceAll(":batch_name", section.getName()+" - "+course.getCourseName().replaceAll("'",""));
						insertIntoBatch = insertIntoBatch.replaceAll(":bg_id", entityId+"");
						insertIntoBatch = insertIntoBatch.replaceAll(":course_id", courseId+"");
						int year = Calendar.getInstance().get(Calendar.YEAR);
						insertIntoBatch = insertIntoBatch.replaceAll(":year", year+"");
						db.executeUpdate(insertIntoBatch);
					}	
				}
			}
			
			
			
			

		} catch (Exception e) {
		}
		return out;
	}

	public String updateStudentPlayList(int student_id, int module_id, int cmsession_id, int course_id, int lesson_id, String userType, int typeId) {
		DBUTILS db = new DBUTILS();
		Lesson lesson = new LessonDAO().findById(lesson_id);
		String appendingString = "";

		String sql = "select * from student_playlist where student_id=" + student_id + " and course_id=" + course_id
				+ " and lesson_id=" + lesson_id;

		List<HashMap<String, Object>> result = db.executeQuery(sql);

		if (result.size() == 0) {
			sql = "INSERT INTO student_playlist (id, student_id, course_id, lesson_id,module_id, cmsession_id, status) VALUES ((select COALESCE(max(id),0)+1 from student_playlist), '"
					+ student_id + "', '" + course_id + "', '" + lesson_id + "',"+module_id+","+cmsession_id+",'INCOMPLETE')";
			
			String tasksql="INSERT INTO task ( 	ID, 	NAME, 	task_type, 	priority, 	OWNER, 	actor, 	STATE, 	start_date, 	end_date, 	is_repeatative, 	is_active, 	created_at, 	updated_at, 	item_id, 	item_type )"
					+ "VALUES 	( 		( 			SELECT 				COALESCE (MAX(ID), 0) + 1 			FROM 				task 		), 		'LESSON', 		3, 		1, 	300, 		'"+student_id+"', 		'SCHEDULED', now(), now(), 		'f', 		't', 		now(), 		now(), 		"+lesson_id+", 		'LESSON' 	);";				
			db.executeUpdate(tasksql);
			
			System.err.println(sql);
			db.executeUpdate(sql);
			if (!lessonList.contains(lesson_id)) {
				appendingString = "<div class='alert alert-dismissable gray-bg'>"
						+ "<button aria-hidden='true' data-dismiss='alert' class='close' data-content-type='" + userType
						+ "' data-role='" + typeId + "' data-role_skill='" + lesson_id + "' type='button'>x</button>"
						+ lesson.getTitle() + "</div>";
			} else {
				System.out.println("contains");
			}
			lessonList.add(lesson_id);
		} else {
			System.out.println("Skill ALready Avilable--->student_id:" + student_id + " course_id:" + course_id
					+ " lesson_id:" + lesson_id);
		}
		return appendingString;
	}

	public String createcontentRolesMapping(int courseId, int lessonId, String userType, int typeId) {
		String appendingString = "";
		try {
			DBUTILS db = new DBUTILS();
			Lesson lesson = new LessonDAO().findById(lessonId);

			// create cmssession
			String sql = "INSERT INTO cmsession ( id, 	title, 	uploader_admin_id, 	description, 	order_id, 	is_deleted ) VALUES 	( (select COALESCE(max(id),0)+1 from cmsession), 		'contentRolesMapping_session_"
					+ courseId + "', 		'3', 		'skill_desc" + courseId
					+ "', 		(select COALESCE(max(id),0)+1 from cmsession), 		'f' 	) returning id";
			System.err.println(sql);
			int cmssession = (int) db.executeUpdateReturn(sql);

			// create module
			sql = "INSERT INTO module (id, module_name, order_id) VALUES ((select COALESCE(max(id),0)+1 from module), 'contentRolesMapping_module_"
					+ courseId + "', (select COALESCE(max(id),0)+1 from module))returning id";
			System.err.println(sql);
			int module_id = (int) db.executeUpdateReturn(sql);

			// create cmsession_module mapping
			sql = "INSERT INTO cmsession_module (cmsession_id, module_id) VALUES ('" + cmssession + "', '" + module_id
					+ "')";
			System.err.println(sql);
			db.executeUpdate(sql);

			// create module_course mapping
			sql = "INSERT INTO module_course (module_id, course_id) VALUES ('" + module_id + "', '" + courseId + "')";
			System.err.println(sql);
			db.executeUpdate(sql);

			// map lessons
			sql = "INSERT INTO lesson_cmsession (lesson_id, cmsession_id) VALUES ('" + lessonId + "', '" + cmssession
					+ "')";
			System.err.println(sql);
			db.executeUpdate(sql);

			// "<button aria-hidden='true' data-dismiss='alert' class='close'
			// data-content-type='"+userType+"' data-role='"+typeId+"'
			// data-role_skill='"+lessonId+"' type='button'>x</button>"+
			appendingString = "<div class='alert alert-dismissable gray-bg'>" + lesson.getTitle() + "</div>";

		} catch (Exception e) {
			e.printStackTrace();
		}
		return appendingString;
	}

	public void deleteContentAssosicatedSkill(String userType, int typeId, int lessonId) {
		DBUTILS db = new DBUTILS();
		if (userType.equalsIgnoreCase("User")) {
			String sql = "DELETE FROM student_playlist WHERE 	student_id= " + typeId + " AND lesson_id=" + lessonId;
			System.err.println(sql);
			db.executeUpdate(sql);
		} else if (userType.equalsIgnoreCase("Group")) {

			String sql = "SELECT DISTINCT 	stu.student_id FROM 	batch_group bg, 	batch b, 	batch_students stu WHERE 	bg. ID = b.batch_group_id AND stu.batch_group_id = bg. ID AND bg. ID="
					+ typeId;
			System.err.println(sql);
			List<HashMap<String, Object>> data = db.executeQuery(sql);
			for (HashMap<String, Object> item : data) {
				sql = "DELETE FROM student_playlist WHERE 	student_id= " + item.get("student_id") + " AND lesson_id="
						+ lessonId;
				System.err.println(sql);
				db.executeUpdate(sql);
			}
		}
	}

	public List<HashMap<String, Object>> getAllCourseAvailable() {

		String sql = "select id,course_name from course ORDER BY course_name";

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAllBatchesAvailable(int batchGP) {

		String sql = "select id,name,course_id from batch b where b.batch_group_id=" + batchGP;

		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

}
