package in.orgadmin.admin.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Lesson;
import com.istarindia.apps.dao.LessonDAO;

public class OrgAdminSkillService {

	ArrayList<Integer> lessonList = new ArrayList<>();

	public List<HashMap<String, Object>> getAllSkills() {

		String sql = "SELECT DISTINCT 	so. ID, 	so. NAME FROM 	skill_objective so, 	lesson_skill_objective lso WHERE 	so. NAME NOT LIKE '' AND so. TYPE = 'TASK_BASED' AND lso.skill_objective_id = so. ID ORDER BY 	NAME";

		//System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAllLessonSkills(int orgId) {

		String sql = "(select skill_objective.id , skill_objective.name , 'COURSE' as parent_type from skill_objective , course where course.parent_skill_objective_id = skill_objective.id and course.id in (select distinct course.id  from course, batch, batch_group where course.id = batch.course_id and batch.batch_group_id = batch_group.id and batch_group.college_id ="
				+ orgId
				+ ")  )union   (select skill_objective.id , skill_objective.name , 'MODULE' as parent_ype from skill_objective , module where module.parent_skill_objective_id = skill_objective.id and module.id in (select distinct module_course.module_id from course, batch, batch_group, module_course where course.id = batch.course_id and batch.batch_group_id = batch_group.id and module_course.course_id = course.id and batch_group.college_id ="
				+ orgId
				+ ") ) union   (select skill_objective.id , skill_objective.name , 'CMSESSION' as parent_ype from skill_objective , cmsession where cmsession.parent_skill_objective_id = skill_objective.id and cmsession.id in (select distinct cmsession_module.cmsession_id from course, batch, batch_group, module_course, cmsession_module where course.id = batch.course_id and batch.batch_group_id = batch_group.id and module_course.course_id = course.id and cmsession_module.module_id = module_course.module_id and batch_group.college_id ="
				+ orgId + ") ) order by id";

		//System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getAdminRoleList(int orgId) {

		String sql = "SELECT distinct 	t1. ID, 	t1.role_name, 	COUNT (t1.sid) AS role_skill_count FROM 	( 		SELECT DISTINCT 			C . ID, 			C .course_name AS role_name, 			skill_objective. ID AS sid 		FROM 			course C 		LEFT JOIN module_course ON ( 			module_course.course_id = C . ID 		) 		LEFT JOIN cmsession_module ON ( 			module_course.module_id = cmsession_module.module_id 		) 		LEFT JOIN lesson_cmsession ON ( 			cmsession_module.cmsession_id = lesson_cmsession.cmsession_id 		) 		LEFT JOIN lesson_skill_objective ON ( 			lesson_cmsession.lesson_id = lesson_skill_objective.lesson_id 		) 		LEFT JOIN skill_objective ON ( 			skill_objective. ID = lesson_skill_objective.skill_objective_id 			AND skill_objective. TYPE = 'TASK_BASED' 		) 		LEFT JOIN batch ON ( 			batch.course_id = module_course.course_id 		) 		LEFT JOIN batch_group ON ( 			batch.batch_group_id = batch_group. ID 			AND batch_group.college_id = "+orgId+" 		) 	) t1 GROUP BY 	t1. ID, 	t1.role_name ORDER BY 	t1.role_name";

		//System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}

	public List<HashMap<String, Object>> getSkillAssosicatedRoleList(int orgId, int roleId) {

		String sql = "SELECT distinct skill_objective.name,skill_objective.id, module_course.course_id FROM 	module_course, 	cmsession_module, 	lesson_cmsession, 	batch, batch_group, lesson_skill_objective, skill_objective WHERE 	module_course.module_id = cmsession_module.module_id AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id and batch.course_id = module_course.course_id and batch.batch_group_id = batch_group.id and lesson_cmsession.lesson_id = lesson_skill_objective.lesson_id and skill_objective.id  =  lesson_skill_objective.skill_objective_id and batch_group.college_id = "
				+ orgId + " and batch.course_id = " + roleId
				+ " and skill_objective.type ='TASK_BASED' order by skill_objective.name, module_course.course_id";

		//System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;

	}

	public void deleteSkillAssosicatedRole(int roleskillId, int roll_id) {
		String sql = "DELETE FROM role_skill_mapping rs WHERE 	rs.role_id = " + roll_id + " AND rs. ID = "
				+ roleskillId;
		//System.err.println(sql);
		DBUTILS db = new DBUTILS();
		db.executeUpdate(sql);
	}

	public void createSkillAssosicatedRole(int skillId, int rollId) {

		try {
			DBUTILS db = new DBUTILS();

			// create cmssession
			String sql = "INSERT INTO cmsession ( id, 	title, 	uploader_admin_id, 	description, 	order_id, 	is_deleted ) VALUES 	( (select COALESCE(max(id),0)+1 from cmsession), 		'skill_session_"
					+ skillId + rollId + "', 		'3', 		'skill_desc" + skillId + rollId
					+ "', 		(select COALESCE(max(id),0)+1 from cmsession), 		'f' 	) returning id";
			//System.err.println(sql);
			int cmssession = (int) db.executeUpdateReturn(sql);

			// create module
			sql = "INSERT INTO module (id, module_name, order_id) VALUES ((select COALESCE(max(id),0)+1 from module), 'skill_session"
					+ skillId + rollId + "', (select COALESCE(max(id),0)+1 from module))returning id";
			//System.err.println(sql);
			int module_id = (int) db.executeUpdateReturn(sql);

			// create cmsession_module mapping
			sql = "INSERT INTO cmsession_module (cmsession_id, module_id) VALUES ('" + cmssession + "', '" + module_id
					+ "')";
			//System.err.println(sql);
			db.executeUpdate(sql);

			// create module_course mapping
			sql = "INSERT INTO module_course (module_id, course_id) VALUES ('" + module_id + "', '" + rollId + "')";
			//System.err.println(sql);
			db.executeUpdate(sql);

			// get list of lessons
			sql = "SELECT DISTINCT 	l_s_o.lesson_id FROM 	skill_objective sk_obj, 	lesson_skill_objective l_s_o WHERE 	sk_obj. ID = "
					+ skillId + " AND l_s_o.skill_objective_id = sk_obj. ID";
			//System.err.println(sql);
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			for (HashMap<String, Object> item : data) {
				//System.out.println("lesson_id------->" + item.get("lesson_id"));
				sql = "INSERT INTO lesson_cmsession (lesson_id, cmsession_id) VALUES ('" + item.get("lesson_id")
						+ "', '" + cmssession + "')";
				//System.err.println(sql);
				db.executeUpdate(sql);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	public int getTotalUsers(int orgId){
		int count=0;
		String sql = "select CAST (COUNT(T . ID) AS INT) from (SELECT DISTINCT 	student. ID, 	student.email AS NAME, 	COUNT ( 		DISTINCT student_playlist.lesson_id 	) FROM 	student_playlist, 	student WHERE 	student. ID = student_playlist.student_id AND student.organization_id ="+orgId+" GROUP BY 	student.email, 	student. ID)t"; 
		//System.out.println("sql---"+sql);
		DBUTILS db = new DBUTILS();
		try{
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		count=(int)data.get(0).get("count");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return count;
		
	}

	public List<HashMap<String, Object>> getAllContentUserList(int orgId, String type,int offset,String searchKey) {
		String sql = "";
		if (type.equalsIgnoreCase("User")) {
			
			String searchquery=""; 
			if(searchKey!=null && !searchKey.equalsIgnoreCase("")){
				searchquery=" AND student.email like '%"+searchKey+"%'";
			}
			
			sql = "SELECT DISTINCT student.id,student.email as name,count(distinct student_playlist.lesson_id) FROM 	student_playlist, student WHERE student.id = student_playlist.student_id and student.organization_id="
					+ orgId + searchquery+" group by student.email, student.id order by student.email limit 10 offset "+offset;
			
		} else if (type.equalsIgnoreCase("Group")) {
			sql = "SELECT 	batch_group. ID, 	batch_group. NAME AS NAME, 	COUNT ( 		DISTINCT student_playlist.lesson_id 	) FROM 	batch_group LEFT JOIN batch_students ON ( 	batch_students.batch_group_id = batch_group. ID ) LEFT JOIN student_playlist ON ( 	student_playlist.student_id = batch_students.student_id ) WHERE 	batch_group.college_id = "+orgId+" GROUP BY 	batch_group. ID, 	batch_group. NAME";
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
		//System.err.println(sql);
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

		//System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}
	
	public List<HashMap<String, Object>> getAllBatchesAvailable(int batchGP) {

		String sql = "select id,name,course_id from batch b where b.batch_group_id="+batchGP;

		//System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}
	
}
