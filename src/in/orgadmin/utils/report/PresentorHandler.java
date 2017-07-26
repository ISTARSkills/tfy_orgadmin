package in.orgadmin.utils.report;

public class PresentorHandler extends ColumnHandler{

	@Override
	public StringBuffer getHTML(String value, int reportID) {
		
		StringBuffer sb = new StringBuffer();
		if(value != null){
			if(!value.split("!#")[1].equalsIgnoreCase("N/A")){
				sb.append(value.split("!#")[1]);
			}else {
				sb.append("<a class='btn btn-primary btn-xs presentor_anchor' data-trainer_id='"+value.split("!#")[0]+"'>Create Presentor</a>");
			}
		}
		
		
		return sb;
	}
}
