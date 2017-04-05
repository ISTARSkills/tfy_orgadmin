package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.IstarUser;

public class BatchColumnHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		return new StringBuffer("<a href='/orgadmin/batch_group/dashboard.jsp?batch_group_id=" + taskID
				+ "' class='btn btn-primary btn-xs'><i class='fa fa-folder'></i> View </a> ");
	}

}
