/**
 * 
 */
package in.orgadmin.utils.report;

/**
 * @author Istar
 *
 */
public class DecimalColumnHandler extends ColumnHandler {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.report.ColumnHandler#getHTML(java.lang.String, int)
	 */
	@Override
	public StringBuffer getHTML(String value, int reportID) {
		int rating = (int)Float.parseFloat(value);
		StringBuffer stars=new StringBuffer();
		if(rating > 0){
			
			for(int i=0; i<rating ; i++)
			{
				stars.append("<i class='fa fa-star' style='    color: #ed5565;'></i>");
			}
			if(rating <5){
			for(int j=rating; j<5;j++){
				stars.append("<i class='fa fa-star-o' style='    color: #ed5565;'></i>");
			}
			}
		}else{
			 stars=new StringBuffer("<i class='fa fa-star-o' style='    color: #ed5565;'></i><i class='fa fa-star-o' style='    color: #ed5565;'></i><i class='fa fa-star-o' style='    color: #ed5565;'></i><i class='fa fa-star-o' style='    color: #ed5565;'></i><i class='fa fa-star-o' style='    color: #ed5565;'></i>");
			
		}
		
		return stars;
	}

}