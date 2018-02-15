/**
 * 
 */
package tfy.admin.studentmap.pojos;

import java.util.ArrayList;

/**
 * @author ISTAR-SERVER-PU-1
 *
 */
public class AdminCMSessionSkillData {

	String name;
	ArrayList<ArrayList<Object>> data;
	public AdminCMSessionSkillData() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public ArrayList<ArrayList<Object>> getData() {
		return data;
	}
	public void setData(ArrayList<ArrayList<Object>> data) {
		this.data = data;
	} 
	
	
	
}
