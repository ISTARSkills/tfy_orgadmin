package tfy.admin.trainer;

import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

public class CoordinatorSchedularUtil {
	DBUTILS utils = new DBUTILS();

	public List<HashMap<String, Object>> getCoursees() {
		String sql = "select id,course_name from course ORDER BY course_name";
		return utils.executeQuery(sql);
	}

	public List<HashMap<String, Object>> getInterViewersList() {
		String sql = "SELECT 	iu. ID, 	iu.email, 	r.role_name FROM 	istar_user iu, 	user_role ur, 	ROLE r WHERE 	iu. ID = ur.user_id AND ur.role_id = r. ID AND ur.role_id IN ( 	SELECT 		ID 	FROM 		ROLE 	WHERE 		role_name IN ( 			'MASTER_TRAINER', 			'SUPER_ADMIN', 			'COORDINATOR', 			'RECRUITER', 			'EXECUTIVE RECRUITER', 			'PANELIST' 		) )";
		return utils.executeQuery(sql);
	}

	public List<HashMap<String, Object>> getTrainerLists(String stage, int courseId) {
		String sql = "";
		switch (stage) {
		case "L4":
			sql = "SELECT DISTINCT 	te.trainer_id,iu.email FROM 	trainer_empanelment_status te, 	istar_user iu WHERE "
					+ "	te.trainer_id NOT IN ( 		SELECT 			trainer_id 		FROM 			trainer_empanelment_status te 		"
					+ "WHERE 			te.stage = 'L4' 	) AND te.stage = 'L3' AND te.empanelment_status = 'SELECTED' "
					+ "AND iu. ID = te.trainer_id AND te.course_id = " + courseId;
			break;
		case "L5":
			sql = "SELECT DISTINCT 	te.trainer_id,iu.email FROM 	trainer_empanelment_status te, 	istar_user iu WHERE "
					+ "	te.trainer_id NOT IN ( 		SELECT 			trainer_id 		FROM 			trainer_empanelment_status te 		"
					+ "WHERE 			te.stage = 'L5' 	) AND te.stage = 'L4' AND te.empanelment_status = 'SELECTED' "
					+ "AND iu. ID = te.trainer_id AND te.course_id = " + courseId;
			break;
		case "L6":
			sql = "SELECT DISTINCT 	te.trainer_id,iu.email FROM 	trainer_empanelment_status te, 	istar_user iu WHERE "
					+ "	te.trainer_id NOT IN ( 		SELECT 			trainer_id 		FROM 			trainer_empanelment_status te 		"
					+ "WHERE 			te.stage = 'L6' 	) AND te.stage = 'L5' AND te.empanelment_status = 'SELECTED' "
					+ "AND iu. ID = te.trainer_id AND te.course_id = " + courseId;
			break;
		default:
			break;
		}

		return utils.executeQuery(sql);
	}

}
