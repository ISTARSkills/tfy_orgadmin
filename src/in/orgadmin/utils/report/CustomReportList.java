/**
 * 
 */
package in.orgadmin.utils.report;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author mayank
 *
 */

@XmlRootElement(name = "custom_report_list")
public class CustomReportList {

	ArrayList<CustomReport> customReports= new ArrayList<>();

	@XmlElement(name = "custom_report")
	public ArrayList<CustomReport> getCustomReports() {
		return customReports;
	}

	public void setCustomReports(ArrayList<CustomReport> customReports) {
		this.customReports = customReports;
	}
	
	
	
}
