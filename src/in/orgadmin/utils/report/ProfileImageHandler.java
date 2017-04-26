/**
 * 
 */
package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.IstarUser;

/**
 * @author mayank
 *
 */
public class ProfileImageHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, com.viksitpro.core.dao.entities.IstarUser, java.lang.String, int, int, java.lang.String)
	 */
	@Override
	public StringBuffer getHTML( String value, int reportID) {
		
		return new StringBuffer("<img style='width:27px' src='" + value+ "' class='img-sm img-circle'>");
		
	}

}
