/**
 * 
 */
package in.orgadmin.utils.report;

/**
 * @author Mayank
 *
 */
public class EventSessionDetailsHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, int)
	 */
	@Override
	public StringBuffer getHTML(String value, int reportID) {
		return new StringBuffer(
				"<button class='btn btn-xs btn-danger batch-session-button' data-event-id='"+value+"'> Details </button>");		
	}

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getOrder(java.lang.String, int)
	 */
	@Override
	public StringBuffer getOrder(String string, int reportID) {
StringBuffer sb = new StringBuffer(string);
		
		return sb;
	}

}
