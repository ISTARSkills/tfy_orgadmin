package in.orgadmin.utils.report;

import com.istarindia.apps.dao.IstarUser;

public class BooleanColumnHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		StringBuffer icon = new StringBuffer();
		System.err.println(status);
		if (status.equalsIgnoreCase("true")) {
			icon.append("<i class=\"fa fa-thumbs-o-up\" aria-hidden=\"true\"></i>");
		} else {
			icon.append("<i class=\"fa fa-thumbs-o-down\" aria-hidden=\"true\"></i>");
		}

		return icon;
	}
}
