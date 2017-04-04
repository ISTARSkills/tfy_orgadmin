package in.orgadmin.admin.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.utilities.DBUTILS;

public class OrgAdminSkillService {

	ArrayList<Integer> lessonList = new ArrayList<>();

	public List<HashMap<String, Object>> getAllSkills() {

		String sql = "SELECT DISTINCT 	so. ID, 	so. NAME FROM 	skill_objective so, 	lesson_skill_objective lso WHERE 	so. NAME NOT LIKE '' AND so. TYPE = 'TASK_BASED' AND lso.learning_objectiveid = so.id ORDER BY 	NAME";

		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAllLessonSkills(int orgId) {

		String sql = "( 	SELECT 		skill_objective. ID, 		skill_objective. NAME, 		'COURSE' AS parent_type 	FROM 		skill_objective, 		course,    course_skill_objective 	WHERE course.id = course_skill_objective.course_id AND course_skill_objective.skill_objective_id = skill_objective.id 	AND course. ID IN ( 		SELECT DISTINCT 			course. ID 		FROM 			course, 			batch, 			batch_group 		WHERE 			course. ID = batch.course_id 		AND batch.batch_group_id = batch_group. ID 		AND batch_group.college_id = "
				+ orgId
				+ " 	) ) UNION 	( 		SELECT 			skill_objective. ID, 			skill_objective. NAME, 			'MODULE' AS parent_ype 		FROM 			skill_objective, 			MODULE, module_skill_objective 		WHERE MODULE.id = module_skill_objective.module_id AND module_skill_objective.skill_objective_id = skill_objective.id 		AND MODULE . ID IN ( 			SELECT DISTINCT 				module_course.module_id 			FROM 				course, 				batch, 				batch_group, 				module_course 			WHERE 				course. ID = batch.course_id 			AND batch.batch_group_id = batch_group. ID 			AND module_course.course_id = course. ID 			AND batch_group.college_id = "
				+ orgId
				+ " 		) 	) UNION 	( 		SELECT 			skill_objective. ID, 			skill_objective. NAME, 			'CMSESSION' AS parent_ype 		FROM 			skill_objective, 			cmsession, cmsession_skill_objective 		WHERE cmsession.id = cmsession_skill_objective.cmsession_id AND cmsession_skill_objective.skill_objective_id = skill_objective.id 		AND cmsession. ID IN ( 			SELECT DISTINCT 				cmsession_module.cmsession_id 			FROM 				course, 				batch, 				batch_group, 				module_course, 				cmsession_module 			WHERE 				course. ID = batch.course_id 			AND batch.batch_group_id = batch_group. ID 			AND module_course.course_id = course. ID 			AND cmsession_module.module_id = module_course.module_id 			AND batch_group.college_id = "
				+ orgId + " 		) 	) ORDER BY 	ID";

		// System.err.println(sql);
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
		int count = 0;
		String sql = "SELECT 	CAST (COUNT(T . ID) AS INT) FROM 	( 		SELECT DISTINCT 			istar_user. ID, 			istar_user.email AS NAME, 			COUNT ( 				DISTINCT student_playlist.lesson_id 			) 		FROM 			student_playlist, 			istar_user, user_org_mapping 		WHERE 			istar_user. ID = student_playlist.student_id AND istar_user.id = user_org_mapping.user_id 		AND user_org_mapping.organization_id = "+orgId+" 		GROUP BY 			istar_user.email, 			istar_user. ID 	) T";
		DBUTILS db = new DBUTILS();
		try {
			List<HashMap<String, Object>> data = db.executeQuery(sql);
			count = (int) data.get(0).get("count");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;

	}

	public List<HashMap<String, Object>> getAllContentUserList(int orgId, String type, int offset, String searchKey) {
		String sql = "";
		if (type.equalsIgnoreCase("User")) {

			String searchquery = "";
			if (searchKey != null && !searchKey.equalsIgnoreCase("")) {
				searchquery = " AND istar_user.email like '%" + searchKey + "%'";
			}

			sql = "SELECT DISTINCT 	istar_user. ID, 	istar_user.email AS NAME, 	COUNT ( 		DISTINCT student_playlist.lesson_id 	) FROM 	student_playlist, 	istar_user, user_org_mapping WHERE 	istar_user. ID = student_playlist.student_id AND istar_user. ID = user_org_mapping.user_id AND user_org_mapping.organization_id = "+ orgId + searchquery + " GROUP BY 	istar_user.email, 	istar_user. ID ORDER BY 	istar_user.email LIMIT 10 OFFSET  " + offset ;

		} else if (type.equalsIgnoreCase("Group")) {
			sql = "SELECT 	batch_group. ID, 	batch_group. NAME AS NAME, 	COUNT ( 		DISTINCT student_playlist.lesson_id 	) FROM 	batch_group LEFT JOIN batch_students ON ( 	batch_students.batch_group_id = batch_group. ID ) LEFT JOIN student_playlist ON ( 	student_playlist.student_id = batch_students.student_id ) WHERE 	batch_group.college_id = "
					+ orgId + " GROUP BY 	batch_group. ID, 	batch_group. NAME";
		} else if (type.equalsIgnoreCase("Role")) {
			sql = "SELECT DISTINCT 	course. ID, 	course.course_name AS NAME, 	COUNT ( 		DISTINCT lesson_cmsession.lesson_id 	) FROM 	batch, 	batch_group, 	module_course, 	cmsession_module, 	lesson_cmsession, 	course WHERE 	module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND course. ID = module_course.course_id AND batch.course_id = course. ID AND batch.batch_group_id = batch_group. ID AND batch_group.college_id = "
					+ orgId + " GROUP BY 	course. ID, 	course.course_name ORDER BY course.course_name";
		}
		System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAllContentAssosicatedSkills(int orgId, int typeId, String type) {

		String sql = "";
		if (type.equalsIgnoreCase("User")) {
			sql = "SELECT DISTINCT 	lesson.title AS lesson_title, 	lesson. ID AS lesson_id, 	course. ID AS course_id, 	course.course_name AS course_name FROM 	student_playlist, 	lesson, 	course WHERE 	course. ID = student_playlist.course_id AND lesson. ID = student_playlist.lesson_id AND student_id = "
					+ typeId + " order by course_name, lesson_title";
		} else if (type.equalsIgnoreCase("Group")) {
			sql = "SELECT DISTINCT 	lesson.title AS lesson_title, 	lesson. ID AS lesson_id, 	course. ID AS course_id, 	course.course_name AS course_name FROM 	student_playlist, 	lesson, 	course WHERE 	course. ID = student_playlist.course_id AND lesson. ID = student_playlist.lesson_id AND student_id in (select student_id from batch_students where batch_group_id ="
					+ typeId + " ) order by course_name, lesson_title";
		} else if (type.equalsIgnoreCase("Role")) {
			sql = "select distinct lesson.title AS lesson_title, 	lesson. ID AS lesson_id from lesson where id in ( SELECT DISTINCT 	lesson_cmsession.lesson_id FROM 	batch, 	batch_group, 	module_course, 	cmsession_module, 	lesson_cmsession, 	course WHERE 	module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id AND course. ID = module_course.course_id AND batch.course_id = course. ID AND batch.batch_group_id = batch_group. ID AND batch_group.college_id = "
					+ orgId + " and batch.course_id = " + typeId + " )";
		}
		// System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public StringBuffer createContentAssosicatedSkill(String userType, String skillType, int skillId, int typeId) {
		StringBuffer out = new StringBuffer();

		try {
			DBUTILS db = new DBUTILS();
			String sql = "";
			List<HashMap<String, Object>> data = new ArrayList<>();

			if (skillType.equalsIgnoreCase("COURSE")) {
				sql = "select distinct lesson_cmsession.lesson_id, module_course.course_id from module_course, cmsession_module, lesson_cmsession where module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = lesson_cmsession.cmsession_id and module_course.course_id = (select id from course where parent_skill_objective_id = "
						+ skillId + ") order by course_id";
				System.err.println(sql);
				data = db.executeQuery(sql);

			} else if (skillType.equalsIgnoreCase("MODULE")) {
				sql = "select distinct lesson_cmsession.lesson_id, module_course.course_id from module_course, cmsession_module, lesson_cmsession where module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = lesson_cmsession.cmsession_id and module_course.module_id = (select id from module where parent_skill_objective_id = "
						+ skillId + ") order by course_id";
				System.err.println(sql);
				data = db.executeQuery(sql);
			} else if (skillType.equalsIgnoreCase("CMSESSION")) {
				sql = "select distinct lesson_cmsession.lesson_id, module_course.course_id from module_course, cmsession_module, lesson_cmsession where module_course.module_id = cmsession_module.module_id and cmsession_module.cmsession_id = lesson_cmsession.cmsession_id and lesson_cmsession.cmsession_id = (select id from cmsession where parent_skill_objective_id = "
						+ skillId + ") order by course_id";
				System.err.println(sql);
				data = db.executeQuery(sql);
			}

			// user mapping
			if (userType.equalsIgnoreCase("User")) {
				for (HashMap<String, Object> item : data) {
					out.append(updateStudentPlayList(typeId, (int) item.get("course_id"), (int) item.get("lesson_id"),
							userType, typeId));
				}
			}

			// batch group mapping
			else if (userType.equalsIgnoreCase("Group")) {

				sql = "SELECT DISTINCT 	stu.student_id FROM 	batch_group bg, 	batch b, 	batch_students stu WHERE 	bg. ID = b.batch_group_id AND stu.batch_group_id = bg. ID AND bg. ID="
						+ typeId;
				System.err.println(sql);
				List<HashMap<String, Object>> result = db.executeQuery(sql);

				for (HashMap<String, Object> item : result) {
					for (HashMap<String, Object> resultitem : data) {
						out.append(
								updateStudentPlayList((int) item.get("student_id"), (int) resultitem.get("course_id"),
										(int) resultitem.get("lesson_id"), userType, typeId));
					}
				}

			}

			// role mapping
			else if (userType.equalsIgnoreCase("Role")) {
				for (HashMap<String, Object> item : data) {
					out.append(createcontentRolesMapping(typeId, (int) item.get("lesson_id"), userType, typeId));
				}
			}

		} catch (Exception e) {
		}
		return out;
	}

	public String updateStudentPlayList(int student_id, int course_id, int lesson_id, String userType, int typeId) {
		DBUTILS db = new DBUTILS();
		Lesson lesson = new LessonDAO().findById(lesson_id);
		String appendingString = "";

		String sql = "select * from student_playlist where student_id=" + student_id + " and course_id=" + course_id
				+ " and lesson_id=" + lesson_id;

		List<HashMap<String, Object>> result = db.executeQuery(sql);

		if (result.size() == 0) {
			sql = "INSERT INTO student_playlist (id, student_id, course_id, lesson_id, status) VALUES ((select COALESCE(max(id),0)+1 from student_playlist), '"
					+ student_id + "', '" + course_id + "', '" + lesson_id + "', 'INCOMPLETE')";
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
