/**
 * 
 */
package in.orgadmin.utils;

import java.util.Set;

import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.PlacementOfficer;
import com.istarindia.apps.dao.Recruiter;

/**
 * @author Vaibhav
 *
 */
public class UserInterfaceUtils {
	public static StringBuffer printSet(Set<Recruiter> rec) {
		
		StringBuffer out = new StringBuffer();
		for (Recruiter recruiter : rec) {
			out.append(recruiter.getEmail()+", ");
		}
		
		return out;
	}
	
	public static StringBuffer printSetTPO(Set<PlacementOfficer> allPlacementOfficer) {		
		StringBuffer out = new StringBuffer();
		for (PlacementOfficer placementOfficer : allPlacementOfficer) {
			out.append(placementOfficer.getEmail()+", ");
		}		
		return out;
	}
}
