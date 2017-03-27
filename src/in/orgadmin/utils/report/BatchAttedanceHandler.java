package in.orgadmin.utils.report;

import com.istarindia.apps.dao.IstarUser;

public class BatchAttedanceHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		return new StringBuffer("<a href='#'> Edit</a>  ");
	}

}
