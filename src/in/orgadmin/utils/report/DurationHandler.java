package in.orgadmin.utils.report;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.apache.commons.lang3.StringUtils;

import com.istarindia.apps.dao.IstarUser;

public class DurationHandler extends ColumnHandler {

	@Override
	public StringBuffer getHTML(String status, IstarUser user, String taskType, int taskID, int reportID,
			String itemType) {
		StringBuffer sb = new StringBuffer();
		//sb.append("ki");

		
		//System.out.println("status-- "+status);
		int duration = Integer.parseInt(status);
		
		if(duration <= 60){
			
			sb.append(duration+" min ");
			
		}else if((duration > 60) && (duration / 60 == 0)){
			
			sb.append(duration/60 + " hrs ");
			
		}else if((duration > 60) && (duration / 60 != 0)){
			/*System.out.println("duration---------------------"+duration);
			System.out.println("hrs---------------------"+duration/60);
			System.out.println("minss---------------------"+duration%60);
			*/
			sb.append(duration/60 + " hrs " + duration%60+" min ");
			
		}
		
	return sb;
	}

}
