/**
 * 
 */
package in.orgadmin.utils;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.hibernate.Query;

import com.istarindia.apps.dao.Batch;
import com.istarindia.apps.dao.BatchDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.TrainerBatch;

/**
 * @author Mayank
 *
 */
public class TrainerUtils {

	public StringBuffer getTrainersInOrganization() {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "SELECT 	ID, 	email, 	NAME, 	gender, 	PASSWORD, 	mobile FROM 	student WHERE  user_type = 'TRAINER' ORDER BY 	NAME ";
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
					+ "    <td><a target='_new' href='/trainer/dashboard.jsp?trainer_id=" + id + "'>Profile</a></td>  "
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
				+ "    <th>Profile</th>                                                              "
				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                                                            "
				+ "    </div>                                                                          "
				+ "                                                                                    " + "</div> "
				+ "");

		return sb;
	}

	public int getCompletionStatus(Batch b) {
		int status = 0;
		String sql = "SELECT 	cast(COUNT (*) as integer) FROM 	batch_schedule_event WHERE 	batch_id = " + b.getId()
				+ " and 	event_name NOT LIKE '%TESTING%' AND TYPE = 'BATCH_SCHEDULE_EVENT_TRAINER' and CURRENT_TIMESTAMP > eventdate ";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> prev_detail = util.executeQuery(sql);
		status = (int) prev_detail.get(0).get("count");
		status = (status * 100) / 30;
		return status;
	}

	public StringBuffer PrintBatchList(Student trainer, String baseURL) {
		StringBuffer sb = new StringBuffer();
		
		IstarUserDAO dao = new IstarUserDAO();//
		String hql = "SELECT DISTINCT 	batch.ID as batch_id FROM 	batch_schedule_event, 	batch, 	college, batch_group WHERE 	actor_id = "+trainer.getId()+""
				+ " AND batch_schedule_event.batch_id = batch. ID AND batch_group.id = batch.batch_group_id "
				+ "AND batch_group.college_id = college.id AND college.id != 2";
		
		System.out.println("------batch-------->"+ hql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(hql);

		//Set<TrainerBatch> tbs = trainer.getTrainerBatches();
		for (HashMap<String, Object> row : data) {
			Batch b =  new BatchDAO().findById(Integer.parseInt(row.get("batch_id").toString()));
			sb.append(" <tr>"

					+ "          <td class='project-title'>" + "          " + b.getName() + "-" + b.getName() + ""
					+ "                                          <br/>"
					+ "                                        <small>" + b.getBatchGroup().getCollege().getName()
					+ "</small>" + "                                  </td>"
					+ "                                  <td class='project-completion'>"
					+ "                                        <small>Completion with: " + getCompletionStatus(b)
					+ "%</small>" + "                                      <div class='progress progress-mini'>"
					+ "                                        <div style='width: " + getCompletionStatus(b)
					+ "%;' class='progress-bar'></div>" + "                                  </div>"
					+ "                        </td>" + "                      <td class='project-people'>");

			sb.append("          </td>" + "        <td class='project-actions'>" + "          <a href='" + baseURL
					+ "orgadmin/batch/dashboard.jsp?batch_id=" + b.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
					+ "        <a href='#' class='btn btn-primary btn-xs'><i class='fa fa-pencil'></i> Edit </a>"
					+ "  </td>" + "</tr>");
		}

		return sb;
	}
	
	public StringBuffer PrintStudentBatchList(Student user, String baseURL) {
		StringBuffer sb = new StringBuffer();
		
		IstarUserDAO dao = new IstarUserDAO();
		
		String hql = "SELECT batch. ID AS batch_id, batch.name FROM 	batch_students, 	batch, 	batch_group WHERE 	"
				+ "batch_students.batch_group_id = batch_group. ID AND batch.batch_group_id = batch_group. ID AND batch_students.student_id="+user.getId()+"";
		
		
		System.out.println("------batch-------->"+ hql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(hql);

		
		for (HashMap<String, Object> row : data) {
			Batch b =  new BatchDAO().findById(Integer.parseInt(row.get("batch_id").toString()));
			sb.append(" <tr>"

					+ "          <td class='project-title'>" + "          " + b.getName() + "-" + b.getName() + ""
					+ "                                          <br/>"
					+ "                                        <small>" + b.getBatchGroup().getCollege().getName()
					+ "</small>" + "                                  </td>"
					+ "                                  <td class='project-completion'>"
					+ "                                        <small>Completion with: " + getCompletionStatus(b)
					+ "%</small>" + "                                      <div class='progress progress-mini'>"
					+ "                                        <div style='width: " + getCompletionStatus(b)
					+ "%;' class='progress-bar'></div>" + "                                  </div>"
					+ "                        </td>" + "                      <td class='project-people'>");

			sb.append("          </td>" + "        <td class='project-actions'>" + "          <a href='" + baseURL
					+ "/orgadmin/student/user_batch.jsp?batch_id=" + b.getId()+"&user_id=" + user.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
					
					+ "  </td>" + "</tr>");
		}

		return sb;
	}
	public StringBuffer PrintTrainerBatchList(Student user, String baseURL) {
		StringBuffer sb = new StringBuffer();
		
		IstarUserDAO dao = new IstarUserDAO();
		
		String hql = "SELECT 	batch. ID AS batch_id, 	batch. NAME FROM 	trainer_batch, 	batch  "
				+ "WHERE 	 trainer_batch.batch_id = batch.ID AND trainer_batch.trainer_id = "+user.getId()+"";
		
		
		System.out.println("------batch-------->"+ hql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(hql);

		
		for (HashMap<String, Object> row : data) {
			Batch b =  new BatchDAO().findById(Integer.parseInt(row.get("batch_id").toString()));
			sb.append(" <tr>"

					+ "          <td class='project-title'>" + "          " + b.getName() + "-" + b.getName() + ""
					+ "                                          <br/>"
					+ "                                        <small>" + b.getBatchGroup().getCollege().getName()
					+ "</small>" + "                                  </td>"
					+ "                                  <td class='project-completion'>"
					+ "                                        <small>Completion with: " + getCompletionStatus(b)
					+ "%</small>" + "                                      <div class='progress progress-mini'>"
					+ "                                        <div style='width: " + getCompletionStatus(b)
					+ "%;' class='progress-bar'></div>" + "                                  </div>"
					+ "                        </td>" + "                      <td class='project-people'>");

			sb.append("          </td>" + "        <td class='project-actions'>" + "          <a href='" + baseURL
					+ "/orgadmin/student/trainerbatch.jsp?batch_id=" + b.getId()+"&user_id=" + user.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
					
					+ "  </td>" + "</tr>");
		}

		return sb;
	}
	
	public StringBuffer PrintTrainerToTBatchList(Student user, String baseURL) {
		StringBuffer sb = new StringBuffer();
		
		IstarUserDAO dao = new IstarUserDAO();
		
		String hql = "SELECT batch. ID AS batch_id, batch.name FROM 	batch_students, 	batch, 	batch_group WHERE 	"
				+ "batch_students.batch_group_id = batch_group. ID AND batch.batch_group_id = batch_group. ID AND batch_students.student_id="+user.getId()+"";
		
		
		System.out.println("------batch-------->"+ hql);
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(hql);

		
		for (HashMap<String, Object> row : data) {
			Batch b =  new BatchDAO().findById(Integer.parseInt(row.get("batch_id").toString()));
			sb.append(" <tr>"

					+ "          <td class='project-title'>" + "          " + b.getName() + "-" + b.getName() + ""
					+ "                                          <br/>"
					+ "                                        <small>" + b.getBatchGroup().getCollege().getName()
					+ "</small>" + "                                  </td>"
					+ "                                  <td class='project-completion'>"
					+ "                                        <small>Completion with: " + getCompletionStatus(b)
					+ "%</small>" + "                                      <div class='progress progress-mini'>"
					+ "                                        <div style='width: " + getCompletionStatus(b)
					+ "%;' class='progress-bar'></div>" + "                                  </div>"
					+ "                        </td>" + "                      <td class='project-people'>");

			sb.append("          </td>" + "        <td class='project-actions'>" + "          <a href='" + baseURL
					+ "/orgadmin/student/user_batch.jsp?batch_id=" + b.getId()+"&user_id=" + user.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
					
					+ "  </td>" + "</tr>");
		}

		return sb;
	}
}
