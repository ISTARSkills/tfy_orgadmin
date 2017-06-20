/**
 * 
 */
package in.orgadmin.utils.report;

import com.viksitpro.core.dao.entities.IstarUser;

/**
 * @author mayank
 *
 */
public class TRAINER_ASSESSMENT_LIST_HANDLER extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, com.viksitpro.core.dao.entities.IstarUser, java.lang.String, int, int, java.lang.String)
	 */
	@Override
	public StringBuffer getHTML( String value, int reportID) {
		//10040!#Assessment - Direct tax VS Indirect tax, 10052!#Assessment - NBFC vs Banks, 10006!#Trainer - Maths
		StringBuffer sb = new StringBuffer();
		if(value!=null)
		{
			for(String str: value.split("!ASSESS!"))
			{
				String trainerId = str.split("!#")[0];
				String assessmentId = str.split("!#")[1];
				String title = str.split("!#")[2];
				sb.append("<a class='btn btn-danger btn-xs btn-outline' href='/trainer/interview_level_details.jsp?trainer_id="+trainerId+"&level=3&assessment_id="+assessmentId+"'>"+title+"</a>");
				sb.append("&nbsp;");
			}
		}
		
		return sb;
		
	}

}
