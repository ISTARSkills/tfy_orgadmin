/**
 * 
 */
package in.orgadmin.utils;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.istarindia.apps.dao.Course;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Organization;
import com.istarindia.apps.dao.OrganizationDAO;

/**
 * @author Mayank
 *
 */
public class OrganizationUtils {

	public List<HashMap<String, Object>> getAllTrainers() {

		String sql = "select email, id , name from student where user_type = 'TRAINER' order by name";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		return data;
	}

	public ArrayList<Integer> getTraineravailableForCourse(Course c) {
		ArrayList<Integer> data = new ArrayList<>();
		String sql = "select distinct trainer_id from trainer_course where course_id=" + c.getId();
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> res = util.executeQuery(sql);
		for (HashMap<String, Object> row : res) {
			int traine_id = (int) row.get("trainer_id");
			data.add(traine_id);
		}

		return data;
	}

	public StringBuffer getOrganizationDetails(int org_id) {
		StringBuffer orgDetails = new StringBuffer();
		OrganizationDAO organizationDAO = new OrganizationDAO();
		Organization organization = organizationDAO.findById(org_id);
		// <p><%=b.getAddress().getAddressline1()%>,
		// <%=b.getAddress().getAddressline2()%>,
		// <%=b.getAddress().getPincode().getCity()%>,
		// <%=b.getAddress().getPincode().getState()%>,
		// <%=b.getAddress().getPincode().getCountry()%>,
		// <%=b.getAddress().getPincode().getPin()%></p>

		if (organization.getAddress() != null) {
			try {
				if (!organization.getAddress().getAddressline1().trim().isEmpty()) {
					orgDetails.append(organization.getAddress().getAddressline1().trim() + ", ");
				}
			} catch (Exception e) {
			}
			try {
				if (!organization.getAddress().getAddressline2().trim().isEmpty()) {
					orgDetails.append(organization.getAddress().getAddressline2().trim() + ", ");
				}
			} catch (Exception e) {
			}
			if (organization.getAddress().getPincode() != null) {
				try {
					if (!organization.getAddress().getPincode().getCity().trim().isEmpty()) {
						orgDetails.append(organization.getAddress().getPincode().getCity().trim() + ", ");
					}
				} catch (Exception e) {
				}
				try {
					if (!organization.getAddress().getPincode().getState().trim().isEmpty()) {
						orgDetails.append(organization.getAddress().getPincode().getState().trim() + ", ");
					}
				} catch (Exception e) {
				}
				try {
					if (!organization.getAddress().getPincode().getCountry().trim().isEmpty()) {
						orgDetails.append(organization.getAddress().getPincode().getCountry().trim() + ", ");
					}
				} catch (Exception e) {
				}
				try {
					if (!organization.getAddress().getPincode().getPin().toString().trim().isEmpty()) {
						orgDetails.append(organization.getAddress().getPincode().getPin().toString().trim());
					}
				} catch (Exception e) {
				}
			}
		}

		return orgDetails;
	}

	public StringBuffer getBatchGroupsInOrganization(Organization o) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "SELECT 	batch_group.id,batch_group.name, ( 		SELECT 			COUNT (*) 		FROM 			batch_students 		WHERE 			batch_group_id = batch_group. ID 	)as stu_count,( 		SELECT 			COUNT (*) 		FROM 			batch 		WHERE 			batch.batch_group_id = batch_group. ID 	) as batch_count FROM 	batch_group WHERE 	org_id = "
				+ o.getId() + " order by name";
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("<div class='table-responsive'>                                                      "
				+ "<table class='table table-striped table-bordered table-hover dataTables-example' >  "
				+ "<thead>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th># Student</th>                                                            "
				+ "    <th># Batches</th>                                                         "
				+ "    <th>View Details</th>                                                              "
				+ "</tr>                                                                               "
				+ "</thead>                                                                             ");

		for (HashMap<String, Object> row : data) {

			int id = (int) row.get("id");
			String name = (String) row.get("name");
			BigInteger stu_count = (BigInteger) row.get("stu_count");
			BigInteger batch_count = (BigInteger) row.get("batch_count");
			sb.append("<tbody>                                                                             "
					+ "<tr  style='font-size: 11px;'>                                                                 "
					+ "    <td>" + id + "</td>                                                                "
					+ "    <td>" + name + "</td>  " + "    <td>" + stu_count.intValue()
					+ "</td>                                                                " + "    <td>"
					+ batch_count.intValue() + "</td>  "

					+ "    <td><a target='_new' href='/orgadmin/batch_group/dashboard.jsp?batch_group_id=" + id
					+ "' >View Details</a></td>  "
					+ "</tr>                                                                               "
					+ "                                                                                    "
					+ "</tbody>                                                                            " + "");

		}

		sb.append("<tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th># Student</th>                                                            "
				+ "    <th># Batches</th>                                                         "
				+ "    <th>View Details</th>                                                              "
				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                                                            "
				+ "    </div>                                                                          "
				+ "                                                                                    " + "</div> "
				+ "");

		return sb;
	}

	public StringBuffer getStudentsInOrganization(Organization o) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "select id, email, name, gender, password, mobile  from student where organization_id=" + o.getId()
				+ " and user_type!='PRESENTOR' order by name";
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("<div class='table-responsive'>                                                      "
				+ "<table class='table table-striped table-bordered table-hover dataTables-example' >  "
				+ "<thead>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th>Email</th>                                                            "
				+ "    <th>Password</th>                                                         "
				+ "    <th>Gender</th>                                                              "
				+ "    <th>Mobile</th>                                                              "
				+ "    <th>Profile</th>                                                              "
				+ "</tr>                                                                               "
				+ "</thead>                                                                             ");

		for (HashMap<String, Object> row : data) {

			int id = (int) row.get("id");
			String name = (String) row.get("name");
			String email = (String) row.get("email");
			String gender = (String) row.get("gender");
			String password = (String) row.get("password");
			BigInteger mobile = (BigInteger) row.get("mobile");
			sb.append("<tbody>                                                                             "
					+ "<tr  style='font-size: 11px;'>                                                                 "
					+ "    <td>" + id + "</td>                                                                "
					+ "    <td>" + name + "</td>  " + "    <td>" + email
					+ "</td>                                                                " + "    <td>" + password
					+ "</td>  " + "    <td>" + gender
					+ "</td>                                                                " + "    <td>"
					+ mobile.intValue() + "</td>  "
					+ "    <td><a target='_new' href='/student/dashboard.jsp?student_id=" + id + "'>Profile</a></td>  "
					+ "</tr>                                                                               "
					+ "                                                                                    "
					+ "</tbody>                                                                            " + "");

		}

		sb.append("<tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "    <th>Id</th>                                                       "
				+ "    <th>Name</th>                                                                "
				+ "    <th>Email</th>                                                            "
				+ "    <th>Password</th>                                                         "
				+ "    <th>Gender</th>                                                              "
				+ "    <th>Mobile</th>                                                              "
				+ "    <th>View Details</th>                                                              "
				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                                                            "
				+ "    </div>                                                                          "
				+ "                                                                                    " + "</div> "
				+ "");

		return sb;
	}

	public List<HashMap<String, Object>> getEventPerOrganization(Organization c) {
		String sql = "SELECT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour,bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	bse.batch_id AS batch_id, 	s. ID AS trainer_id, CD.classroom_identifier, CD.id as class_id, B.name as batch_name "
				+ "FROM 	student s, 	batch_schedule_event bse, 	batch B, 	batch_group BG, classroom_details CD, 	college org WHERE CD.id = bse.classroom_id  and	BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID AND org.id="
				+ c.getId()
				+ " and  s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate";

		DBUTILS utilss = new DBUTILS();
		List<HashMap<String, Object>> res = utilss.executeQuery(sql);
		return res;
	}
	
	public List<HashMap<String, Object>> getEventAllOrganization() {
		String sql = "SELECT 	bse.eventdate AS eventdate, 	bse.event_name AS event_name, 	CAST (bse. ID AS VARCHAR(50)) AS ID, 	bse.eventhour AS bse_eventhour, 	bse.eventminute AS bse_eventmin, 	bse.status AS bse_status, 	org. ID AS org_id, 	org. NAME AS org_name, 	s. NAME AS trainer_name, 	bse.batch_id AS batch_id, 	s. ID AS trainer_id, 	CD.classroom_identifier, 	CD. ID AS class_id, 	B. NAME AS batch_name FROM 	student s, 	batch_schedule_event bse, 	batch B, 	batch_group BG, 	classroom_details CD, 	college org "
				+ "WHERE 	CD. ID = bse.classroom_id AND BG. ID = B.batch_group_id AND bse.batch_id = B. ID AND BG.college_id = org. ID AND bse.actor_id = s. ID  AND s.user_type = 'TRAINER' AND event_name NOT LIKE '%TEST%' AND bse. TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' ORDER BY 	bse.eventdate ";
		DBUTILS utilss = new DBUTILS();
		List<HashMap<String, Object>> res = utilss.executeQuery(sql);
		return res;
	}

}
