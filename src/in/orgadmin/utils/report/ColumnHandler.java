package in.orgadmin.utils.report;

import com.istarindia.apps.dao.IstarUser;

public abstract class ColumnHandler {

	public ColumnHandler() {
		super();
	}

	public abstract StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType);

}