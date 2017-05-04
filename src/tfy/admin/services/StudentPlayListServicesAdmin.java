/**
 * 
 */
package tfy.admin.services;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * @author mayank
 *
 */
public class StudentPlayListServicesAdmin {

	public void createStudentPlayList(int student_id, int course_id, int module_id, int cmsession_id, int lesson_id)
	{
		DBUTILS util = new DBUTILS();
		String sql = "select * from student_playlist where student_id=" + student_id + " and course_id=" + course_id
				+ " and lesson_id=" + lesson_id+" and module_id="+module_id+" and cmsession_id="+cmsession_id;
		
		if(util.executeQuery(sql).size()==0)
		{
			String insertSql = "INSERT INTO student_playlist (id, student_id, course_id, lesson_id,module_id, cmsession_id, status) VALUES ((select COALESCE(max(id),0)+1 from student_playlist), '"
					+ student_id + "', '" + course_id + "', '" + lesson_id + "',"+module_id+","+cmsession_id+",'INCOMPLETE')";	
			util.executeUpdate(insertSql);
		}
		
	}
}
