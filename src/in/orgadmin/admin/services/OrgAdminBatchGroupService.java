package in.orgadmin.admin.services;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.BatchGroupDAO;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;

import in.orgadmin.services.AssessmentSchedulerService;

public class OrgAdminBatchGroupService {

	public ArrayList<Integer> getSelectedStudents(int groupId) {
		ArrayList<Integer> selectedStudents = new ArrayList();

		String sql = "select student_id from batch_students where batch_group_id=" + groupId;

		System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			selectedStudents.add((int) item.get("student_id"));
		}

		for (Integer integer : selectedStudents) {
			System.out.println(integer);
		}
		return selectedStudents;
	}

	public ArrayList<Integer> getSelectedBatchBgoups(int student_id) {
		ArrayList<Integer> selectedBG = new ArrayList();

		String sql = "select batch_group_id from batch_students where student_id=" + student_id;

		System.err.println(sql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			selectedBG.add((int) item.get("batch_group_id"));
		}

		for (Integer integer : selectedBG) {
			System.out.println(integer);
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
			int assessmentId) {
		BatchGroupDAO batchGroupDAO = new BatchGroupDAO();
		BatchGroup batchGroup = new BatchGroup();
		batchGroup.setName(groupName);
		batchGroup.setMaxStudents(studentCount);
		batchGroup.setCreatedat(new Timestamp(new Date().getTime()));
		batchGroup.setUpdatedat(new Timestamp(new Date().getTime()));
		batchGroup.setBatchCode("" + getRandomInteger(100000, 999999));
		batchGroup.setAssessmentId(assessmentId);
		batchGroup.setBg_desc(bg_desc);
		batchGroup.setCollege(new CollegeDAO().findById(org_id));
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
			int assessmentId) {
		BatchGroupDAO batchGroupDAO = new BatchGroupDAO();
		BatchGroup batchGroup = batchGroupDAO.findById(bg_id);
		batchGroup.setName(groupName);
		batchGroup.setMaxStudents(studentCount);
		batchGroup.setCreatedat(new Timestamp(new Date().getTime()));
		batchGroup.setUpdatedat(new Timestamp(new Date().getTime()));
		batchGroup.setAssessmentId(assessmentId);
		batchGroup.setBg_desc(bg_desc);
		batchGroup.setCollege(new CollegeDAO().findById(org_id));
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

		updateStudentPlayList(batchGrpId,studentList);
		String sql1 = "delete from batch_students where batch_group_id = " + batchGrpId;
		util.executeUpdate(sql1);
		// BatchGroupDAO batchGroupDAO = new BatchGroupDAO();
		// BatchGroup batchGroup = batchGroupDAO.findById(batchGrpId);
		// BatchStudentsDAO batchStudentsDAO = new BatchStudentsDAO();
		for (int x = 0; x < studentList.size(); x++) {
			System.out.println("student-id " + studentList.get(x));
			StudentDAO studentDAO = new StudentDAO();
			Student student = new Student();
			student = studentDAO.findById(studentList.get(x));

			String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0) from batch_students)+1),"
					+ batchGrpId + "," + student.getId() + ",'" + student.getUserType() + "')";
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
			System.out.println("-------------------------------------------" + title_new);

			// use for notification to app

			/*
			 * String details_new = "" + batchGroup.getName(); String title =
			 * "Students in program " + batchGroup.getName() + " updated";
			 * String details = "Students in program " + batchGroup.getName() +
			 * " updated";
			 * 
			 * 
			 * 
			 * new NotificationService().createNONEventBasedNotification(
			 * details_new, student.getId(), 300, title_new,
			 * "UPDATE_BATCHGROUP", "NONE"); PublishDelegator pd = new
			 * PublishDelegator(); pd.sendNotification(student.getId(),
			 * title_new + " \n" + details_new, "BATCH", "UPDATE_BATCHGROUP",
			 * eventdate.toString());
			 */

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
		System.out.println("findStudentInBG>>>>" + findStudentInBG);
		List<HashMap<String, Object>> data = util.executeQuery(findStudentInBG);
		for (HashMap<String, Object> row : data) {
			int old_stu_id = (int) row.get("student_id");
			if (!studentList.contains(old_stu_id)) {
				studentsDeleted.add(old_stu_id);
			}
		}
		System.out.println("studentsDeleted>>>>>>>>" + studentsDeleted.size());
		for (int stu : studentsDeleted) {
			for (int course_id : coursesInBG) {
				String deletePlayList = "delete from student_playlist where student_id =" + stu + " and course_id = "
						+ course_id + "";
				System.err.println(deletePlayList);
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

						System.err.println(sqlInsertStudentPl);
						util.executeUpdate(sqlInsertStudentPl);

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

			System.out.println("student-id " + student_id);
			StudentDAO studentDAO = new StudentDAO();
			Student student = new Student();
			student = studentDAO.findById(student_id);

			String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0) from batch_students)+1),"
					+ bg_list + "," + student.getId() + ",'" + student.getUserType() + "')";
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
			System.out.println("-------------------------------------------" + title_new);

			// use for notification to app

			/*
			 * String details_new = "" + batchGroup.getName(); String title =
			 * "Students in program " + batchGroup.getName() + " updated";
			 * String details = "Students in program " + batchGroup.getName() +
			 * " updated";
			 * 
			 * 
			 * 
			 * new NotificationService().createNONEventBasedNotification(
			 * details_new, student.getId(), 300, title_new,
			 * "UPDATE_BATCHGROUP", "NONE"); PublishDelegator pd = new
			 * PublishDelegator(); pd.sendNotification(student.getId(),
			 * title_new + " \n" + details_new, "BATCH", "UPDATE_BATCHGROUP",
			 * eventdate.toString());
			 */
		}
	}

	public static int getRandomInteger(int maximum, int minimum) {
		return ((int) (Math.random() * (maximum - minimum))) + minimum;
	}

}
