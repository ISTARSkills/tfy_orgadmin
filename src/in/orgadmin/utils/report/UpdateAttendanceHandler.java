/**
 * 
 */
package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.IstarUser;

/**
 * @author ComplexObject
 *
 */
public class UpdateAttendanceHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, com.istarindia.apps.dao.IstarUser, java.lang.String, int, int, java.lang.String)
	 */
	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		return new StringBuffer("<a href='/orgadmin/batch/attendance_per_event.jsp?event_id=" + taskID
				+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> Update </a> ");
	}

}
