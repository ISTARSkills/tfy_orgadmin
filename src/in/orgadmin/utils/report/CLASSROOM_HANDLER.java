package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;

public class CLASSROOM_HANDLER extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String value, int reportID) {
		BatchGroup group = new BatchGroupDAO().findById(Integer.parseInt(value));

		if (reportID == 3055) {
			return new StringBuffer(
					"<a class='btn btn-sm btn-danger m-l-lg' href='/super_admin/partials/modal/create_edit_classroom_modal.jsp?type=edit&class_id=" + value
							+ "'> Edit </a>");
		} else {
			return new StringBuffer(
					"<a class='btn btn-sm btn-danger m-l-lg' href='/orgadmin/partials/modal/create_edit_classroom_modal.jsp?type=edit&class_id=" + value
							+ "'> Edit </a>");
		}
	}

}
