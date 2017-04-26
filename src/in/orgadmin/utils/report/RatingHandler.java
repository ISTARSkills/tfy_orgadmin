/**
 * 
 */
package in.orgadmin.utils.report;

/**
 * @author mayank
 *
 */
public class RatingHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, int)
	 */
	@Override
	public StringBuffer getHTML(String value, int reportID) {
		int rating = Integer.parseInt(value);
		StringBuffer stars=new StringBuffer("<i class='fa fa-star'></i>");
		for(int i=0; i<rating ; i++)
		{
			stars.append("<i class='fa fa-star'></i>");
		}
		return stars;
	}

}
