package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.IstarUser;

public abstract class ColumnHandler {

	public ColumnHandler() {
		super();
	}

	public abstract StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType);

	

}