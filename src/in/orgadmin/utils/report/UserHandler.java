/**
 * 
 */
package in.orgadmin.utils.report;

/**
 * @author mayank
 *
 */
public class UserHandler extends ColumnHandler{

	@Override
	public StringBuffer getHTML(String value, int reportID) {
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='btn-group'><button data-toggle='dropdown' class='btn btn-danger btn-xs dropdown-toggle' aria-expanded='false'>Details&nbsp;<span class='caret'></span>"
				+ "</button><ul class='dropdown-menu'>"
				+ "<li><a href='#'>Profile</a></li>"
				+ "<li><a class='user-edit-popup' data-user_id="+value+">Edit</a></li>"				
				+ "</ul></div>");
		
		return sb;
	}

}
