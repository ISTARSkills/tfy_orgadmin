/**
 * 
 */
package in.orgadmin.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Query;

import com.istarindia.apps.dao.Batch;
import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.TrainerBatch;

/**
 * @author Mayank
 *
 */
public class BatchGroupUtils {
	public StringBuffer getStudentsInBatchGroup(BatchGroup b) {
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		String sql = "select T1.stu_id,  T1.name,T1.email, T1.user_type, T2.student_id as status from (select student.id as stu_id, student.name,student.email, student.user_type from student where  student.organization_id="
				+ b.getCollege().getId()
				+ " and student.user_type!='PRESENTOR' )  T1 left join (select distinct student_id from batch_students where batch_group_id="
				+ b.getId() + ")  T2 on (T1.stu_id = T2.student_id)";
		List<HashMap<String, Object>> data = util.executeQuery(sql);

		sb.append("<div class='table-responsive'>			  " + "<table class='table table-striped'>         "
				+ "    <thead>                                 " + "    <tr style='font-size:13px'>             "
				+ "                                            " + "        <th>ID </th>                        "
				+ "        <th>Student</th>                    " + "        <th>Email</th>                    "
				+ "		<th>User Type</th>                         " + "        <th>Add/Remove</th>                 "
				+ "    </tr>                                   " + "    </thead>"
				+"   <tbody>                                 " + "           ");

		for (HashMap<String, Object> row : data) {
			int id = (int) row.get("stu_id");
			String name = (String) row.get("name");
			String email = (String) row.get("email");
			String user_type = (String) row.get("user_type");
			String check_status = "";
			if (row.get("status") != null) {
				check_status = "checked";
			}
		
			sb.append("<tr style='font-size:13px'>     " + "        <td>" + id
					+ "</td>                           " + "		<td>" + name + "</td>                             "
					+ "		<td>" + email + "</td>                             " + "		<td>" + user_type
					+ "</td>                             " + "        <td id='checkbox-data'><input type='checkbox' " + check_status
					+ " class='i-checks1' value='" + id + "' name='user_id'></td> "
					+ "    </tr>                                           "
					+ "");

		}
sb.append("    </tbody>                                ");
		sb.append("<tfoot>                                                                             "
				+ "<tr style='font-size: 11px;'>                                                                                "
				+ "        <th>ID </th>                        " + "        <th>Student</th>                    "
				+ "        <th>Email</th>                    " + "		<th>Task</th>                         "
				+ "        <th>Add/Remove</th>                 "
				+ "</tr>                                                                               "
				+ "</tfoot>                                                                            "
				+ "</table>                                    " + "</div>                                      ");

		return sb;
	}

	public StringBuffer PrintBatchList(BatchGroup bg, String baseURL) {
		StringBuffer sb = new StringBuffer();
		IstarUserDAO dao = new IstarUserDAO();
		String hql = "from Batch isss where isss.batchGroup=:batch_group_id order by isss.order_id";
		Query query = dao.getSession().createQuery(hql);
		query.setInteger("batch_group_id", bg.getId());
		System.err.println(query.getQueryString());
		List<Batch> results = query.list();

		for (Batch b : results) {
			int course_id = b.getCourse().getId();
			int BatchGroupID = bg.getId();
			sb.append(" <tr>"

					+ "          <td class='project-title'>" + "          <a >" + b.getName()
					+ "-" + b.getId() + "</a>" + "                                          <br/>"
					+ "                                        <small>" + b.getBatchGroup().getCollege().getName()
					+ "</small>" + "                                  </td>"
					+ "                                  <td class='project-completion'>"
					+ "                                        <small>Completion with: " + getCompletionStatus(b)
					+ "%</small>" + "                                      <div class='progress progress-mini'>"
					+ "                                        <div style='width: " + getCompletionStatus(b)
					+ "%;' class='progress-bar'></div>" + "                                  </div>"
					+ "                        </td>" + "                      <td class='project-people'>");

			List<Integer> trainer_list = new ArrayList<>();
			for (TrainerBatch tb : b.getTrainerBatches()) {
				Student st = tb.getTrainer();
				if (!trainer_list.contains(st.getId())) {
					trainer_list.add(st.getId());
					String image_url = "img/a3.jpg";
					if (st.getImageUrl() != null) {
						image_url = st.getImageUrl();
					}
					sb.append("<a href='" + baseURL + "/orgadmin/student/dashboard.jsp?trainer_id=" + st.getId()
							+ "'><img title='" + st.getName() + "' alt='" + st.getName() + "' class='img-circle' src='"
							+ baseURL + image_url + "'></a>");
				}
			}
			sb.append("          </td>" + "        <td class='project-actions'>" + "          <a target='_new' href='"
					+ baseURL + "orgadmin/batch/dashboard.jsp?batch_id=" + b.getId()
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a>"
					+ "         <a target='_blank' href='/orgadmin/batch/edit_batch.jsp?batch_id=" + b.getId() +"&course_id=" + course_id +"&batch_group="+BatchGroupID
					+ "' class='btn btn-primary btn-xs'><i class='fa fa-pencil'></i> Edit  </a>" + "  </td>" + "</tr>");
		}

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
}
