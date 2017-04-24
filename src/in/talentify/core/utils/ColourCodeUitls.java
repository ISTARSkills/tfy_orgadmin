package in.talentify.core.utils;

import in.talentify.core.services.CalenderColorCodes;

public class ColourCodeUitls {
	
	public StringBuffer getColourCode() {
		
		StringBuffer out = new StringBuffer();
		
		out.append("<div class='ibox-header'><h4 style='line-height: 25px;margin-left:12px'>"
				+ "	<span style='background-color:"+CalenderColorCodes.NOT_PUBLISHED+"' class='label label-primary '>NOT_PUBLISHED</span>"
				+ "	<span style='background-color:"+CalenderColorCodes.ASSESSMENT+"' class='label label-primary '>ASSESSMENT</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.SCHEDULED+"' class='label label-primary'>SCHEDULED</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.STARTED+"' class='label label-primary'>STARTED</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.TEACHING+"' class='label label-primary'>TEACHING</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.ATTENDANCE+"' class='label label-primary'>ATTENDANCE</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.FEEDBACK+"' class='label label-primary'>FEEDBACK</span> 		"
				+ "	<span style='background-color:"+CalenderColorCodes.COMPLETED+"' class='label label-primary'>COMPLETED</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.REACHED+"' class='label label-primary'>REACHED</span></h4> 	</div>");
		
		return out;
	}
	
public StringBuffer getColourCodeForReports() {
		
		StringBuffer out = new StringBuffer();
		//#C0392B
		out.append("<div class='ibox-header'><h4 style='    line-height: 25px;margin-left:12px''>"
				+ "	<span style='background-color:"+CalenderColorCodes.NOT_PUBLISHED+"' class='label label-primary '>NOT_PUBLISHED</span>"
				+ "	<span style='background-color:"+CalenderColorCodes.ASSESSMENT+"' class='label label-primary '>ASSESSMENT</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.SCHEDULED+"' class='label label-primary'>SCHEDULED</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.STARTED+"' class='label label-primary'>STARTED</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.TEACHING+"' class='label label-primary'>TEACHING</span> 	"
				+ " 	"
				
				+ "		"
				+ "		<span style='background-color:"+CalenderColorCodes.ATTENDANCE+"' class='label label-primary'>ATTENDANCE</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.FEEDBACK+"' class='label label-primary'>FEEDBACK</span> 		"
				+ "	<span style='background-color:"+CalenderColorCodes.COMPLETED+"' class='label label-primary'>COMPLETED</span> 	"
				+ "		<span style='background-color:"+CalenderColorCodes.REACHED+"' class='label label-primary'>REACHED</span>"
				+ "</h4> </div>");
		
		return out;
	}
	

}
