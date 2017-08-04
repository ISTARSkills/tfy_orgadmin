package in.orgadmin.utils.report;

public class TaskHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String value, int reportID) {
		StringBuffer sb = new StringBuffer();
		String[] values = value.split(",");
		String task_id = values[0];
		String status = values[1];
		String student_playlist_id = values[2];

		if (status.equalsIgnoreCase("SCHEDULED")) {
			sb.append("<div class='btn-group'>"
					+ "</button><a class='btn btn-danger btn-xs delete_task_btn' data-task_delete='task_delete' data-task='"
					+ task_id + "' data-student_playlist_id='" + student_playlist_id + "'>Delete</a></li>"

					+ "</div>");
		}
		sb.append("");
		return sb;
	}

	@Override
	public StringBuffer getOrder(String string, int reportID) {
		StringBuffer sb = new StringBuffer("");
		
		return sb;
	}
}