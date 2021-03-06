package in.superadmin.services;

import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

public class AccountManagementServices {
	DBUTILS dbutils = new DBUTILS();

	public List<HashMap<String, Object>> getAllCollegeList(String firstLetter) {
		String sql = "";
		//ViksitLogger.logMSG(this.getClass().getName(),"first letter>>"+firstLetter);
		if (firstLetter.equalsIgnoreCase("0")) {
			sql = "SELECT 	org. ID, 	org. NAME, 	cast (count(*) filter(where ur.role_id = (select id from role where role_name ='STUDENT')) as integer ) as count	 FROM 	organization org LEFT JOIN user_org_mapping uo ON (uo.organization_id = org. ID) LEFT JOIN istar_user s ON (s. ID = uo.user_id) left join user_role ur on (uo.user_id= ur.user_id)  GROUP BY 	org. ID, 	org. NAME ORDER BY 	org. NAME ";
		} else {
			sql = "SELECT 	org. ID, 	org. NAME, 	cast (count(*) filter(where ur.role_id = (select id from role where role_name ='STUDENT')) as integer ) as count	 FROM 	organization org LEFT JOIN user_org_mapping uo ON (uo.organization_id = org. ID) LEFT JOIN istar_user s ON (s. ID = uo.user_id) left join user_role ur on (uo.user_id= ur.user_id) WHERE 	LOWER (org. NAME) LIKE '"+firstLetter+"%' GROUP BY 	org. ID, 	org. NAME ORDER BY 	org. NAME";
		}
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		// //ViksitLogger.logMSG(this.getClass().getName(),sql);
		return items;
	}

	public String getOrgadminUrl(int orgId) {
		String sql = "select email,password from org_admin where organization_id=" + orgId;

		String url = "/login?email=vaibhav%40istarindia.com&password=test123";
		try {
			List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
			url = "/login?email=" + items.get(0).get("email") + "&password=" + items.get(0).get("password");
		} catch (Exception e) {

			//ViksitLogger.logMSG(this.getClass().getName(),("something went wrong in getiing ORGadmin URL for" + orgId);
			// e.printStackTrace();
		}
		return url;
	}

	public int getAllTotalCourses(int orgId) {
		String sql = "SELECT 	CAST ( 		COUNT (DISTINCT b.course_id) AS INTEGER 	) FROM 	batch_group bg, 	batch b WHERE 	bg. ID = b.batch_group_id AND bg.college_id ="
				+ orgId;

		// //ViksitLogger.logMSG(this.getClass().getName(),sql);
		int count = 0;
		try {

			List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
			count = (int) items.get(0).get("count");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;

	}

	public List<HashMap<String, Object>> getAllPrograms(int orgId) {
		String sql = "SELECT distinct b.course_id,c.course_name,count(DISTINCT bs.student_id) FROM 	batch_group bg, 	batch b,course c,   batch_students bs WHERE 	bg. ID = b.batch_group_id 	and bg.id=bs.batch_group_id and b.course_id=c.id AND bg.college_id = "
				+ orgId + " GROUP BY b.course_id,c.course_name";

		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		// //ViksitLogger.logMSG(this.getClass().getName(),sql);
		return items;
	}

	public List<HashMap<String, Object>> getAllBG(int courseId, int coleegeId) {
		String sql = "SELECT DISTINCT 	bg. ID, 	bg. NAME, CAST ( 		COUNT (DISTINCT student_id) AS INTEGER 	) AS stu_count FROM 	batch_group bg, 	batch b, batch_students WHERE batch_students.batch_group_id = bg. ID AND	bg.id = b.batch_group_id AND b.course_id = "
				+ courseId + " AND bg.college_id = " + coleegeId
				+ " GROUP BY 	bg. ID, 	bg. NAME ORDER BY 	bg. NAME";
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		//ViksitLogger.logMSG(this.getClass().getName(),sql);
		return items;
	}

}
