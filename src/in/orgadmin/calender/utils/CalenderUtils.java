/**
 * 
 */
package in.orgadmin.calender.utils;

import java.util.HashMap;

/**
 * @author mayank
 *
 */
public class CalenderUtils {

	public StringBuffer getCalender(HashMap<String, String> input_params)
	{
		
		StringBuffer sb = new StringBuffer();
		String data_attr_str ="data-url='/get_events_controller?";
		for(String key : input_params.keySet())
		{
			//ViksitLogger.logMSG(this.getClass().getName(),"params ->"+key+" : value->"+ input_params.get(key));
			data_attr_str+=""+key+"="+input_params.get(key)+"&"; 
		}
		data_attr_str = data_attr_str.replaceAll("&$", "")+"'";
		sb.append("<div id='dashoboard_cal' class='p-xs b-r-lg border-left-right border-top-bottom border-size-sm orgadmin_calendar' "+data_attr_str+"></div>");
		return sb;
	}
}
