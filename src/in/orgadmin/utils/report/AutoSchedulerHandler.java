package in.orgadmin.utils.report;

public class AutoSchedulerHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String value, int reportID) {
		StringBuffer sb = new StringBuffer();
		String[] values = value.split(",");
		String task_count = values[0];
		String start_date = values[1];
		String end_date = values[2];
		String course = values[3];
		String entity_type = values[4];
		String entity_id = values[5];

			sb.append("<div class='btn-group'>"
					+ "</button><a class='btn btn-danger btn-xs delete_task_btn' data-task_delete='auto_scheduler_task_delete' data-start_date='"
					+ start_date + "' data-end_date='" + end_date + "'" + "data-course='" + course + "' data-end_date='"
					+ end_date + "' data-entity_type='" + entity_type + "' data-entity_id='" + entity_id
					+ "'>Delete</a></li>"

					+ "</div>");
		sb.append("");
		return sb;
	}

}