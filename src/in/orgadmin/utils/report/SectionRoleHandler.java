/**
 * 
 */
package in.orgadmin.utils.report;

/**
 * @author mayank
 *
 */
public class SectionRoleHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, int)
	 */
	@Override
	public StringBuffer getHTML(String value, int reportID) {
		
		return new StringBuffer("<button type='button' class='btn btn-xs btn-danger btn-sm '>Edit </button>");
	}

}
