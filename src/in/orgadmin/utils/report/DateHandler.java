package in.orgadmin.utils.report;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import com.istarindia.apps.dao.IstarUser;

public class DateHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		StringBuffer date = new StringBuffer();

		SimpleDateFormat from = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		SimpleDateFormat to = new SimpleDateFormat("dd MMM yyyy hh:mm a");

		try {
			date.append(to.format(from.parse(status)));
		} catch (ParseException e) {
			date.append("");
			e.printStackTrace();
		}
		return date;
	}

}
