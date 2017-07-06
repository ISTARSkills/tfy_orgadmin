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

	public List<HashMap<String, Object>> getDashboardCardListsL4() {
		//String sql = "SELECT 	t1.*, C .course_name, 	up.first_name FROM 	( 		( 			SELECT DISTINCT 				te.trainer_id, 				te.course_id, 				te.stage, 				iu.email 			FROM 				trainer_empanelment_status te, 				istar_user iu 			WHERE 				te.trainer_id NOT IN ( 					SELECT 						trainer_id 					FROM 						trainer_empanelment_status te 					WHERE 						te.stage = 'L4' 				) 			AND te.stage = 'L3' 			AND te.empanelment_status = 'SELECTED' 			AND iu. ID = te.trainer_id 		) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L5' 					) 				AND te.stage = 'L4' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L6' 					) 				AND te.stage = 'L5' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 	) t1, 	course C, 	user_profile up WHERE 	t1.course_id = C . ID AND t1.trainer_id = up.user_id";
		List<HashMap<String, Object>> finalData = new ArrayList<>();
		
		String sql ="select * from trainer_empanelment_status where stage ='L3' and empanelment_status ='SELECTED'";
		List<HashMap<String, Object>> l3clearedData = utils.executeQuery(sql);
		for(HashMap<String, Object> l3row: l3clearedData)
		{
			int trainerId = (int)l3row.get("trainer_id");
			int courseId = (int)l3row.get("course_id");
			String findPedningL4="select cast (count(*) as integer) as count  from trainer_empanelment_status where trainer_id = "+trainerId+" and course_id = "+courseId+" and stage='L4'";
			List<HashMap<String, Object>> l4Pending = utils.executeQuery(findPedningL4);
			if(l4Pending.size()>0 && l4Pending.get(0).get("count")!=null && (int)l4Pending.get(0).get("count")==0)
			{
				finalData.add(l3row);
			}
		}
		
		return finalData;
	}
	
	
	public static String createClassNameStage(String string) {
		String returnData = "";
		for (String iterable_element : string.split(",")) {
			try {
				returnData = returnData+ "stage_"+iterable_element+" ";
			} catch (Exception e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
			}
		}
		return returnData;
		
	}
	
	public List<HashMap<String, Object>> getDashboardCardListsL5() {
		//String sql = "SELECT 	t1.*, C .course_name, 	up.first_name FROM 	( 		( 			SELECT DISTINCT 				te.trainer_id, 				te.course_id, 				te.stage, 				iu.email 			FROM 				trainer_empanelment_status te, 				istar_user iu 			WHERE 				te.trainer_id NOT IN ( 					SELECT 						trainer_id 					FROM 						trainer_empanelment_status te 					WHERE 						te.stage = 'L4' 				) 			AND te.stage = 'L3' 			AND te.empanelment_status = 'SELECTED' 			AND iu. ID = te.trainer_id 		) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L5' 					) 				AND te.stage = 'L4' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L6' 					) 				AND te.stage = 'L5' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 	) t1, 	course C, 	user_profile up WHERE 	t1.course_id = C . ID AND t1.trainer_id = up.user_id";
		List<HashMap<String, Object>> finalData = new ArrayList<>();
		
		String sql ="select * from trainer_empanelment_status where stage ='L4' and empanelment_status ='SELECTED'";
		List<HashMap<String, Object>> l3clearedData = utils.executeQuery(sql);
		for(HashMap<String, Object> l3row: l3clearedData)
		{
			int trainerId = (int)l3row.get("trainer_id");
			int courseId = (int)l3row.get("course_id");
			String findPedningL4="select cast (count(*) as integer) as count  from trainer_empanelment_status where trainer_id = "+trainerId+" and course_id = "+courseId+" and stage='L5'";
			List<HashMap<String, Object>> l4Pending = utils.executeQuery(findPedningL4);
			if(l4Pending.size()>0 && l4Pending.get(0).get("count")!=null && (int)l4Pending.get(0).get("count")==0)
			{
				finalData.add(l3row);
			}
		}
		
		return finalData;
	}
	
	public List<HashMap<String, Object>> getDashboardCardListsL6() {
		//String sql = "SELECT 	t1.*, C .course_name, 	up.first_name FROM 	( 		( 			SELECT DISTINCT 				te.trainer_id, 				te.course_id, 				te.stage, 				iu.email 			FROM 				trainer_empanelment_status te, 				istar_user iu 			WHERE 				te.trainer_id NOT IN ( 					SELECT 						trainer_id 					FROM 						trainer_empanelment_status te 					WHERE 						te.stage = 'L4' 				) 			AND te.stage = 'L3' 			AND te.empanelment_status = 'SELECTED' 			AND iu. ID = te.trainer_id 		) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L5' 					) 				AND te.stage = 'L4' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L6' 					) 				AND te.stage = 'L5' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 	) t1, 	course C, 	user_profile up WHERE 	t1.course_id = C . ID AND t1.trainer_id = up.user_id";
		List<HashMap<String, Object>> finalData = new ArrayList<>();
		
		String sql ="select * from trainer_empanelment_status where stage ='L5' and empanelment_status ='SELECTED'";
		List<HashMap<String, Object>> l3clearedData = utils.executeQuery(sql);
		for(HashMap<String, Object> l3row: l3clearedData)
		{
			int trainerId = (int)l3row.get("trainer_id");
			int courseId = (int)l3row.get("course_id");
			String findPedningL4="select cast (count(*) as integer) as count  from trainer_empanelment_status where trainer_id = "+trainerId+" and course_id = "+courseId+" and stage='L6'";
			List<HashMap<String, Object>> l4Pending = utils.executeQuery(findPedningL4);
			if(l4Pending.size()>0 && l4Pending.get(0).get("count")!=null && (int)l4Pending.get(0).get("count")==0)
			{
				finalData.add(l3row);
			}
		}
		
		return finalData;
	}
	
	public List<HashMap<String, Object>> getCoursees() {
		String sql = "select id,course_name from course ORDER BY course_name";
		return utils.executeQuery(sql);
	}

	public List<HashMap<String, Object>> getInterViewersList() {
		String sql = "SELECT 	iu. ID, 	iu.email, 	r.role_name FROM 	istar_user iu, 	user_role ur, 	ROLE r WHERE 	iu. ID = ur.user_id AND ur.role_id = r. ID AND ur.role_id IN ( 	SELECT 		ID 	FROM 		ROLE 	WHERE 		role_name IN ('MASTER_TRAINER') )";
		return utils.executeQuery(sql);
	}

	
	public List<HashMap<String, Object>> getDashboardCardLists() {
		String sql = "SELECT 	t1.*, C .course_name, 	up.first_name FROM 	( 		( 			SELECT DISTINCT 				te.trainer_id, 				te.course_id, 				te.stage, 				iu.email 			FROM 				trainer_empanelment_status te, 				istar_user iu 			WHERE 				te.trainer_id NOT IN ( 					SELECT 						trainer_id 					FROM 						trainer_empanelment_status te 					WHERE 						te.stage = 'L4' 				) 			AND te.stage = 'L3' 			AND te.empanelment_status = 'SELECTED' 			AND iu. ID = te.trainer_id 		) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L5' 					) 				AND te.stage = 'L4' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 		UNION 			( 				SELECT DISTINCT 					te.trainer_id, 					te.course_id, 					te.stage, 					iu.email 				FROM 					trainer_empanelment_status te, 					istar_user iu 				WHERE 					te.trainer_id NOT IN ( 						SELECT 							trainer_id 						FROM 							trainer_empanelment_status te 						WHERE 							te.stage = 'L6' 					) 				AND te.stage = 'L5' 				AND te.empanelment_status = 'SELECTED' 				AND iu. ID = te.trainer_id 			) 	) t1, 	course C, 	user_profile up WHERE 	t1.course_id = C . ID AND t1.trainer_id = up.user_id";
		return utils.executeQuery(sql);
	}
	
	public List<HashMap<String, Object>> isAlreadyScheduled(String trainerId,String stage,int courseId) {
		String sql = "SELECT * from interview_task_details where interviewee_id="+trainerId+" and stage='"+stage+"' and course_id="+courseId;
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
	
	public List<HashMap<String, Object>> getAllInterviewQuestions(String stage,int courseId){
		String sql="";
		if(!stage.equalsIgnoreCase("") && courseId!=0){
			sql="SELECT * FROM interview_questions where course_id="+courseId+" and stage='"+stage+"'";
		}else{
			sql="SELECT * FROM interview_questions where stage='"+stage+"'";
		}
		return utils.executeQuery(sql);
	}
	
	
}
