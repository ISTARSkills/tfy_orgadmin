/**
 * 
 */
package tfy.admin.studentmap.pojos;

/**
 * @author ISTAR-SERVER-PU-1
 *
 */
public class AdminModuleSkill {

	String name;
	Float  y;
	Boolean drilldown;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public Boolean getDrilldown() {
		return drilldown;
	}
	public void setDrilldown(Boolean drilldown) {
		this.drilldown = drilldown;
	}
	public AdminModuleSkill() {
		super();
	}
	public Float getY() {
		return y;
	}
	public void setY(Float y) {
		this.y = y;
	}
	
	
	
}
