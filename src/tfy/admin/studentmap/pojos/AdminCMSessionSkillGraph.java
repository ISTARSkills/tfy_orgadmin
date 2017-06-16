/**
 * 
 */
package tfy.admin.studentmap.pojos;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author ISTAR-SERVER-PU-1
 *
 */
public class AdminCMSessionSkillGraph {

	HashMap<String, ArrayList<AdminCMSessionSkillData>> data ;

	public AdminCMSessionSkillGraph() {
		super();
		// TODO Auto-generated constructor stub
	}

	public HashMap<String, ArrayList<AdminCMSessionSkillData>> getData() {
		return data;
	}

	public void setData(HashMap<String, ArrayList<AdminCMSessionSkillData>> data) {
		this.data = data;
	}
	
	
	
}
