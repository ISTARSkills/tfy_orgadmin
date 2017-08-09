/**
 * 
 */
package in.orgadmin.utils.report;

public class ViewAttendaceDetails extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String value, int reportID) {
		int id = Integer.parseInt(value);
		StringBuffer button = new StringBuffer();
		button.append("<a id='" + id + "' class='btn btn-primary view_attendance btn-xs' data-toggle='modal' data-target='#myModal6'>View</a>");

		return button;
	}

	@Override
	public StringBuffer getOrder(String string, int reportID) {
		StringBuffer sb = new StringBuffer(string);

		return sb;
	}
}
