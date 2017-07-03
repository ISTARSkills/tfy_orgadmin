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
