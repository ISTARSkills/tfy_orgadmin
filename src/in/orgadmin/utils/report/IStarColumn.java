/**
 * 
 */
package in.orgadmin.utils.report;

import javax.xml.bind.annotation.XmlAttribute;

/**
 * @author Vaibhav
 *
 */
public class IStarColumn {
	Boolean isVisible;
	String columnHandler;
	String displayName;
	String name;
	Boolean is_updatetable;
	String table_column;
	String edit_type;
	String select_options;
	boolean is_header;
	
	@XmlAttribute(name = "is_header")
	public boolean isIs_header() {
		return is_header;
	}

	public void setIs_header(boolean is_header) {
		this.is_header = is_header;
	}

	public IStarColumn(Boolean isVisible, String columnHandler, String displayName, String name) {
		super();
		this.isVisible = isVisible;
		this.columnHandler = columnHandler;
		this.displayName = displayName;
		this.name = name;
	}

	public IStarColumn() {
		super();
	}

	@XmlAttribute(name = "select_options")
	public String getSelect_options() {
		return select_options;
	}

	public void setSelect_options(String select_options) {
		this.select_options = select_options;
	}

	@XmlAttribute(name = "edit_type")
	public String getEdit_type() {
		return edit_type;
	}

	public void setEdit_type(String edit_type) {
		this.edit_type = edit_type;
	}

	@XmlAttribute(name = "is_updatetable")
	public Boolean getIs_updatetable() {
		return is_updatetable;
	}

	public void setIs_updatetable(Boolean is_updatetable) {
		this.is_updatetable = is_updatetable;
	}

	@XmlAttribute(name = "table_column")
	public String getTable_column() {
		return table_column;
	}

	public void setTable_column(String table_column) {
		this.table_column = table_column;
	}

	@XmlAttribute(name = "isVisible")
	public Boolean getIsVisible() {
		return isVisible;
	}

	public void setIsVisible(Boolean isVisible) {
		this.isVisible = isVisible;
	}

	@XmlAttribute(name = "columnHandler")
	public String getColumnHandler() {
		return columnHandler;
	}

	public void setColumnHandler(String columnHandler) {
		this.columnHandler = columnHandler;
	}

	@XmlAttribute(name = "display_name")
	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	@XmlAttribute(name = "name")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
