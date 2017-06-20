/**
 * 
 */
package tfy.admin.studentmap.pojos;

import java.util.ArrayList;

/**
 * @author ISTAR-SERVER-PU-1
 *
 */
public class AdminSkillGraph {

	String name;
	ArrayList<AdminModuleSkill> data;
	public AdminSkillGraph() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public ArrayList<AdminModuleSkill> getData() {
		return data;
	}
	public void setData(ArrayList<AdminModuleSkill> data) {
		this.data = data;
	}
	
	
	
	
}
