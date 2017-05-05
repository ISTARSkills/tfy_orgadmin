/**
 * 
 */
package tfy.admin.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportUtils;

/**
 * @author mayank
 *
 */
public class AdminServices {

	public ArrayList<Course> getCoursesInCollege(int college_id)
	{
		CourseDAO dao = new CourseDAO();
		if(college_id==-3)
		{
			//super admin
			return (ArrayList<Course>)dao.findAll();
		}
		else
		{
			ArrayList<Course> courses = new ArrayList<>();
			ArrayList<Integer>alreadyAddedCourses = new ArrayList<>();
			Organization org = new OrganizationDAO().findById(college_id);
			for(BatchGroup bg : org.getBatchGroups())
			{
				for(Batch batch: bg.getBatchs())
				{
					if(!alreadyAddedCourses.contains(batch.getCourse().getId()))
					{
						alreadyAddedCourses.add(batch.getCourse().getId());
						courses.add(batch.getCourse());
					}
				}
			}
			
			return courses;
		}	
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList<BatchGroup> getBatchGroupInCollege(int college_id)
	{
		
		BatchGroupDAO dao = new BatchGroupDAO();
		ArrayList<BatchGroup> batchGroup = new ArrayList<>();
		if(college_id==-3)
		{
			//super admin
			return (ArrayList<BatchGroup>)dao.findAll();
		}
		else
		{
			
			Organization org = new OrganizationDAO().findById(college_id);
			
			batchGroup.addAll(org.getBatchGroups());
	
		}
		return batchGroup;
		
	}
	
	
	@SuppressWarnings("unchecked")
	public ArrayList<BatchGroup> getRolesInCollege(int college_id)
	{
		
		BatchGroupDAO dao = new BatchGroupDAO();
		ArrayList<BatchGroup> roles = new ArrayList<>();
		if(college_id==-3)
		{
			//super admin
			for(BatchGroup bg : (ArrayList<BatchGroup>) dao.findAll())
			{
				if(bg.getType().equalsIgnoreCase("ROLE"))
				{
					roles.add(bg);
				}
			}
		}
		else
		{
			
			Organization org = new OrganizationDAO().findById(college_id);
			
			for(BatchGroup bg :  org.getBatchGroups())
			{
				if(bg.getType().equalsIgnoreCase("ROLE"))
				{
					roles.add(bg);
				}
			}
	
		}
		return roles;
		
	}
	
	
	public List<HashMap<String, Object>> getAllContentAssosicatedSkills(int orgId, int entityId, String entityType) {
		System.out.println(entityType);
		String sql = "";
		CustomReportUtils repUtils= new CustomReportUtils();
		
		if (entityType.equalsIgnoreCase("User")) {
			CustomReport report = repUtils.getReport(22);
			sql = report.getSql().replaceAll(":user_id", entityId+"");
		} else if (entityType.equalsIgnoreCase("Group")) {
			CustomReport report = repUtils.getReport(23);
			sql = report.getSql().replaceAll(":section_id", entityId+"");
		} else if (entityType.equalsIgnoreCase("Role")) {
			CustomReport report = repUtils.getReport(24);
			sql = report.getSql().replaceAll(":role_id", entityId+"");
		}
		
		DBUTILS db = new DBUTILS();
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		return data;
	}
	
	
}
