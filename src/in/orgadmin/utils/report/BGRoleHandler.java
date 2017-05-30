/**
 * 
 */
package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;

/**
 * @author mayank
 *
 */
public class BGRoleHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, int)
	 */
	@Override
	public StringBuffer getHTML(String value, int reportID) {
		
		BatchGroup group = new BatchGroupDAO().findById(Integer.parseInt(value));
		return new StringBuffer("<div class='btn-group'><button data-toggle='dropdown' class='btn btn-danger btn-xs dropdown-toggle' aria-expanded='false'>Details<span class='caret'></span>"
				+ "</button><ul class='dropdown-menu'>"				
				+ "<li><a class='group-edit-popup' data-group_id='"+value+"'>Edit</a></li>"
				
				+ "<li><a data-group_id='"+value+"' data-group_name='"+group.getName()+"' class='delete_group'>Delete</a></li>"
				+ "</ul></div>");
	}

}
