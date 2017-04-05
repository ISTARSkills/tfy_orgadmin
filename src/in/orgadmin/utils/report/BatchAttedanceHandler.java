package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.IstarUser;

public class BatchAttedanceHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		return new StringBuffer("<a href='#'> Edit</a>  ");
	}

}
