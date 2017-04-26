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
		StringBuffer sb = new StringBuffer("<div class='btn-group'> "
				+ "<button data-toggle='dropdown' class='btn btn-default btn-xs dropdown-toggle'> "
				+ "<span class='fa fa-ellipsis-v'></span> </button> <ul class='dropdown-menu pull-right'> <li>"
				+ "" + "" + "<a class='user-edit-popup' data-user_id='" + value+ "'  "
				+ " id=edit_user_button_" + value + ">Edit</button></li>	" + "</ul> </div>");
		return sb;
		
	}

}
