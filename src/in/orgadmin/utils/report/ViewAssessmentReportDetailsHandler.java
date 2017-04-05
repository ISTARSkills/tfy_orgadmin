/**
 * 
 */
package in.orgadmin.utils.report;

import org.apache.commons.lang3.StringUtils;

import com.viksitpro.core.dao.entities.IstarUser;

/**
 * @author Mayank
 *
 */
public class ViewAssessmentReportDetailsHandler extends ColumnHandler {

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
		
		String actor_id = StringUtils.substringBetween(status, "T", "A");
		String assessment_id = StringUtils.substringBetween(status, "A", "D");
		String date_time_key = StringUtils.substringBetween(status, "D", "E");
		
		System.out.println("------------------------"+actor_id+assessment_id+date_time_key);
		return new StringBuffer(
				"<a data-toggle='modal' class='btn btn-primary btn-xs' target='_blank' href='/orgadmin/batch/assessment_report.jsp?trainer_id="
						+ actor_id + "&assessment_id=" + assessment_id + "&date_time_key=" + date_time_key
						+ "'>Details</a>");

	}

}
