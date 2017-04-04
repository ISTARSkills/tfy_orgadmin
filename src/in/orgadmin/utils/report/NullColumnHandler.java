package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.IstarUser;

public class NullColumnHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		try {
			if (status == null || status.equalsIgnoreCase("null")) {
				return new StringBuffer("N/A");
			} else {
				return new StringBuffer(status);
			}
		} catch (Exception e) {
			return new StringBuffer("N/A");
		}
	}

}
