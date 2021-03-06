package in.orgadmin.admin.services;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.dao.entities.UserRole;
import com.viksitpro.core.dao.entities.UserRoleDAO;
import com.viksitpro.core.utilities.DBUTILS;

public class OrgAdminBatchGroupService {

	public ArrayList<Integer> getSelectedStudents(int groupId) {
		ArrayList<Integer> selectedStudents = new ArrayList();

		String sql = "select student_id from batch_students where batch_group_id=" + groupId;

		//ViksitLogger.logMSG(this.getClass().getName(),(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			selectedStudents.add((int) item.get("student_id"));
		}

		
		return selectedStudents;
	}

	public ArrayList<Integer> getSelectedBatchBgoups(int student_id) {
		ArrayList<Integer> selectedBG = new ArrayList();

		String sql = "select batch_group_id from batch_students where student_id=" + student_id;

		//ViksitLogger.logMSG(this.getClass().getName(),(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			selectedBG.add((int) item.get("batch_group_id"));
		}

		for (Integer integer : selectedBG) {
		}
		return selectedBG;
	}

	static String[] suffixes =
			// 0 1 2 3 4 5 6 7 8 9 *this is for date suffixes
			{ "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th",
					// 10 11 12 13 14 15 16 17 18 19
					"th", "th", "th", "th", "th", "th", "th", "th", "th", "th",
					// 20 21 22 23 24 25 26 27 28 29
					"th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th",
					// 30 31
					"th", "st" };

	public BatchGroup createBatchGroup(String groupName, String bg_desc, int studentCount, int org_id,
			int assessmentId, int parentGroupId, String groupType, String modeType,Date startDateInDateFormats, Boolean isPrimary, Boolean isHistorical) {
		BatchGroupDAO batchGroupDAO = new BatchGroupDAO();
		BatchGroup batchGroup = new BatchGroup();
		batchGroup.setName(groupName);
		batchGroup.setCreatedAt(new Timestamp(new Date().getTime()));
		batchGroup.setUpdatedAt(new Timestamp(new Date().getTime()));
		batchGroup.setBatchCode("" + getRandomInteger(100000, 999999));
		batchGroup.setAssessmentId(assessmentId);
		batchGroup.setBgDesc(bg_desc);
		batchGroup.setParentGroupId(parentGroupId);
		batchGroup.setType(groupType);
		batchGroup.setIsHistorical(isHistorical);
		batchGroup.setIsPrimary(isPrimary);
		java.sql.Date sqlDate =  new java.sql.Date(startDateInDateFormats.getTime());
		batchGroup.setStartDate(sqlDate);
		int year = Calendar.getInstance().get(Calendar.YEAR);
		batchGroup.setYear(year);
		batchGroup.setModeType(modeType);
		batchGroup.setOrganization(new OrganizationDAO().findById(org_id));
		batchGroup.setNumberOfStudents(studentCount);
		Session session = batchGroupDAO.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			batchGroupDAO.save(batchGroup);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			e.printStackTrace();
		} finally {
			session.close();
		}
		return batchGroup;
	}

	public BatchGroup updateBatchGroup(int bg_id, String groupName, String bg_desc, int studentCount, int org_id,
			int assessmentId, int parentGroupId, String groupType, String modeType, Date startDateInDateFormats, Boolean isPrimary, Boolean isHistorical) {
		BatchGroupDAO batchGroupDAO = new BatchGroupDAO();
		BatchGroup batchGroup = batchGroupDAO.findById(bg_id);
		batchGroup.setName(groupName);
		batchGroup.setCreatedAt(new Timestamp(new Date().getTime()));
		batchGroup.setUpdatedAt(new Timestamp(new Date().getTime()));
		batchGroup.setBgDesc(bg_desc);
		batchGroup.setType(groupType);
		batchGroup.setParentGroupId(parentGroupId);
		batchGroup.setAssessmentId(assessmentId);
		batchGroup.setModeType(modeType);
		batchGroup.setIsHistorical(isHistorical);
		batchGroup.setIsPrimary(isPrimary);
		batchGroup.setModeType(modeType);
		batchGroup.setNumberOfStudents(studentCount);
		java.sql.Date sqlDate =  new java.sql.Date(startDateInDateFormats.getTime());
		batchGroup.setStartDate(sqlDate);
		int year = Calendar.getInstance().get(Calendar.YEAR);
		batchGroup.setYear(year);
		batchGroup.setOrganization(new OrganizationDAO().findById(org_id));
		Session session = batchGroupDAO.getSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			batchGroupDAO.merge(batchGroup);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			e.printStackTrace();
		} finally {
			session.close();
		}
		return batchGroup;
	}

	public void createBGStudents(int batchGrpId, List<Integer> studentList) {
		// ExecutorService executor = Executors.newFixedThreadPool(50);
		boolean flag = false;
		DBUTILS util = new DBUTILS();

		//updateStudentPlayList(batchGrpId,studentList);
		String sql1 = "delete from batch_students where batch_group_id = " + batchGrpId;
		util.executeUpdate(sql1);
		
		for (int x = 0; x < studentList.size(); x++) {
			
			
			IstarUser istarUser = new IstarUser();
			istarUser = new IstarUserDAO().findById(studentList.get(x));
			UserRole userRole = new UserRole();
			UserRoleDAO userRoleDAO = new UserRoleDAO();
			String userType = "STUDENT";
		
			 userType = istarUser.getUserRoles().iterator().next().getRole().getRoleName()!= "" ? istarUser.getUserRoles().iterator().next().getRole().getRoleName():"";
			 
			 
			 

			String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0) from batch_students)+1),"
					+ batchGrpId + "," + istarUser.getId() + ",'" + userType + "')";
			util.executeUpdate(insert_into_bg);

			Date eventdate = new Date();
			DateFormat formatter1 = new SimpleDateFormat("MMM");
			DateFormat formatter2 = new SimpleDateFormat("hh:mm a");
			DateFormat formatDayOfMonth = new SimpleDateFormat("d");
			int day = Integer.parseInt(formatDayOfMonth.format(eventdate));
			String dayStr = day + suffixes[day];
			String n_date = formatter1.format(eventdate);
			String n_time = formatter2.format(eventdate);

			String title_new = "Batch: Added on " + n_date + " " + dayStr + "  " + n_time;

			

		}
		new AssessmentSchedulerService().createAssessmentNewEntryInBG(batchGrpId);

	}

	private void updateStudentPlayList(int batchGrpId, List<Integer> studentList) {
		ArrayList<Integer> studentsDeleted = new ArrayList<>();
		ArrayList<Integer> coursesInBG = new ArrayList<>();
		DBUTILS util = new DBUTILS();
		String selectCourses = "select distinct course_id from batch where batch_group_id=" + batchGrpId;
		List<HashMap<String, Object>> coursesData = util.executeQuery(selectCourses);
		for (HashMap<String, Object> row : coursesData) {
			int course_id = (int) row.get("course_id");
			coursesInBG.add(course_id);
		}

		String findStudentInBG = "select distinct student_id from batch_students  where batch_group_id=" + batchGrpId;
		List<HashMap<String, Object>> data = util.executeQuery(findStudentInBG);
		for (HashMap<String, Object> row : data) {
			int old_stu_id = (int) row.get("student_id");
			if (!studentList.contains(old_stu_id)) {
				studentsDeleted.add(old_stu_id);
			}
		}
		for (int stu : studentsDeleted) {
			for (int course_id : coursesInBG) {
				String deletePlayList = "delete from student_playlist where student_id =" + stu + " and course_id = "
						+ course_id + "";
				//ViksitLogger.logMSG(this.getClass().getName(),(deletePlayList);
				util.executeUpdate(deletePlayList);
			}
		}

		for (int stu : studentList) {
			for (int course_id : coursesInBG) {
				String findLesson = "SELECT DISTINCT 	lesson_cmsession.lesson_id FROM 	module_course, 	cmsession_module, 	lesson_cmsession WHERE 	module_course.module_id = cmsession_module.module_id "
						+ "AND cmsession_module.cmsession_id = lesson_cmsession.cmsession_id and module_course.course_id="
						+ course_id + "";
				List<HashMap<String, Object>> lessons = util.executeQuery(findLesson);
				for (HashMap<String, Object> lesson : lessons) {
					int lesson_id = (int) lesson.get("lesson_id");
					String sql = "select * from student_playlist where student_id=" + stu + " and course_id="
							+ course_id + " and lesson_id=" + lesson_id;

					List<HashMap<String, Object>> result = util.executeQuery(sql);

					if (result.size() == 0) {
						String sqlInsertStudentPl = "INSERT INTO student_playlist (id, student_id, course_id, lesson_id, status) VALUES ((select COALESCE(max(id),0)+1 from student_playlist), '"
								+ stu + "', '" + course_id + "', '" + lesson_id + "', 'INCOMPLETE')";

						//ViksitLogger.logMSG(this.getClass().getName(),(sqlInsertStudentPl);
						util.executeUpdate(sqlInsertStudentPl);
						
						String tasksql="INSERT INTO task ( 	ID, 	NAME, 	task_type, 	priority, 	OWNER, 	actor, 	STATE, 	start_date, 	end_date, 	is_repeatative, 	is_active, 	created_at, 	updated_at, 	item_id, 	item_type )VALUES 	( 		( 			SELECT 				COALESCE (MAX(ID), 0) + 1 			FROM 				task 		), 		'LESSON', 		3, 		1, 	300, 		'"+stu+"', 		'SCHEDULED', now(), now(), 		'f', 		't', 		now(), 		now(), 		"+lesson_id+", 		'LESSON' 	);";				
						util.executeUpdate(tasksql);

					}
				}

			}
		}

	}

	public void createorUpdateBGStudents(List<Integer> batch_groups, Integer student_id) {

		DBUTILS util = new DBUTILS();

		String sql1 = "delete from batch_students where student_id = " + student_id;
		util.executeUpdate(sql1);

		for (Integer bg_list : batch_groups) {

			
			
			IstarUser istarUser = new IstarUser();
			istarUser = new IstarUserDAO().findById(student_id);
			UserRole userRole = new UserRole();
			UserRoleDAO userRoleDAO = new UserRoleDAO();
			String userType = "STUDENT";
		
			 userType = istarUser.getUserRoles().iterator().next().getRole().getRoleName()!= "" ? istarUser.getUserRoles().iterator().next().getRole().getRoleName():"";
			

			String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0) from batch_students)+1),"
					+ bg_list + "," + istarUser.getId() + ",'" + userType + "')";
			util.executeUpdate(insert_into_bg);
			Date eventdate = new Date();
			DateFormat formatter1 = new SimpleDateFormat("MMM");
			DateFormat formatter2 = new SimpleDateFormat("hh:mm a");
			DateFormat formatDayOfMonth = new SimpleDateFormat("d");
			int day = Integer.parseInt(formatDayOfMonth.format(eventdate));
			String dayStr = day + suffixes[day];
			String n_date = formatter1.format(eventdate);
			String n_time = formatter2.format(eventdate);

			String title_new = "Batch: Added on " + n_date + " " + dayStr + "  " + n_time;

			
			new AssessmentSchedulerService().createAssessmentNewEntryInBG(bg_list);
		}
	}

	public static int getRandomInteger(int maximum, int minimum) {
		return ((int) (Math.random() * (maximum - minimum))) + minimum;
	}

	

}
