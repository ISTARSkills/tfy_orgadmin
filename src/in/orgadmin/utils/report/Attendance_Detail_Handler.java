/**
 * 
 */
package in.orgadmin.utils.report;

import org.apache.commons.lang3.StringUtils;

import com.istarindia.apps.dao.IstarUser;

/**
 * @author Mayank
 *
 */
public class Attendance_Detail_Handler extends ColumnHandler {

	/*
	 * (non-Javadoc)
	 * 
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String,
	 * com.istarindia.apps.dao.IstarUser, java.lang.String, int, int,
	 * java.lang.String)
	 */
	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		// status srting format :
		// "B"+batch_id+"A"+assessment_id+"D"+date+"T"+time+'E'.
		// Example : B35A10030D20160907T092500E
		String batch_id = StringUtils.substringBetween(status, "B", "A");
		String event_id = StringUtils.substringBetween(status, "A", "D");
		String date_time_key = StringUtils.substringBetween(status, "D", "E");
		String trainer_name = StringUtils.substringBetween(status, "E", "F");
		return new StringBuffer(
				"<a data-toggle='modal' class='btn btn-primary btn-xs' target='_blank' href='/orgadmin/batch/attendance_details.jsp?batch_id="
						+ batch_id + "&event_id=" + event_id + "&date_time_key=" + date_time_key
						+ "&trainer_name=" + trainer_name +"'>Print</a>");

	}

}
