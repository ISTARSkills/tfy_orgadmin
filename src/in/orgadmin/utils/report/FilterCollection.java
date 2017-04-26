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
@XmlRootElement(name = "filter_lists")
public class FilterCollection {
	ArrayList<DataFilter> dataFilters = new ArrayList<>();

	@XmlElement(name = "filter")
	public ArrayList<DataFilter> getDataFilters() {
		return dataFilters;
	}

	public void setDataFilters(ArrayList<DataFilter> dataFilters) {
		this.dataFilters = dataFilters;
	}

	
}
