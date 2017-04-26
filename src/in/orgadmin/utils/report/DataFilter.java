/**
 * 
 */
package in.orgadmin.utils.report;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;

/**
 * @author mayank
 *
 */
public class DataFilter {

	int id;
	String typeOfFilter;
	int relatedReportListId;
	String sql;
	String title;
	
	@XmlAttribute(name = "id")
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	@XmlAttribute(name = "type_of_filter")
	public String getTypeOfFilter() {
		return typeOfFilter;
	}
	public void setTypeOfFilter(String typeOfFilter) {
		this.typeOfFilter = typeOfFilter;
	}
	@XmlAttribute(name = "related_report_list")
	public int getRelatedReportListId() {
		return relatedReportListId;
	}
	public void setRelatedReportListId(int relatedReportListId) {
		this.relatedReportListId = relatedReportListId;
	}
	@XmlElement(name="sql")
	public String getSql() {
		return sql;
	}
	public void setSql(String sql) {
		this.sql = sql;
	}
	@XmlElement(name="title")
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public DataFilter() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	
}
