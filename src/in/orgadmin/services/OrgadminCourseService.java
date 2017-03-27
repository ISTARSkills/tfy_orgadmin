/**
 * 
 */
package in.orgadmin.services;

import java.util.HashMap;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.apps.dao.Course;
import com.istarindia.apps.dao.CourseDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.TrainerCourse;
import com.istarindia.apps.dao.TrainerCourseDAO;

/**
 * @author Mayank
 *
 */
public class OrgadminCourseService {

	public List<HashMap<String, Object>> getLessons(int course_id) {
		DBUTILS util = new DBUTILS();
		String sql = "select lesson.id as id,  lesson.title as title, task.status as status from lesson, cmsession, module, course, task where lesson.session_id = cmsession.id and cmsession.module_id = module.id and course.id = module.course_id and task.item_id = lesson.id and task.status != 'DELETED' and task.item_type ='LESSON' and course.id = "
				+ course_id + " order by  lesson.title";
		System.out.println(sql);
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		return res;
	}

	public boolean updateTrainerCourse(int course_id, List<Integer> trainerList) {

		boolean flag = false;
		DBUTILS util = new DBUTILS();
		String sql1 = "delete from trainer_course where course_id = " + course_id;
		util.executeUpdate(sql1);

		Course course = new CourseDAO().findById(course_id);

		for (int x = 0; x < trainerList.size(); x++) {
			System.out.println("id" + trainerList.get(x));
			TrainerCourseDAO tcdao = new TrainerCourseDAO();
			StudentDAO studentDAO = new StudentDAO();
			Student student = new Student();
			student = studentDAO.findById(trainerList.get(x));
			TrainerCourse tc = new TrainerCourse();
			tc.setCourse(course);
			tc.setTrainer(student);
			Transaction t = null;
			Session s = null;

			try {
				s = tcdao.getSession();
				t = s.beginTransaction();
				tcdao.save(tc);
				t.commit();
				flag = true;
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				s.close();
			}

		}
		return flag;
	}

}
