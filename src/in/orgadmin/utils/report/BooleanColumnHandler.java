/**
 * 
 */
package in.orgadmin.utils.report;

/**
 * @author Istar
 *
 */
public class BooleanColumnHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, int)
	 */
	@Override
	public StringBuffer getHTML(String value, int reportID) {
		
		Boolean val = Boolean.parseBoolean(value);
		if(val)
		{
			return new StringBuffer("<i class='fa fa-check' style=' color: #1ab394;'></i>");
		}
		else
		{
			return new StringBuffer("<i class='fa fa-times' aria-hidden='true' style='color: #ed5565;'></i>");
		}	
		
	}
	
	
	@Override
	public StringBuffer getOrder(String string, int reportID) {
		StringBuffer sb = new StringBuffer(string);
		
		return sb;
	}

}
