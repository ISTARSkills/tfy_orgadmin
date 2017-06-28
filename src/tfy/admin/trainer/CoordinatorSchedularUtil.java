package tfy.admin.trainer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
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

	
	public List<HashMap<String, Object>> getDashboardCardLists() {
		String sql = "SELECT 	t1.*, C .course_name, 	up.first_name FROM 	( 		( 			SELECT DISTINCT 				te.trainer_id, 				te.course_id, 				te.stage, 				iu.email 			FROM 				trainer_empanelment_status te, 				istar_user iu 			WHERE 				te.trainer_id NOT IN ( 					SELECT 						trainer_id 					FROM 						trainer_empanelment_status te 					WHERE 						te.stage = 'L4' 				) 			AND te.stage = 'L3' 			AND te.empanelment_status = 'SELECTED' 			AND iu. ID = te.trainer_id 		) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L5' 					) 				AND te.stage = 'L4' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L6' 					) 				AND te.stage = 'L5' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 	) t1, 	course C, 	user_profile up WHERE 	t1.course_id = C . ID AND t1.trainer_id = up.user_id";
		return utils.executeQuery(sql);
	}
	
	public List<HashMap<String, Object>> isAlreadyScheduled(String trainerId,String stage) {
		String sql = "SELECT * from interview_task_details where interviewee_id="+trainerId+" and stage='"+stage+"'";
		return utils.executeQuery(sql);
	}
	
	public String getStage(String stage){
		HashMap<String,String> stageNames=new HashMap<>();
		  stageNames.put("L1","Telephonic Interview (L1)");
		  stageNames.put("L2","Trainer SignUp (L2)");
		  stageNames.put("L3","Trainer Assessment (L3)");
		  stageNames.put("L4","SME Interview (L4)");
		  stageNames.put("L5","Demo (L5)");
		  stageNames.put("L6","Fitment Interview (L6)");
		  return stageNames.get(stage);
	}
}
