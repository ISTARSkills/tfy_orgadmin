/**
 * 
 */
package in.talentify.core.xmlbeans;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;

/**
 * @author Vaibhav
 *
 */
public class ParentLink {
	String displayName;
	String valid_role;

	String url;
	String jsp_file;
	boolean is_visible_in_menu;
	
	
	
	public ParentLink() {
		super();
	}

	public ParentLink(String displayName, String valid_role, String url, String jsp_file, boolean is_visible_in_menu, ArrayList<ChildLink> children) {
		super();
		this.displayName = displayName;
		this.valid_role = valid_role;
		this.url = url;
		this.jsp_file = jsp_file;
		this.is_visible_in_menu = is_visible_in_menu;
		this.children = children;
	}

	@XmlAttribute(name="url")
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	@XmlAttribute(name="jsp_file")
	public String getJsp_file() {
		return jsp_file;
	}

	public void setJsp_file(String jsp_file) {
		this.jsp_file = jsp_file;
	}

	@XmlAttribute(name="is_visible_in_menu")
	public boolean isIs_visible_in_menu() {
		return is_visible_in_menu;
	}

	public void setIs_visible_in_menu(boolean is_visible_in_menu) {
		this.is_visible_in_menu = is_visible_in_menu;
	}

	ArrayList<ChildLink> children = new ArrayList<>();

	@XmlAttribute(name="display_name")
	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	@XmlElement(name="child_links")
	public ArrayList<ChildLink> getChildren() {
		return children;
	}

	public void setChildren(ArrayList<ChildLink> children) {
		this.children = children;
	}

	@XmlAttribute(name="valid_role")
	public String getValid_role() {
		return valid_role;
	}

	public void setValid_role(String valid_role) {
		this.valid_role = valid_role;
	}

	
	
	
	
}
