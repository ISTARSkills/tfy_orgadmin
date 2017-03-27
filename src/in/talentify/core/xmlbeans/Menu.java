/**
 * 
 */

/**
 * @author Vaibhav verma
 *
 */
/**
 * 
 */
package in.talentify.core.xmlbeans;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Vaibhav
 *
 */
@XmlRootElement
public class Menu {
	ArrayList<ParentLink> links = new ArrayList<>();

	@XmlElement(name="parent_links")
	public ArrayList<ParentLink> getLinks() {
		return links;
	}

	public void setLinks(ArrayList<ParentLink> links) {
		this.links = links;
	}
	
	
	
}
