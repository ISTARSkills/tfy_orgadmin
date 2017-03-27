/**
 * 
 */
package in.orgadmin.utils.report;

import com.istarindia.apps.dao.IstarUser;

/**
 * @author Mayank
 *
 */
public class EditTrainerHandler extends ColumnHandler {

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
		return new StringBuffer("<a href='/orgadmin/trainer/edit_trainerlist.jsp?trainer_id="+taskID+"'> Edit</a>  ");

	}

}
