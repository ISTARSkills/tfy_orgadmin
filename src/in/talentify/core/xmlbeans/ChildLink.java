/**
 * 
 */
package in.talentify.core.xmlbeans;

import javax.xml.bind.annotation.XmlAttribute;

/**
 * @author Vaibhav
 *
 */
public class ChildLink {
	String displayName;
	String url;
	String validRoles;
	String jsp_file;
	boolean is_visible_in_menu;

	
	
	
	public ChildLink() {
		super();
	}

	public ChildLink(String displayName, String url, String validRoles, String jsp_file, boolean is_visible_in_menu) {
		super();
		this.displayName = displayName;
		this.url = url;
		this.validRoles = validRoles;
		this.jsp_file = jsp_file;
		this.is_visible_in_menu = is_visible_in_menu;
	}

	@XmlAttribute(name = "jsp_file")
	public String getJsp_file() {
		return jsp_file;
	}

	public void setJsp_file(String jsp_file) {
		this.jsp_file = jsp_file;
	}

	@XmlAttribute(name = "is_visible_in_menu")
	public boolean isIs_visible_in_menu() {
		return is_visible_in_menu;
	}

	public void setIs_visible_in_menu(boolean is_visible_in_menu) {
		this.is_visible_in_menu = is_visible_in_menu;
	}

	@XmlAttribute(name = "display_name")
	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	@XmlAttribute(name = "url")
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	@XmlAttribute(name = "valid_roles")
	public String getValidRoles() {
		return validRoles;
	}

	public void setValidRoles(String validRoles) {
		this.validRoles = validRoles;
	}

}
