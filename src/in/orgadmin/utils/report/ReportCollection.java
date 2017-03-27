/**
 * 
 */
package in.orgadmin.utils.report;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Vaibhav
 *
 */

@XmlRootElement(name = "istar_reports")
public class ReportCollection {

	ArrayList<Report> reports = new ArrayList<>();

	@XmlElement(name = "reports")
	public ArrayList<Report> getReports() {
		return reports;
	}

	public void setReports(ArrayList<Report> reports) {
		this.reports = reports;
	}

}
