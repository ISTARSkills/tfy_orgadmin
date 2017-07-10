package tfy.admin.trainer;

import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

public class ClusterRequirmentUtil {
	DBUTILS dbutils = new DBUTILS();
	
	
	public List<HashMap<String, Object>> getCoursees() {
		String sql = "select id,course_name from course ORDER BY course_name";
		return dbutils.executeQuery(sql);
	}
	
	public List<HashMap<String, Object>> getTotalCount(){
		String sql="SELECT 	CAST(sum(COALESCE (FINAL_L2.l2count, 0))as INTEGER) AS l2count,  CAST (SUM (STATIC_TAB.req - COALESCE (Existing_TAB.exisisting, 0))AS INTEGER )AS net,CAST (SUM (COALESCE (STATIC_TAB.req, 0))AS INTEGER)AS requirement, 	CAST(sum(COALESCE (FINAL_L3.l3count, 0))as INTEGER) AS l3count, 	CAST(sum(COALESCE (FINAL_L4.l4count, 0))as INTEGER)AS l4count, 	CAST(sum(COALESCE (FINAL_L5.l5count, 0))as INTEGER) AS l5count, 	CAST(sum(COALESCE (FINAL_L6.l6count, 0)) as INTEGER)AS l6count FROM 	( 		SELECT 			COURSE_TAB.course_id, 			COURSE_TAB.course_name, 			CLUSTER . ID AS cluster_id, 			CLUSTER .cluster_name, 			COURSE_TAB.trainer_count AS req, 			COALESCE ( 				string_agg ( 					DISTINCT LOWER (pincode. STATE), 					', ' 				), 				'' 			) AS STATE 		FROM 			( 				SELECT DISTINCT 					course_id, 					course_name, 					cluster_id, 					trainer_count 				FROM 					cluster_requirement, 					course 				WHERE 					cluster_requirement.course_id = course. ID 			) COURSE_TAB 		LEFT JOIN CLUSTER ON ( 			COURSE_TAB.cluster_id = CLUSTER . ID 		) 		LEFT JOIN cluster_pincode_mapping cpm ON (cpm.cluster_id = CLUSTER . ID) 		LEFT JOIN pincode ON (pincode. ID = cpm.pincode_id) 		GROUP BY 			COURSE_TAB.course_id, 			COURSE_TAB.course_name, 			CLUSTER . ID, 			CLUSTER .cluster_name, 			COURSE_TAB.trainer_count 	) STATIC_TAB LEFT JOIN ( 	SELECT 		course_id, 		cluster_id, 		l4count 	FROM 		( 			SELECT 				COUNT (DISTINCT tes.trainer_id) AS l4count, 				tes.course_id, 				cpm.cluster_id 			FROM 				trainer_empanelment_status tes, 				trainer_prefred_location tpl, 				pincode, 				cluster_pincode_mapping cpm 			WHERE 				tes.trainer_id = tpl.trainer_id 			AND tpl.pincode = pincode.pin 			AND pincode. ID = cpm.pincode_id 			AND tes.stage = 'L4' 			AND tes.empanelment_status = 'SELECTED' 			GROUP BY 				course_id, 				cluster_id 		) L4_TAB ) FINAL_L4 ON ( 	FINAL_L4.course_id = STATIC_TAB.course_id 	AND FINAL_L4.cluster_id = STATIC_TAB.cluster_id ) LEFT JOIN ( 	SELECT 		course_id, 		cluster_id, 		l5count 	FROM 		( 			SELECT 				COUNT (DISTINCT tes.trainer_id) AS l5count, 				tes.course_id, 				cpm.cluster_id 			FROM 				trainer_empanelment_status tes, 				trainer_prefred_location tpl, 				pincode, 				cluster_pincode_mapping cpm 			WHERE 				tes.trainer_id = tpl.trainer_id 			AND tpl.pincode = pincode.pin 			AND pincode. ID = cpm.pincode_id 			AND tes.stage = 'L5' 			AND tes.empanelment_status = 'SELECTED' 			GROUP BY 				course_id, 				cluster_id 		) L5_TAB ) FINAL_L5 ON ( 	FINAL_L5.course_id = STATIC_TAB.course_id 	AND FINAL_L5.cluster_id = STATIC_TAB.cluster_id ) LEFT JOIN ( 	SELECT 		course_id, 		cluster_id, 		l6count 	FROM 		( 			SELECT 				COUNT (DISTINCT tes.trainer_id) AS l6count, 				tes.course_id, 				cpm.cluster_id 			FROM 				trainer_empanelment_status tes, 				trainer_prefred_location tpl, 				pincode, 				cluster_pincode_mapping cpm 			WHERE 				tes.trainer_id = tpl.trainer_id 			AND tpl.pincode = pincode.pin 			AND pincode. ID = cpm.pincode_id 			AND tes.stage = 'L6' 			AND tes.empanelment_status = 'SELECTED' 			GROUP BY 				course_id, 				cluster_id 		) L6_TAB ) FINAL_L6 ON ( 	FINAL_L6.course_id = STATIC_TAB.course_id 	AND FINAL_L6.cluster_id = STATIC_TAB.cluster_id ) LEFT JOIN ( 	SELECT 		course_id, 		cluster_id, 		exisisting 	FROM 		( 			SELECT 				tcs.course_id, 				cluster_requirement.cluster_id, 				COUNT (DISTINCT tcs.trainer_id) AS exisisting 			FROM 				trainer_empanelment_status tes 			LEFT JOIN trainer_prefred_location ON ( 				tes.trainer_id = trainer_prefred_location.trainer_id 			) 			LEFT JOIN pincode ON ( 				trainer_prefred_location.pincode = pincode.pin 			) 			LEFT JOIN cluster_pincode_mapping ON ( 				pincode. ID = cluster_pincode_mapping.pincode_id 			) 			LEFT JOIN cluster_requirement ON ( 				cluster_pincode_mapping.cluster_id = cluster_requirement.cluster_id 			) 			LEFT JOIN trainer_course_status ON ( 				cluster_requirement.course_id = trainer_course_status.course_id 			), 			trainer_course_status tcs 		WHERE 			tes.stage = 'L6' 		AND tes.empanelment_status = 'SELECTED' 		AND tes.trainer_id = tcs.trainer_id 		AND tcs.status = 'ACTIVE' 		AND cluster_requirement.cluster_id NOTNULL 		GROUP BY 			tcs.course_id, 			cluster_requirement.cluster_id 		) L6_TAB ) Existing_TAB ON ( 	Existing_TAB.course_id = STATIC_TAB.course_id 	AND Existing_TAB.cluster_id = STATIC_TAB.cluster_id ) LEFT JOIN ( 	SELECT 		course_id, 		cluster_id, 		l3count 	FROM 		( 			SELECT 				COUNT (DISTINCT tes.trainer_id) AS l3count, 				tes.course_id, 				cpm.cluster_id 			FROM 				trainer_empanelment_status tes, 				trainer_prefred_location tpl, 				pincode, 				cluster_pincode_mapping cpm 			WHERE 				tes.trainer_id = tpl.trainer_id 			AND tpl.pincode = pincode.pin 			AND pincode. ID = cpm.pincode_id 			AND tes.stage = 'L3' 			AND tes.empanelment_status = 'SELECTED' 			GROUP BY 				course_id, 				cluster_id 		) L3_TAB ) FINAL_L3 ON ( 	FINAL_L3.course_id = STATIC_TAB.course_id 	AND FINAL_L3.cluster_id = STATIC_TAB.cluster_id ) LEFT JOIN ( 	SELECT 		course_id, 		cluster_id, 		l2count 	FROM 		( 			SELECT 				COUNT (DISTINCT tes.trainer_id) AS l2count, 				tes.course_id, 				cpm.cluster_id 			FROM 				trainer_empanelment_status tes, 				trainer_prefred_location tpl, 				pincode, 				cluster_pincode_mapping cpm 			WHERE 				tes.trainer_id = tpl.trainer_id 			AND tpl.pincode = pincode.pin 			AND pincode. ID = cpm.pincode_id 			AND tes.stage = 'L2' 			AND tes.empanelment_status = 'SELECTED' 			GROUP BY 				course_id, 				cluster_id 		) L2_TAB ) FINAL_L2 ON ( 	FINAL_L2.course_id = STATIC_TAB.course_id 	AND FINAL_L2.cluster_id = STATIC_TAB.cluster_id )";
		System.out.println(sql);
		return dbutils.executeQuery(sql);
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

	public void addRequirment(int pincodePin,int courseId,int trainerCount) {

		String checkClutserReq = "SELECT distinct cr.id,cr.trainer_count from cluster_pincode_mapping cpm, cluster_requirement cr"
				+ " where cpm.pincode_id in (SELECT id from pincode where pin="+pincodePin+") and cpm.cluster_id=cr.cluster_id and cr.course_id="+courseId;
		System.out.println("checkClutserReq--"+checkClutserReq);
		
		List<HashMap<String, Object>> data = dbutils.executeQuery(checkClutserReq);

		if (data != null && data.size() != 0) {
			//cluster requirment update
			
			for(HashMap<String, Object> item:data){
				int clusterReqId=(int)item.get("id");
				int count=(int)item.get("trainer_count");
				count+=trainerCount;
				
				String updateClutserReq="UPDATE cluster_requirement set trainer_count="+count+" WHERE (id="+clusterReqId+")"; 
				System.out.println("updateClutserReq-"+updateClutserReq);
				dbutils.executeUpdate(updateClutserReq);
			}
			
		} else {
			//cluster req not availbale get clusterid and insert into requirment table
			String checkCluster="SELECT DISTINCT 	cluster_id FROM 	CLUSTER, 	cluster_pincode_mapping, 	pincode WHERE 	CLUSTER . ID = cluster_pincode_mapping.cluster_id AND cluster_pincode_mapping.pincode_id = pincode. ID AND pincode.pin ="+pincodePin;
			System.out.println("checkCluster--"+checkCluster);
			
			List<HashMap<String, Object>> clutersdata = dbutils.executeQuery(checkCluster);

			if (clutersdata != null && clutersdata.size() != 0) {
				for(HashMap<String, Object> item:clutersdata){
					int cluterId=(int)item.get("cluster_id");
					String createClutserReq="INSERT INTO cluster_requirement (id, cluster_id, course_id, trainer_count) VALUES ((select COALESCE(max(id),0) +1 from cluster_requirement), '"+cluterId+"', '"+courseId+"', '"+trainerCount+"');";
					System.out.println("createClutserReq-"+createClutserReq);
					dbutils.executeUpdate(createClutserReq);
				}
			}
		}
	}
}
