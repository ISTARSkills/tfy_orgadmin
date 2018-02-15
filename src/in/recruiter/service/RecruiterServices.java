package in.recruiter.service;

import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;


public class RecruiterServices {

	
	public List<HashMap<String, Object>> getStudentRatingPerskill(int student_id)
	{
		HashMap<String, String> data = new HashMap<>();
		String sql = "SELECT 	skill.skill_title, skill.id, 	CAST ( 		T .percentile_country AS INTEGER 	) FROM 	skill, 	( 		WITH summary AS ( 			SELECT 				P . ID, 				P .skill_id, 				P .percentile_country, 				ROW_NUMBER () OVER ( 					PARTITION BY P .skill_id 					ORDER BY 						P . TIMESTAMP DESC 				) AS rk 			FROM 				skill_precentile P 			WHERE 				P .student_id = "+student_id+" 		) SELECT 			s.* 		FROM 			summary s 		WHERE 			s.rk = 1 	) T WHERE 	T .skill_id = skill. ID AND skill. ID != 0 AND SKILL.parent_skill = 0 and T.skill_id in (select TTT.id from (WITH RECURSIVE menu_tree ( 	ID, 	skill_title, 	 	LEVEL, 	parent_skill ) AS ( 	SELECT 		ID, 		skill_title, 		0, 		parent_skill 	FROM 		skill 	WHERE 		parent_skill = - 1 	UNION ALL 		SELECT 			mn. ID, 			mn.skill_title, 			mt. LEVEL + 1, 			mt. ID 		FROM 			skill mn, 			menu_tree mt 		WHERE 			mn.parent_skill = mt. ID ) SELECT 	* FROM 	menu_tree WHERE 	LEVEL > 0 ORDER BY 	LEVEL, 	parent_skill ) TTT where TTT.level<=2 )ORDER BY 	T .percentile_country DESC";
		//ViksitLogger.logMSG(this.getClass().getName(),sql);
		DBUTILS utils = new DBUTILS();
		return utils.executeQuery(sql);
	}
	
	
}